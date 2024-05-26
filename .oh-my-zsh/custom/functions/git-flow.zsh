function git_flow_new_release_and_deploy_test_staging() {
    local release_number=$1
    local service_name=$(basename "$(git rev-parse --show-toplevel)" | sed 's/^bck_//')
    git flow release start $release_number
    sed -i '' "s/\(spring.application.version=\).*/\1$release_number/" src/main/resources/application.properties
    git commit -am "Release $release_number version bump"
    git push && git deploy test && git deploy staging
    backend-auto-slack.py -s $service_name -v $release_number
}
