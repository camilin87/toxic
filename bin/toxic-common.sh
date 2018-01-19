#!/bin/bash

if [ -z "${TOXIC_HOME}" ]; then
    bin=`dirname $0`
    if [[ "." == $bin ]]; then
      bin="$PWD"
    fi
    TOXIC_HOME=`dirname $bin`
fi

classpath=""
doDir=""
otherArgs=""

while [[ $# != 0 ]]; do
  arg=$1
  equalPos=`expr "$arg" : "[-a-zA-Z]*="`
    prompt=${arg:0:$equalPos}
    value=${arg:$equalPos}

  if [[ $prompt == "-cp=" ]]; then
    classpath=$value
  else
    otherArgs="$otherArgs $arg"
  fi

  shift
done

classpath="$classpath:${TOXIC_HOME}/conf"
classpath="$classpath:${TOXIC_HOME}/current/conf"
classpath="$classpath:${TOXIC_HOME}/current/resources"
classpath="$classpath:${TOXIC_HOME}/current/gen/classes"
classpath="$classpath:${TOXIC_HOME}/current/lib/*"

# Leaving these paths in place to make local toxic builds/executions easier
classpath="$classpath:${TOXIC_HOME}/resources"
classpath="$classpath:${TOXIC_HOME}/gen/classes"
classpath="$classpath:${TOXIC_HOME}/gen/dependencies/jars/*"
classpath="$classpath:${TOXIC_HOME}/lib/*"

if [ -n "${TOXIC_HEAP_MAX}" ]; then
  TOXIC_JRE_OPTIONS="${TOXIC_JRE_OPTIONS} -Xmx${TOXIC_HEAP_MAX}"
fi
if [ -n "${TOXIC_PERMGEN_MAX}" ]; then
  TOXIC_JRE_OPTIONS="${TOXIC_JRE_OPTIONS} -XX:MaxPermSize=${TOXIC_PERMGEN_MAX}"
fi

if [ -d "${TOXIC_HOME}/jre" ]; then
  export JAVA_HOME="${TOXIC_HOME}/jre"
elif [ -d "${TOXIC_HOME}/current/jre" ]; then
  export JAVA_HOME="${TOXIC_HOME}/current/jre"
fi
if [ ! -d "${JAVA_HOME}" ]; then
  echo "Unable to locate a working JAVA_HOME; exiting."
  exit 1
fi
PATH="${JAVA_HOME}/bin:$PATH"

baseToxicCmd="java -XX:+CMSClassUnloadingEnabled $TOXIC_JRE_OPTIONS -cp $classpath -DTOXIC_HOME=${TOXIC_HOME}"

