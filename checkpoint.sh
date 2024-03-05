#!/usr/bin/env bash
set -e -x

if [ $# -lt 1 ]
then
  CONTAINER_TOOL=podman
else
  CONTAINER_TOOL=$1
fi
echo "Using $CONTAINER_TOOL"

case $(uname -m) in
    arm64)   url="https://cdn.azul.com/zulu/bin/zulu17.48.15-ca-crac-jdk17.0.10-linux__aarch64.tar.gz" ;;
    *)       url="https://cdn.azul.com/zulu/bin/zulu17.48.15-ca-crac-jdk17.0.10-linux_x64.tar.gz" ;;
esac

echo "Using CRaC enabled JDK $url"

$CONTAINER_TOOL build -t tjwatson/crac-db-sample:builder --build-arg CRAC_JDK_URL=$url .
$CONTAINER_TOOL-compose -f docker-compose-checkpoint.yml up -d

echo "Please wait during creating the checkpoint..."
sleep 35
$CONTAINER_TOOL logs crac-db-sample

$CONTAINER_TOOL commit $($CONTAINER_TOOL ps -qf "name=crac-db-sample") tjwatson/crac-db-sample:checkpoint
$CONTAINER_TOOL-compose -f docker-compose-checkpoint.yml down
