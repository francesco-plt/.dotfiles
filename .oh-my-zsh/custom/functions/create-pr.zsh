function create_pr() {
 
  local source=""
  local destination="develop"
  local profile="bck-developer--services-prod-853453649716"

  if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "Error: Not in a git folder."
    return 1
  fi

  local current_branch=$(git symbolic-ref --short HEAD)
  local repository=$(basename "$(git rev-parse --show-toplevel)")

  if [[ $current_branch == feature* ]]; then
    source=$current_branch
  else
    echo "Error: Current branch is not a feature branch."
    return 1
  fi

  if [ -z "$source" ]; then
      echo "Error: Source branch is empty."
      echo "Something went wrong :/"
      return 1
  fi

  local create_output=$(aws codecommit create-pull-request \
    --title "$source" \
    --targets "repositoryName=$repository,sourceReference=$source,destinationReference=$destination" \
    --client-request-token "$(date +%s)" \
    --profile $profile)
  local pr_id=$(echo "$create_output" | jq -r '.pullRequest.pullRequestId')
  echo -n "https://eu-west-1.console.aws.amazon.com/codesuite/codecommit/repositories/$repository/pull-requests/$pr_id/changes"
}
