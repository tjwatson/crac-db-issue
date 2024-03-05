#!/bin/bash

CRAC_FILES_DIR=`eval echo ${CRAC_FILES_DIR}`
mkdir -p $CRAC_FILES_DIR

if [ -z "$(ls -A $CRAC_FILES_DIR)" ]; then
  if [ "$FLAG" = "-r" ]; then
    echo "Doing checkpoint onRefresh"
    echo 128 > /proc/sys/kernel/ns_last_pid; java -Dspring.context.checkpoint=onRefresh -Dmanagement.endpoint.health.probes.add-additional-paths="true" -Dmanagement.health.probes.enabled="true" -XX:CRaCCheckpointTo=$CRAC_FILES_DIR -jar /opt/app/crac-db-sample-0.0.1-SNAPSHOT.jar
  else
    echo "Doing checkpoint after app has started for 30 seconds"
    echo 128 > /proc/sys/kernel/ns_last_pid; java -Dmanagement.endpoint.health.probes.add-additional-paths="true" -Dmanagement.health.probes.enabled="true" -XX:CRaCCheckpointTo=$CRAC_FILES_DIR -jar /opt/app/crac-db-sample-0.0.1-SNAPSHOT.jar&
    sleep 30
    jcmd /opt/app/crac-db-sample-0.0.1-SNAPSHOT.jar JDK.checkpoint
  fi
  sleep infinity
else
  java -Dmanagement.endpoint.health.probes.add-additional-paths="true" -Dmanagement.health.probes.enabled="true" -XX:CRaCRestoreFrom=$CRAC_FILES_DIR&
  PID=$!
  trap "kill $PID" SIGINT SIGTERM
  wait $PID
fi
