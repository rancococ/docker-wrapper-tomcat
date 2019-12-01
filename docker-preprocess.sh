#!/bin/bash

set -e

# export environment variable
export TOMCAT_JMX_EXPORTER_ENABLED=${TOMCAT_JMX_EXPORTER_ENABLED:="true"}
export TOMCAT_JMX_EXPORTER_PORT=${TOMCAT_JMX_EXPORTER_PORT:="9404"}
export TOMCAT_HEAP_DUMP_ENABLED=${TOMCAT_HEAP_DUMP_ENABLED:="false"}
export TOMCAT_PRINT_GC_ENABLED=${TOMCAT_PRINT_GC_ENABLED:="true"}
export TOMCAT_XMS=${TOMCAT_XMS:="4096M"}
export TOMCAT_XMX=${TOMCAT_XMX:="4096M"}
export TOMCAT_XSS=${TOMCAT_XSS:="1M"}
export TOMCAT_METASPACE_SIZE=${TOMCAT_METASPACE_SIZE:="128M"}
export TOMCAT_MAX_METASPACE_SIZE=${TOMCAT_MAX_METASPACE_SIZE:="1024M"}
export TOMCAT_REMOTE_DEBUG_ENABLED=${TOMCAT_REMOTE_DEBUG_ENABLED:="false"}
export TOMCAT_REMOTE_DEBUG_SUSPEND=${TOMCAT_REMOTE_DEBUG_SUSPEND:="n"}
export TOMCAT_REMOTE_DEBUG_PORT=${TOMCAT_REMOTE_DEBUG_PORT:="10087"}
export TOMCAT_JMX_REMOTE_ENABLED=${TOMCAT_JMX_REMOTE_ENABLED:="false"}
export TOMCAT_JMX_REMOTE_SSL=${TOMCAT_JMX_REMOTE_SSL:="false"}
export TOMCAT_JMX_REMOTE_AUTH=${TOMCAT_JMX_REMOTE_AUTH:="true"}
export TOMCAT_JMX_REMOTE_RMI_SERVER_HOSTNAME=${TOMCAT_JMX_REMOTE_RMI_SERVER_HOSTNAME:="127.0.0.1"}
export TOMCAT_JMX_REMOTE_RMI_REGISTRY_PORT=${TOMCAT_JMX_REMOTE_RMI_REGISTRY_PORT:="10001"}
export TOMCAT_JMX_REMOTE_RMI_SERVER_PORT=${TOMCAT_JMX_REMOTE_RMI_SERVER_PORT:="10002"}
export TOMCAT_HTTP_LISTEN_PORT=${TOMCAT_HTTP_LISTEN_PORT:="8080"}
export TOMCAT_SHUTDOWN_PORT=${TOMCAT_SHUTDOWN_PORT:="-1"}
export TOMCAT_OTHER_PARAMETERS=${TOMCAT_OTHER_PARAMETERS:=""}

# generate wrapper-environment.json
envsubst < /data/app/conf/wrapper-environment.tmpl > /data/app/conf/wrapper-environment.json

# generate wrapper-additional.conf
/data/app/bin/gotmpl-linux-x86-64 --template=f:/data/app/conf/wrapper-additional.tmpl \
                                  --jsondata=f:/data/app/conf/wrapper-environment.json \
                                  --outfile=/data/app/conf/wrapper-additional.conf

# generate server.xml
/data/app/bin/gotmpl-linux-x86-64 --template=f:/data/app/conf/server.tmpl \
                                  --jsondata=f:/data/app/conf/wrapper-environment.json \
                                  --outfile=/data/app/conf/server.xml
