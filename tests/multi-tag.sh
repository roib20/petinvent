#! /bin/sh

/bin/sh ./tests/docker-run-and-test.sh "python:3.10-alpine" "postgres:14-alpine"
/bin/sh ./tests/docker-run-and-test.sh "python:3.10-alpine" "postgres:15-alpine"
/bin/sh ./tests/docker-run-and-test.sh "python:3.11-alpine" "postgres:14-alpine"
/bin/sh ./tests/docker-run-and-test.sh "python:3.11-alpine" "postgres:15-alpine"