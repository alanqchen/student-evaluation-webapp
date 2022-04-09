#!/bin/bash
echo "Running entrypoint.sh"
set -e
# For prod we bundle inside the dockerfile, not the entrypoint
# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"
