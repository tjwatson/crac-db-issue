#!/usr/bin/env bash
set -e -x

if [ $# -lt 1 ]
then
  CONTAINER_TOOL=podman
else
  CONTAINER_TOOL=$1
fi
echo "Using $CONTAINER_TOOL"

echo "Starting db for test..."

$CONTAINER_TOOL-compose -f docker-compose-maven.yml up -d

echo "maven package..."
./mvnw clean package

echo "Stopping db for test ..."
$CONTAINER_TOOL-compose -f docker-compose-maven.yml down

