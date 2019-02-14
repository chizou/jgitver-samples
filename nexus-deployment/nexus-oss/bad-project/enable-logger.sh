#!/bin/bash
mv /usr/share/maven/conf/logging/simplelogger.properties /usr/share/maven/conf/logging/simplelogger.properties.bak
ln -s /opt/projects/bad-project/simplelogger.properties /usr/share/maven/conf/logging/simplelogger.properties
