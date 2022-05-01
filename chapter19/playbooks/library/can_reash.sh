#!/bin/bash -e
# WANT_JSON
# Read the variables from the file with jq
host=$(jq -r .host <"$1")
port=$(jq -r .port <"$1")
timeout=$(jq -r .timeout <"$1")

# Default timeout=3
if [[ $timeout = null ]]; then
    timeout=3
fi
# Check if we can reach the host
if nc -z -w "$timeout" "$host" "$port"; then
    echo '{"changed": false}'
else
    echo "{\"failed\": true, \"msg\": \"could not reach $host:$port\"}"
fi
