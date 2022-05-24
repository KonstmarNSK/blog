#!/bin/bash

# THIS FILE IS INTENDED TO RUN WITHIN A DOCKER CONTAINER IN ONE DIRECTORY WITH THE JAR FILE

JAVA_OPTS=""

echo "debug_build: ${DEBUG_BUILD}"

if [ "${DEBUG_BUILD}" = "true" ]; then
  echo " THIS IS DEBUG BUILD"

  if [ "$DEBUG_PORT" = "" ]; then
      echo "DEBUG_PORT is not set!"
      exit 1
  fi

  echo "DEBUG PORT IS $DEBUG_PORT"
  JAVA_OPTS="$JAVA_OPTS -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:$DEBUG_PORT"

else
  echo " THIS IS PROD BUILD"
fi

java $JAVA_OPTS -jar /app/blog.jar
