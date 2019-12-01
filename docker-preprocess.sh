#!/bin/bash

set -e

# export environment variable
echo export environment variable
export WRAPPERT_JMX_EXPORTER_ENABLED=${WRAPPERT_JMX_EXPORTER_ENABLED:="true"}
export WRAPPERT_JMX_EXPORTER_PORT=${WRAPPERT_JMX_EXPORTER_PORT:="9404"}
export WRAPPERT_HEAP_DUMP_ENABLED=${WRAPPERT_HEAP_DUMP_ENABLED:="false"}
export WRAPPERT_PRINT_GC_ENABLED=${WRAPPERT_PRINT_GC_ENABLED:="true"}
export WRAPPERT_XMS=${WRAPPERT_XMS:="4096M"}
export WRAPPERT_XMX=${WRAPPERT_XMX:="4096M"}
export WRAPPERT_XSS=${WRAPPERT_XSS:="1M"}
export WRAPPERT_METASPACE_SIZE=${WRAPPERT_METASPACE_SIZE:="128M"}
export WRAPPERT_MAX_METASPACE_SIZE=${WRAPPERT_MAX_METASPACE_SIZE:="1024M"}
export WRAPPERT_REMOTE_DEBUG_ENABLED=${WRAPPERT_REMOTE_DEBUG_ENABLED:="false"}
export WRAPPERT_REMOTE_DEBUG_SUSPEND=${WRAPPERT_REMOTE_DEBUG_SUSPEND:="n"}
export WRAPPERT_REMOTE_DEBUG_PORT=${WRAPPERT_REMOTE_DEBUG_PORT:="10087"}
export WRAPPERT_JMX_REMOTE_ENABLED=${WRAPPERT_JMX_REMOTE_ENABLED:="false"}
export WRAPPERT_JMX_REMOTE_SSL=${WRAPPERT_JMX_REMOTE_SSL:="false"}
export WRAPPERT_JMX_REMOTE_AUTH=${WRAPPERT_JMX_REMOTE_AUTH:="true"}
export WRAPPERT_JMX_REMOTE_RMI_SERVER_HOSTNAME=${WRAPPERT_JMX_REMOTE_RMI_SERVER_HOSTNAME:="127.0.0.1"}
export WRAPPERT_JMX_REMOTE_RMI_REGISTRY_PORT=${WRAPPERT_JMX_REMOTE_RMI_REGISTRY_PORT:="10001"}
export WRAPPERT_JMX_REMOTE_RMI_SERVER_PORT=${WRAPPERT_JMX_REMOTE_RMI_SERVER_PORT:="10002"}
export WRAPPERT_HTTP_LISTEN_PORT=${WRAPPERT_HTTP_LISTEN_PORT:="8080"}
export WRAPPERT_SHUTDOWN_PORT=${WRAPPERT_SHUTDOWN_PORT:="-1"}
export WRAPPERT_OTHER_PARAMETERS=${WRAPPERT_OTHER_PARAMETERS:=""}

# generate wrapper-environment.json by wrapper-environment.tmpl
echo generate wrapper-environment.json
envsubst < /data/app/conf/wrapper-environment.tmpl > /data/app/conf/wrapper-environment.json

# generate wrapper-additional.conf by wrapper-additional.tmpl
echo generate wrapper-additional.conf
/data/app/bin/gotmpl-linux-x86-64 --template=f:/data/app/conf/wrapper-additional.tmpl \
                     --jsondata=f:/data/app/conf/wrapper-environment.json \
                     --outfile=/data/app/conf/wrapper-additional.conf

echo done.
