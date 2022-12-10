#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /app/tmp/pids/server.pid

bundle install
rails db:migrate
rails db:test:prepare
rails db:seed

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"
