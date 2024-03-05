#!/usr/bin/env bash
set -e -x

if [ $# -lt 1 ]
then
  CONTAINER_TOOL=podman
else
  CONTAINER_TOOL=$1
fi
echo "Using $CONTAINER_TOOL"

$CONTAINER_TOOL-compose -f docker-compose-restore.yml down
