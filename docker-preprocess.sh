#!/bin/bash

set -e

# export environment variable
export JVM_JMX_EXPORTER_ENABLED=${JVM_JMX_EXPORTER_ENABLED:="true"}
export JVM_JMX_EXPORTER_PORT=${JVM_JMX_EXPORTER_PORT:="9404"}
export JVM_HEAP_DUMP_ENABLED=${JVM_HEAP_DUMP_ENABLED:="false"}
export JVM_PRINT_GC_ENABLED=${JVM_PRINT_GC_ENABLED:="true"}
export JVM_XMS=${JVM_XMS:="4096M"}
export JVM_XMX=${JVM_XMX:="4096M"}
export JVM_XSS=${JVM_XSS:="1M"}
export JVM_METASPACE_SIZE=${JVM_METASPACE_SIZE:="128M"}
export JVM_MAX_METASPACE_SIZE=${JVM_MAX_METASPACE_SIZE:="256M"}
export JVM_MAX_DIRECT_MEMORY_SIZE=${JVM_MAX_DIRECT_MEMORY_SIZE:="4096M"}
export JVM_REMOTE_DEBUG_ENABLED=${JVM_REMOTE_DEBUG_ENABLED:="false"}
export JVM_REMOTE_DEBUG_SUSPEND=${JVM_REMOTE_DEBUG_SUSPEND:="n"}
export JVM_REMOTE_DEBUG_PORT=${JVM_REMOTE_DEBUG_PORT:="10087"}
export JVM_JMX_REMOTE_ENABLED=${JVM_JMX_REMOTE_ENABLED:="false"}
export JVM_JMX_REMOTE_SSL=${JVM_JMX_REMOTE_SSL:="false"}
export JVM_JMX_REMOTE_AUTH=${JVM_JMX_REMOTE_AUTH:="true"}
export JVM_JMX_REMOTE_RMI_SERVER_HOSTNAME=${JVM_JMX_REMOTE_RMI_SERVER_HOSTNAME:="127.0.0.1"}
export JVM_JMX_REMOTE_RMI_REGISTRY_PORT=${JVM_JMX_REMOTE_RMI_REGISTRY_PORT:="10001"}
export JVM_JMX_REMOTE_RMI_SERVER_PORT=${JVM_JMX_REMOTE_RMI_SERVER_PORT:="10002"}
export JVM_HTTP_LISTEN_PORT=${JVM_HTTP_LISTEN_PORT:="8080"}
export JVM_SHUTDOWN_PORT=${JVM_SHUTDOWN_PORT:="-1"}
export JVM_OTHER_PARAMETERS=${JVM_OTHER_PARAMETERS:=""}

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
