#!/bin/bash
echo "Running entrypoint.sh"
set -e

echo "Remove any server.pid"
# Remove a potentially pre-existing server.pid for Rails.
rm -f /eval-webapp/tmp/pids/server.pid

# For prod we bundle inside the dockerfile, not the entrypoint
# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"
