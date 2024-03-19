function update_git_branches() {

  git fetch --all
  for branch in $(git for-each-ref --format='%(refname:short)' refs/heads/); do
    git checkout $branch
    git pull origin $branch
  done

  git checkout -
}
