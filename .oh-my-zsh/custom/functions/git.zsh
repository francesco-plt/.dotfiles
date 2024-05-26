function git_merge() {

    if [ $# -ne 2 ]; then
        echo "Usage: $FUNCNAME <source> <dest>"
        return 1
    fi

    local source="$1"
    local destination="$2"

    git checkout $destination
    git merge $source
}

function git_push() {

    if [ $# -ne 1 ]; then
        echo "add, commit and push at once"
        echo "Usage: $FUNCNAME <commit_message>"
        return 1
    fi

    local message="$1"
    git add .
    git commit -am "$message"
    git push
}

function confirm_prod_deploy() {
    printf >&2 '%s ' 'Are you sure you want to push in prod? (y/n) '
    read confirmation
    if [ "$confirmation" == "y" ] || [ "$confirmation" == "Y" ]; then
        command git deploy prod
    else
        echo "Deploy canceled."
    fi
}

function pull_all() {

    for branch in $(git for-each-ref --format='%(refname:short)' refs/heads/); do
        echo "Pulling $branch"
        git checkout $branch
        git pull
    done
    git checkout develop
}

function git_log() {
    local branch_name="$(git symbolic-ref --short HEAD)"
    git log "origin/${branch_name}.."${branch_name} | git log --stdin
}

function git_changes() {
    current_branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    if [ -z "$current_branch" ]; then
        echo "Not in a Git repository."
        return 1
    fi

    if ! git show-ref --quiet refs/heads/develop; then
        echo "The 'develop' branch does not exist."
        return 1
    fi

    num_changes=$(git diff --name-only develop...$current_branch | wc -l)
    changed_files=$(git diff --name-only develop...$current_branch)

    echo "Number of changed files: $num_changes"
    if [ "$num_changes" -gt 0 ]; then
        echo "Changed files:"
        echo "$changed_files"
    fi
}

function git_delete_local_branches () {
    local branches
    branches=$(git branch | grep -vE '^\*|develop|master|main|staging|test' | sed 's/^[ *]*//')
    
    if [ -z "$branches" ]; then
        echo "No branches to delete."
        return
    fi

    echo "Deleting local branches:"
    echo "$branches"

    echo "$branches" | while read -r branch; do
        echo "Deleting branch: $branch"
        git branch -d "$branch"
    done

    if [ "$1" = "-r" ]; then
        echo "$branches" | while read -r branch; do
            echo "Deleting remote branch: $branch"
            git push origin --delete "$branch"
        done
    fi
}


function git_delete_branches() {
    local branches_to_delete
    branches_to_delete=$(git branch | awk '!/(\* )?(develop|master|main|staging|test)$/ {print}')

    if [ -z "$branches_to_delete" ]; then
        echo "No branches to delete."
        return 1
    fi

    echo "Branches to be deleted:"
    echo "$branches_to_delete"

    printf >&2 '%s ' 'Are you sure you want to delete these branches? (y/n): '
    read confirmation
    if [ "$confirmation" != "y" ]; then
        echo "Operation canceled."
        return 1
    fi

    # Delete local branches
    echo "$branches_to_delete" | xargs git branch -d

    # Delete remote branches
    printf >&2 '%s ' 'Do you want to delete these branches on the remote repository as well? (y/n): '
    if [ "$remote_confirmation" == "y" ]; then
        echo "$branches_to_delete" | xargs -I {} git push origin --delete {}
    fi
}

function git_delete_current_branch() {
    local current_branch
    current_branch=$(git rev-parse --abbrev-ref HEAD)

    if [[ "$current_branch" =~ ^(develop|master|main|staging|test)$ ]]; then
        echo "You are on a protected branch ($current_branch). Operation canceled."
        return 1
    fi

    printf >&2 '%s ' "You are about to delete the current branch '$current_branch'. Are you sure? (y/n): "
    read confirmation
    if [ "$confirmation" != "y" ]; then
        echo "Operation canceled."
        return 1
    fi

    # Checkout to develop before deleting
    git checkout develop || {
        echo "Failed to checkout 'develop'. Make sure it exists and is up to date."
        return 1
    }

    # Delete local branch
    git branch -d "$current_branch" || {
        echo "Failed to delete the local branch '$current_branch'."
        return 1
    }

    # Ask for remote deletion
    printf >&2 '%s ' "Do you want to delete the branch '$current_branch' on the remote repository as well? (y/n): "
    read remote_confirmation
    if [ "$remote_confirmation" == "y" ]; then
        git push origin --delete "$current_branch" || {
            echo "Failed to delete the remote branch '$current_branch'."
            return 1
        }
    fi

    echo "Branch '$current_branch' has been successfully deleted."
}

function git_close_release() {

    current_branch=$(git rev-parse --abbrev-ref HEAD)
    if [[ ! $current_branch =~ ^release/([0-9]+\.){2}[0-9]+$ ]]; then
        echo "You are not on a valid release branch."
        return 1
    fi

    # update local
    git fetch --all

    # Finish git flow release
    git flow release finish
    
    # Push develop and tags
    git checkout develop && git push && git push --tags

    # Push master and tags
    git checkout master && git push && git push --tags

    echo "Release $RELEASE_VERSION finished and pushed successfully."
	git checkout develop
}
