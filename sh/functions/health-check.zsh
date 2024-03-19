function health_check() {
	if [ $# -ne 2 ]; then
	    echo "Usage: execute_curl <service_name> <env>"
		return 1
	fi

	local service_name="$1"
	local env="$2"

	local endpoint="http://${env}-${service_name}.satispay.aws/health/check"
	if [ "$env" = "prod" ]; then
		endpoint="http://internal-api.satispay.aws/${service_name}/health/check"
	fi

	local output=$(curl -i -sS $endpoint)
	# echo $output
	# local status_code=$?
	
	    if [ $? -ne 0 ]; then
	        echo "Error occurred while executing curl command"
	        exit 127
        fi
	        
	local temp_file=$(mktemp)

	echo "**Status code**: $(awk 'NR==1 {print $2}' <<< "$output")
	**cid**: $(grep -i 'x-satispay-cid:' <<< "$output" | awk '{print $2}')
	**version**: $(grep -i 'x-satispay-service-version:' <<< "$output" | awk '{print $2}')" > "$temp_file"
	
	#cat $temp_file
	glow $temp_file
	rm $temp_file
}
