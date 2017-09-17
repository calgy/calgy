#!/bin/bash
#
# Waits for the db container to finish starting up before continuing.
#

set -e

until nc -z db 5432; do
  echo "Waiting for postgres..."
  sleep 1
done
echo "Postgres is up!"

exec "$@"
