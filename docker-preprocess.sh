#!/bin/bash

set -e

echo "preprocess start."

# export environment variable
# prop
export PROP_APP_NAME=${PROP_APP_NAME:="myapp"}
export PROP_APP_LONG_NAME=${PROP_APP_LONG_NAME:="myapp"}
export PROP_APP_DESC=${PROP_APP_DESC:="myapp"}
export PROP_RUN_AS_USER=${PROP_RUN_AS_USER:=""}
# jvm
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
# tomcat
export TOMCAT_SET_CHARACTER_ENCODING_FILTER_ENABLED=${TOMCAT_SET_CHARACTER_ENCODING_FILTER_ENABLED:="true"}
export TOMCAT_SET_CHARACTER_ENCODING_FILTER_ENCODING=${TOMCAT_SET_CHARACTER_ENCODING_FILTER_ENCODING:="UTF-8"}
export TOMCAT_SET_CHARACTER_ENCODING_FILTER_ASYNC_SUPPORTED=${TOMCAT_SET_CHARACTER_ENCODING_FILTER_ASYNC_SUPPORTED:="true"}
export TOMCAT_FAILED_REQUEST_FILTER_ENABLED=${TOMCAT_FAILED_REQUEST_FILTER_ENABLED:="true"}
export TOMCAT_FAILED_REQUEST_FILTER_ASYNC_SUPPORTED=${TOMCAT_FAILED_REQUEST_FILTER_ASYNC_SUPPORTED:="true"}
export TOMCAT_CORS_FILTER_ENABLED=${TOMCAT_CORS_FILTER_ENABLED:="false"}
export TOMCAT_CORS_FILTER_ALLOWED_ORIGINS=${TOMCAT_CORS_FILTER_ALLOWED_ORIGINS:="*"}
export TOMCAT_CORS_FILTER_ALLOWED_METHODS=${TOMCAT_CORS_FILTER_ALLOWED_METHODS:="GET,POST,HEAD,OPTIONS,PUT"}
export TOMCAT_CORS_FILTER_ALLOWED_HEADERS=${TOMCAT_CORS_FILTER_ALLOWED_HEADERS:="Content-Type,X-Requested-With,accept,Origin,Access-Control-Request-Method,Access-Control-Request-Headers"}
export TOMCAT_CORS_FILTER_EXPOSED_HEADERS=${TOMCAT_CORS_FILTER_EXPOSED_HEADERS:="Access-Control-Allow-Origin,Access-Control-Allow-Credentials"}
export TOMCAT_CORS_FILTER_SUPPORT_CREDENTIALS=${TOMCAT_CORS_FILTER_SUPPORT_CREDENTIALS:="false"}
export TOMCAT_CORS_FILTER_PREFLIGHT_MAXAGE=${TOMCAT_CORS_FILTER_PREFLIGHT_MAXAGE:="10"}
export TOMCAT_CORS_FILTER_ASYNC_SUPPORTED=${TOMCAT_CORS_FILTER_ASYNC_SUPPORTED:="true"}

# generate wrapper-environment.json
if [ ! -f "/data/app/conf/wrapper-environment.json" ]; then
    echo "file [/data/app/conf/wrapper-environment.json] does not exist, generate /data/app/conf/wrapper-environment.json."
    gosu app bash -c 'envsubst < /data/app/conf/wrapper-environment.tmpl > /data/app/conf/wrapper-environment.json'
else
    if [ ! -r "/data/app/conf/wrapper-environment.json" ]; then
        echo "file [/data/app/conf/wrapper-environment.json] already exists, but it is not readable."
        exit 1
    else
        echo "file [/data/app/conf/wrapper-environment.json] already exists and is readable."
    fi
fi

# generate wrapper-property.conf
if [ ! -f "/data/app/conf/wrapper-property.conf" ]; then
    echo "file [/data/app/conf/wrapper-property.conf] does not exist, generate /data/app/conf/wrapper-property.conf."
    gosu app bash -c '/data/app/bin/gotmpl-linux-x86-64 --template=f:/data/app/conf/wrapper-property.tmpl \
                                                        --jsondata=f:/data/app/conf/wrapper-environment.json \
                                                        --outfile=/data/app/conf/wrapper-property.conf'
else
    if [ ! -r "/data/app/conf/wrapper-property.conf" ]; then
        echo "file [/data/app/conf/wrapper-property.conf] already exists, but it is not readable."
        exit 1
    else
        echo "file [/data/app/conf/wrapper-property.conf] already exists and is readable."
    fi
fi

# generate wrapper-additional.conf
if [ ! -f "/data/app/conf/wrapper-additional.conf" ]; then
    echo "file [/data/app/conf/wrapper-additional.conf] does not exist, generate /data/app/conf/wrapper-additional.conf."
    gosu app bash -c '/data/app/bin/gotmpl-linux-x86-64 --template=f:/data/app/conf/wrapper-additional.tmpl \
                                                        --jsondata=f:/data/app/conf/wrapper-environment.json \
                                                        --outfile=/data/app/conf/wrapper-additional.conf'
else
    if [ ! -r "/data/app/conf/wrapper-additional.conf" ]; then
        echo "file [/data/app/conf/wrapper-additional.conf] already exists, but it is not readable."
        exit 1
    else
        echo "file [/data/app/conf/wrapper-additional.conf] already exists and is readable."
    fi
fi

# generate server.xml
if [ ! -f "/data/app/conf/server.xml" ]; then
    echo "file [/data/app/conf/server.xml] does not exist, generate /data/app/conf/server.xml."
    gosu app bash -c '/data/app/bin/gotmpl-linux-x86-64 --template=f:/data/app/conf/server.tmpl \
                                                        --jsondata=f:/data/app/conf/wrapper-environment.json \
                                                        --outfile=/data/app/conf/server.xml'
else
    if [ ! -r "/data/app/conf/server.xml" ]; then
        echo "file [/data/app/conf/server.xml] already exists, but it is not readable."
        exit 1
    else
        echo "file [/data/app/conf/server.xml] already exists and is readable."
    fi
fi

# generate web.xml
if [ ! -f "/data/app/conf/web.xml" ]; then
    echo "file [/data/app/conf/web.xml] does not exist, generate /data/app/conf/web.xml."
    gosu app bash -c '/data/app/bin/gotmpl-linux-x86-64 --template=f:/data/app/conf/web.tmpl \
                                                        --jsondata=f:/data/app/conf/wrapper-environment.json \
                                                        --outfile=/data/app/conf/web.xml'
else
    if [ ! -r "/data/app/conf/web.xml" ]; then
        echo "file [/data/app/conf/web.xml] already exists, but it is not readable."
        exit 1
    else
        echo "file [/data/app/conf/web.xml] already exists and is readable."
    fi
fi

echo "preprocess end."
