#!/bin/sh
# ----------------------------------------------------------------------------
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements. See the NOTICE file
# distributed with this work for additional information.
# Maven Wrapper startup script for POSIX systems (Linux / macOS)
# ----------------------------------------------------------------------------

if [ -z "$JAVA_HOME" ]; then
  JAVACMD="$(which java)"
else
  JAVACMD="$JAVA_HOME/bin/java"
fi

if [ ! -x "$JAVACMD" ]; then
  echo "Error: JAVA_HOME is not set and no 'java' command was found in your PATH." >&2
  echo "Please set JAVA_HOME or install Java 21 or later." >&2
  exit 1
fi

# Locate the script directory
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
MAVEN_WRAPPER_JAR="$SCRIPT_DIR/.mvn/wrapper/maven-wrapper.jar"
MAVEN_WRAPPER_PROPERTIES="$SCRIPT_DIR/.mvn/wrapper/maven-wrapper.properties"

# Download the wrapper JAR if absent
if [ ! -f "$MAVEN_WRAPPER_JAR" ]; then
  WRAPPER_URL=$(grep wrapperUrl "$MAVEN_WRAPPER_PROPERTIES" | sed 's/.*=//')
  echo "Downloading Maven Wrapper JAR from $WRAPPER_URL"
  mkdir -p "$(dirname "$MAVEN_WRAPPER_JAR")"
  if command -v curl > /dev/null 2>&1; then
    curl -o "$MAVEN_WRAPPER_JAR" "$WRAPPER_URL" 2>&1
  elif command -v wget > /dev/null 2>&1; then
    wget -O "$MAVEN_WRAPPER_JAR" "$WRAPPER_URL"
  else
    echo "Error: curl or wget is required to download the Maven Wrapper JAR." >&2
    exit 1
  fi
fi

exec "$JAVACMD" \
  $JAVA_OPTS \
  -classpath "$MAVEN_WRAPPER_JAR" \
  "-Dmaven.multiModuleProjectDirectory=$SCRIPT_DIR" \
  org.apache.maven.wrapper.MavenWrapperMain "$@"
