#!/bin/bash

set -e

# export environment variable
fun_export_environment_variable() {
    echo "export environment variable :"

    # env format
    export ENV_FILE_FORMAT=${ENV_FILE_FORMAT:="yaml"}

    # prop
    export PROP_APP_NAME=${PROP_APP_NAME:="myapp"}
    export PROP_APP_LONG_NAME=${PROP_APP_LONG_NAME:="myapp"}
    export PROP_APP_DESC=${PROP_APP_DESC:="myapp"}
    export PROP_RUN_AS_USER=${PROP_RUN_AS_USER:=""}
    # jvm
    export JVM_JMX_EXPORTER_ENABLED=${JVM_JMX_EXPORTER_ENABLED:="false"}
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
    export TOMCAT_CORS_FILTER_ENABLED=${TOMCAT_CORS_FILTER_ENABLED:="true"}
    export TOMCAT_CORS_FILTER_ALLOWED_ORIGINS=${TOMCAT_CORS_FILTER_ALLOWED_ORIGINS:="*"}
    export TOMCAT_CORS_FILTER_ALLOWED_METHODS=${TOMCAT_CORS_FILTER_ALLOWED_METHODS:="GET,POST,HEAD,OPTIONS,PUT"}
    export TOMCAT_CORS_FILTER_ALLOWED_HEADERS=${TOMCAT_CORS_FILTER_ALLOWED_HEADERS:="Content-Type,X-Requested-With,Accept,Origin,Access-Control-Request-Method,Access-Control-Request-Headers"}
    export TOMCAT_CORS_FILTER_EXPOSED_HEADERS=${TOMCAT_CORS_FILTER_EXPOSED_HEADERS:="Access-Control-Allow-Origin,Access-Control-Allow-Credentials"}
    export TOMCAT_CORS_FILTER_SUPPORT_CREDENTIALS=${TOMCAT_CORS_FILTER_SUPPORT_CREDENTIALS:="false"}
    export TOMCAT_CORS_FILTER_PREFLIGHT_MAXAGE=${TOMCAT_CORS_FILTER_PREFLIGHT_MAXAGE:="10"}
    export TOMCAT_CORS_FILTER_ASYNC_SUPPORTED=${TOMCAT_CORS_FILTER_ASYNC_SUPPORTED:="true"}

    echo "successfully exported environment variable"

    return 0
}

# generate wrapper-environment file
fun_generate_wrapper_environment_file() {
    if [ "${ENV_FILE_FORMAT}" == "yaml" ]; then
        # generate wrapper-environment.yaml
        fun_generate_wrapper_environment_yaml
    elif [ "${ENV_FILE_FORMAT}" == "json" ];then
        # generate wrapper-environment.json
        fun_generate_wrapper_environment_json
    else
        echo "[ENV_FILE_FORMAT] only support yaml and json."
        exit 1
    fi
    return 0
}

# generate wrapper-environment.yaml
fun_generate_wrapper_environment_yaml() {
    echo "generate wrapper-environment.yaml :"

    set +e

    # generate wrapper-environment.yaml
    if [ ! -f "/data/app/conf/wrapper-environment.yaml" ]; then
        echo "file [/data/app/conf/wrapper-environment.yaml] does not exist, generate /data/app/conf/wrapper-environment.yaml."

        # environment file
        envfile_path=/data/app/conf/wrapper-environment.yaml
        touch ${envfile_path}
        echo "'Prop':"                                                                                >> ${envfile_path}
        echo "    'AppName': '${PROP_APP_NAME}'"                                                      >> ${envfile_path}
        echo "    'AppLongName': '${PROP_APP_LONG_NAME}'"                                             >> ${envfile_path}
        echo "    'AppDesc': '${PROP_APP_DESC}'"                                                      >> ${envfile_path}
        echo "    'RunAsUser': '${PROP_RUN_AS_USER}'"                                                 >> ${envfile_path}
        echo "'Jvm':"                                                                                 >> ${envfile_path}
        echo "    'JmxExporter':"                                                                     >> ${envfile_path}
        echo "        'Enabled': '${JVM_JMX_EXPORTER_ENABLED}'"                                       >> ${envfile_path}
        echo "        'Port': '${JVM_JMX_EXPORTER_PORT}'"                                             >> ${envfile_path}
        echo "    'HeapDumpEnabled': '${JVM_HEAP_DUMP_ENABLED}'"                                      >> ${envfile_path}
        echo "    'PrintGcEnabled': '${JVM_PRINT_GC_ENABLED}'"                                        >> ${envfile_path}
        echo "    'Xms': '${JVM_XMS}'"                                                                >> ${envfile_path}
        echo "    'Xmx': '${JVM_XMX}'"                                                                >> ${envfile_path}
        echo "    'Xss': '${JVM_XSS}'"                                                                >> ${envfile_path}
        echo "    'MetaspaceSize': '${JVM_METASPACE_SIZE}'"                                           >> ${envfile_path}
        echo "    'MaxMetaspaceSize': '${JVM_MAX_METASPACE_SIZE}'"                                    >> ${envfile_path}
        echo "    'MaxDirectMemorySize': '${JVM_MAX_DIRECT_MEMORY_SIZE}'"                             >> ${envfile_path}
        echo "    'RemoteDebug':"                                                                     >> ${envfile_path}
        echo "        'Enabled': '${JVM_REMOTE_DEBUG_ENABLED}'"                                       >> ${envfile_path}
        echo "        'Suspend': '${JVM_REMOTE_DEBUG_SUSPEND}'"                                       >> ${envfile_path}
        echo "        'Port': '${JVM_REMOTE_DEBUG_PORT}'"                                             >> ${envfile_path}
        echo "    'JmxRemote':"                                                                       >> ${envfile_path}
        echo "        'Enabled': '${JVM_JMX_REMOTE_ENABLED}'"                                         >> ${envfile_path}
        echo "        'Ssl': '${JVM_JMX_REMOTE_SSL}'"                                                 >> ${envfile_path}
        echo "        'Auth': '${JVM_JMX_REMOTE_AUTH}'"                                               >> ${envfile_path}
        echo "        'RmiServerHostname': '${JVM_JMX_REMOTE_RMI_SERVER_HOSTNAME}'"                   >> ${envfile_path}
        echo "        'RmiRegistryPort': '${JVM_JMX_REMOTE_RMI_REGISTRY_PORT}'"                       >> ${envfile_path}
        echo "        'RmiServerPort': '${JVM_JMX_REMOTE_RMI_SERVER_PORT}'"                           >> ${envfile_path}
        echo "    'HttpListenPort': '${JVM_HTTP_LISTEN_PORT}'"                                        >> ${envfile_path}
        echo "    'ShutdownPort': '${JVM_SHUTDOWN_PORT}'"                                             >> ${envfile_path}
        echo "    'OtherParameters':"                                                                 >> ${envfile_path}
        env | grep "JVM_OTHER_PARAMETERS_" | while read line
        do
        echo "        - '${line#*=}'"                                                                 >> ${envfile_path}
        done
        echo "        - ''"                                                                           >> ${envfile_path}
        echo "'Tomcat':"                                                                              >> ${envfile_path}
        echo "    'SetCharacterEncodingFilter':"                                                      >> ${envfile_path}
        echo "        'Enabled': '${TOMCAT_SET_CHARACTER_ENCODING_FILTER_ENABLED}'"                   >> ${envfile_path}
        echo "        'Encoding': '${TOMCAT_SET_CHARACTER_ENCODING_FILTER_ENCODING}'"                 >> ${envfile_path}
        echo "        'AsyncSupported': '${TOMCAT_SET_CHARACTER_ENCODING_FILTER_ASYNC_SUPPORTED}'"    >> ${envfile_path}
        echo "    'FailedRequestFilter':"                                                             >> ${envfile_path}
        echo "        'Enabled': '${TOMCAT_FAILED_REQUEST_FILTER_ENABLED}'"                           >> ${envfile_path}
        echo "        'AsyncSupported': '${TOMCAT_FAILED_REQUEST_FILTER_ASYNC_SUPPORTED}'"            >> ${envfile_path}
        echo "    'CorsFilter':"                                                                      >> ${envfile_path}
        echo "        'Enabled': '${TOMCAT_CORS_FILTER_ENABLED}'"                                     >> ${envfile_path}
        echo "        'AllowedOrigins': '${TOMCAT_CORS_FILTER_ALLOWED_ORIGINS}'"                      >> ${envfile_path}
        echo "        'AllowedMethods': '${TOMCAT_CORS_FILTER_ALLOWED_METHODS}'"                      >> ${envfile_path}
        echo "        'AllowedHeaders': '${TOMCAT_CORS_FILTER_ALLOWED_HEADERS}'"                      >> ${envfile_path}
        echo "        'ExposedHeaders': '${TOMCAT_CORS_FILTER_EXPOSED_HEADERS}'"                      >> ${envfile_path}
        echo "        'SupportCredentials': '${TOMCAT_CORS_FILTER_SUPPORT_CREDENTIALS}'"              >> ${envfile_path}
        echo "        'PreflightMaxage': '${TOMCAT_CORS_FILTER_PREFLIGHT_MAXAGE}'"                    >> ${envfile_path}
        echo "        'AsyncSupported': '${TOMCAT_CORS_FILTER_ASYNC_SUPPORTED}'"                      >> ${envfile_path}

        chown app:app /data/app/conf/wrapper-environment.yaml
        chmod 644 /data/app/conf/wrapper-environment.yaml
    else
        if [ ! -r "/data/app/conf/wrapper-environment.yaml" ]; then
            echo "file [/data/app/conf/wrapper-environment.yaml] already exists, but it is not readable."
            exit 1
        else
            echo "file [/data/app/conf/wrapper-environment.yaml] already exists and is readable."
        fi
    fi

    echo "show [/data/app/conf/wrapper-environment.yaml]"
    cat /data/app/conf/wrapper-environment.yaml

    set -e

    echo "successfully generated wrapper-environment.yaml"

    return 0
}

# generate wrapper-environment.json
fun_generate_wrapper_environment_json() {
    echo "generate wrapper-environment.json :"

    set +e

    # generate wrapper-environment.json
    if [ ! -f "/data/app/conf/wrapper-environment.json" ]; then
        echo "file [/data/app/conf/wrapper-environment.json] does not exist, generate /data/app/conf/wrapper-environment.json."

        # environment file
        envfile_path=/data/app/conf/wrapper-environment.json
        touch ${envfile_path}
        echo "{"                                                                                      >> ${envfile_path}
        echo "    \"Prop\": {"                                                                        >> ${envfile_path}
        echo "        \"AppName\": \"${PROP_APP_NAME}\","                                             >> ${envfile_path}
        echo "        \"AppLongName\": \"${PROP_APP_LONG_NAME}\","                                    >> ${envfile_path}
        echo "        \"AppDesc\": \"${PROP_APP_DESC}\","                                             >> ${envfile_path}
        echo "        \"RunAsUser\": \"${PROP_RUN_AS_USER}\""                                         >> ${envfile_path}
        echo "    },"                                                                                 >> ${envfile_path}
        echo "    \"Jvm\": {"                                                                         >> ${envfile_path}
        echo "        \"JmxExporter\": {"                                                             >> ${envfile_path}
        echo "            \"Enabled\": \"${JVM_JMX_EXPORTER_ENABLED}\","                              >> ${envfile_path}
        echo "            \"Port\": \"${JVM_JMX_EXPORTER_PORT}\""                                     >> ${envfile_path}
        echo "        },"                                                                             >> ${envfile_path}
        echo "        \"HeapDumpEnabled\": \"${JVM_HEAP_DUMP_ENABLED}\","                             >> ${envfile_path}
        echo "        \"PrintGcEnabled\": \"${JVM_PRINT_GC_ENABLED}\","                               >> ${envfile_path}
        echo "        \"Xms\": \"${JVM_XMS}\","                                                       >> ${envfile_path}
        echo "        \"Xmx\": \"${JVM_XMX}\","                                                       >> ${envfile_path}
        echo "        \"Xss\": \"${JVM_XSS}\","                                                       >> ${envfile_path}
        echo "        \"MetaspaceSize\": \"${JVM_METASPACE_SIZE}\","                                  >> ${envfile_path}
        echo "        \"MaxMetaspaceSize\": \"${JVM_MAX_METASPACE_SIZE}\","                           >> ${envfile_path}
        echo "        \"MaxDirectMemorySize\": \"${JVM_MAX_DIRECT_MEMORY_SIZE}\","                    >> ${envfile_path}
        echo "        \"RemoteDebug\": {"                                                             >> ${envfile_path}
        echo "            \"Enabled\": \"${JVM_REMOTE_DEBUG_ENABLED}\","                              >> ${envfile_path}
        echo "            \"Suspend\": \"${JVM_REMOTE_DEBUG_SUSPEND}\","                              >> ${envfile_path}
        echo "            \"Port\": \"${JVM_REMOTE_DEBUG_PORT}\""                                     >> ${envfile_path}
        echo "        },"                                                                             >> ${envfile_path}
        echo "        \"JmxRemote\": {"                                                               >> ${envfile_path}
        echo "            \"Enabled\": \"${JVM_JMX_REMOTE_ENABLED}\","                                >> ${envfile_path}
        echo "            \"Ssl\": \"${JVM_JMX_REMOTE_SSL}\","                                        >> ${envfile_path}
        echo "            \"Auth\": \"${JVM_JMX_REMOTE_AUTH}\","                                      >> ${envfile_path}
        echo "            \"RmiServerHostname\": \"${JVM_JMX_REMOTE_RMI_SERVER_HOSTNAME}\","          >> ${envfile_path}
        echo "            \"RmiRegistryPort\": \"${JVM_JMX_REMOTE_RMI_REGISTRY_PORT}\","              >> ${envfile_path}
        echo "            \"RmiServerPort\": \"${JVM_JMX_REMOTE_RMI_SERVER_PORT}\""                   >> ${envfile_path}
        echo "        },"                                                                             >> ${envfile_path}
        echo "        \"HttpListenPort\": \"${JVM_HTTP_LISTEN_PORT}\","                               >> ${envfile_path}
        echo "        \"ShutdownPort\": \"${JVM_SHUTDOWN_PORT}\","                                    >> ${envfile_path}
        echo "        \"OtherParameters\": ["                                                         >> ${envfile_path}
        env | grep "JVM_OTHER_PARAMETERS_" | while read line
        do
        echo "            \"${line#*=}\","                                                            >> ${envfile_path}
        done
        echo "            \"\""                                                                       >> ${envfile_path}
        echo "        ]"                                                                              >> ${envfile_path}
        echo "    },"                                                                                 >> ${envfile_path}
        echo "    \"Tomcat\": {"                                                                      >> ${envfile_path}
        echo "        \"SetCharacterEncodingFilter\": {"                                              >> ${envfile_path}
        echo "            \"Enabled\": \"${TOMCAT_SET_CHARACTER_ENCODING_FILTER_ENABLED}\","          >> ${envfile_path}
        echo "            \"Encoding\": \"${TOMCAT_SET_CHARACTER_ENCODING_FILTER_ENCODING}\","        >> ${envfile_path}
        echo "            \"AsyncSupported\": \"${TOMCAT_SET_CHARACTER_ENCODING_FILTER_ASYNC_SUPPORTED}\"" >> ${envfile_path}
        echo "        },"                                                                             >> ${envfile_path}
        echo "        \"FailedRequestFilter\": {"                                                     >> ${envfile_path}
        echo "            \"Enabled\": \"${TOMCAT_FAILED_REQUEST_FILTER_ENABLED}\","                  >> ${envfile_path}
        echo "            \"AsyncSupported\": \"${TOMCAT_FAILED_REQUEST_FILTER_ASYNC_SUPPORTED}\""    >> ${envfile_path}
        echo "        },"                                                                             >> ${envfile_path}
        echo "        \"CorsFilter\": {"                                                              >> ${envfile_path}
        echo "            \"Enabled\": \"${TOMCAT_CORS_FILTER_ENABLED}\","                            >> ${envfile_path}
        echo "            \"AllowedOrigins\": \"${TOMCAT_CORS_FILTER_ALLOWED_ORIGINS}\","             >> ${envfile_path}
        echo "            \"AllowedMethods\": \"${TOMCAT_CORS_FILTER_ALLOWED_METHODS}\","             >> ${envfile_path}
        echo "            \"AllowedHeaders\": \"${TOMCAT_CORS_FILTER_ALLOWED_HEADERS}\","             >> ${envfile_path}
        echo "            \"ExposedHeaders\": \"${TOMCAT_CORS_FILTER_EXPOSED_HEADERS}\","             >> ${envfile_path}
        echo "            \"SupportCredentials\": \"${TOMCAT_CORS_FILTER_SUPPORT_CREDENTIALS}\","     >> ${envfile_path}
        echo "            \"PreflightMaxage\": \"${TOMCAT_CORS_FILTER_PREFLIGHT_MAXAGE}\","           >> ${envfile_path}
        echo "            \"AsyncSupported\": \"${TOMCAT_CORS_FILTER_ASYNC_SUPPORTED}\""              >> ${envfile_path}
        echo "        }"                                                                              >> ${envfile_path}
        echo "    }"                                                                                  >> ${envfile_path}
        echo "}"                                                                                      >> ${envfile_path}

        chown app:app /data/app/conf/wrapper-environment.json
        chmod 644 /data/app/conf/wrapper-environment.json
    else
        if [ ! -r "/data/app/conf/wrapper-environment.json" ]; then
            echo "file [/data/app/conf/wrapper-environment.json] already exists, but it is not readable."
            exit 1
        else
            echo "file [/data/app/conf/wrapper-environment.json] already exists and is readable."
        fi
    fi

    echo "show [/data/app/conf/wrapper-environment.json]"
    cat /data/app/conf/wrapper-environment.json

    set -e

    echo "successfully generated wrapper-environment.json"

    return 0
}

# generate wrapper-property.conf
fun_generate_wrapper_property_file() {
    echo "generate wrapper-property.conf :"

    # generate wrapper-property.conf
    if [ ! -f "/data/app/conf/wrapper-property.conf" ]; then
        echo "file [/data/app/conf/wrapper-property.conf] does not exist, generate /data/app/conf/wrapper-property.conf."
        if [ "${ENV_FILE_FORMAT}" == "yaml" ]; then
            /data/app/bin/gotmpl-linux-x86-64 --template=f:/data/app/conf/wrapper-property.tmpl \
                                              --yamldata=f:/data/app/conf/wrapper-environment.yaml \
                                              --outfile=/data/app/conf/wrapper-property.conf
        elif [ "${ENV_FILE_FORMAT}" == "json" ];then
            /data/app/bin/gotmpl-linux-x86-64 --template=f:/data/app/conf/wrapper-property.tmpl \
                                              --jsondata=f:/data/app/conf/wrapper-environment.json \
                                              --outfile=/data/app/conf/wrapper-property.conf
        else
            echo "[ENV_FILE_FORMAT] only support yaml and json."
            exit 1
        fi
        chown app:app /data/app/conf/wrapper-property.conf
        chmod 644 /data/app/conf/wrapper-property.conf
    else
        if [ ! -r "/data/app/conf/wrapper-property.conf" ]; then
            echo "file [/data/app/conf/wrapper-property.conf] already exists, but it is not readable."
            exit 1
        else
            echo "file [/data/app/conf/wrapper-property.conf] already exists and is readable."
        fi
    fi

    echo "show [/data/app/conf/wrapper-property.conf]"
    cat /data/app/conf/wrapper-property.conf

    echo "successfully generated wrapper-property.conf"

    return 0
}

# generate wrapper-additional.conf
fun_generate_wrapper_additional_file() {
    echo "generate wrapper-additional.conf :"

    # generate wrapper-additional.conf
    if [ ! -f "/data/app/conf/wrapper-additional.conf" ]; then
        echo "file [/data/app/conf/wrapper-additional.conf] does not exist, generate /data/app/conf/wrapper-additional.conf."
        if [ "${ENV_FILE_FORMAT}" == "yaml" ]; then
            /data/app/bin/gotmpl-linux-x86-64 --template=f:/data/app/conf/wrapper-additional.tmpl \
                                              --yamldata=f:/data/app/conf/wrapper-environment.yaml \
                                              --outfile=/data/app/conf/wrapper-additional.conf
        elif [ "${ENV_FILE_FORMAT}" == "json" ];then
            /data/app/bin/gotmpl-linux-x86-64 --template=f:/data/app/conf/wrapper-additional.tmpl \
                                              --jsondata=f:/data/app/conf/wrapper-environment.json \
                                              --outfile=/data/app/conf/wrapper-additional.conf
        else
            echo "[ENV_FILE_FORMAT] only support yaml and json."
            exit 1
        fi
        chown app:app /data/app/conf/wrapper-additional.conf
        chmod 644 /data/app/conf/wrapper-additional.conf
    else
        if [ ! -r "/data/app/conf/wrapper-additional.conf" ]; then
            echo "file [/data/app/conf/wrapper-additional.conf] already exists, but it is not readable."
            exit 1
        else
            echo "file [/data/app/conf/wrapper-additional.conf] already exists and is readable."
        fi
    fi

    echo "show [/data/app/conf/wrapper-additional.conf]"
    cat /data/app/conf/wrapper-additional.conf

    echo "successfully generated wrapper-additional.conf"

    return 0
}

# generate tomcat server.xml
fun_generate_tomcat_server_file() {
    echo "generate tomcat server.xml :"

    # generate server.xml
    if [ ! -f "/data/app/conf/server.xml" ]; then
        echo "file [/data/app/conf/server.xml] does not exist, generate /data/app/conf/server.xml."
        if [ "${ENV_FILE_FORMAT}" == "yaml" ]; then
            /data/app/bin/gotmpl-linux-x86-64 --template=f:/data/app/conf/server.tmpl \
                                              --yamldata=f:/data/app/conf/wrapper-environment.yaml \
                                              --outfile=/data/app/conf/server.xml
        elif [ "${ENV_FILE_FORMAT}" == "json" ];then
            /data/app/bin/gotmpl-linux-x86-64 --template=f:/data/app/conf/server.tmpl \
                                              --jsondata=f:/data/app/conf/wrapper-environment.json \
                                              --outfile=/data/app/conf/server.xml
        else
            echo "[ENV_FILE_FORMAT] only support yaml and json."
            exit 1
        fi
        chown app:app /data/app/conf/server.xml
        chmod 644 /data/app/conf/server.xml
    else
        if [ ! -r "/data/app/conf/server.xml" ]; then
            echo "file [/data/app/conf/server.xml] already exists, but it is not readable."
            exit 1
        else
            echo "file [/data/app/conf/server.xml] already exists and is readable."
        fi
    fi

    echo "show [/data/app/conf/server.xml]"
    cat /data/app/conf/server.xml

    echo "successfully generated tomcat server.xml"

    return 0
}

# generate tomcat web.xml
fun_generate_tomcat_web_file() {
    echo "generate tomcat web.xml :"

    # generate web.xml
    if [ ! -f "/data/app/conf/web.xml" ]; then
        echo "file [/data/app/conf/web.xml] does not exist, generate /data/app/conf/web.xml."
        if [ "${ENV_FILE_FORMAT}" == "yaml" ]; then
            /data/app/bin/gotmpl-linux-x86-64 --template=f:/data/app/conf/web.tmpl \
                                              --yamldata=f:/data/app/conf/wrapper-environment.yaml \
                                              --outfile=/data/app/conf/web.xml
        elif [ "${ENV_FILE_FORMAT}" == "json" ];then
            /data/app/bin/gotmpl-linux-x86-64 --template=f:/data/app/conf/web.tmpl \
                                              --jsondata=f:/data/app/conf/wrapper-environment.json \
                                              --outfile=/data/app/conf/web.xml
        else
            echo "[ENV_FILE_FORMAT] only support yaml and json."
            exit 1
        fi
        chown app:app /data/app/conf/web.xml
        chmod 644 /data/app/conf/web.xml
    else
        if [ ! -r "/data/app/conf/web.xml" ]; then
            echo "file [/data/app/conf/web.xml] already exists, but it is not readable."
            exit 1
        else
            echo "file [/data/app/conf/web.xml] already exists and is readable."
        fi
    fi

    echo "show [/data/app/conf/web.xml]"
    cat /data/app/conf/web.xml

    echo "successfully generated tomcat web.xml"

    return 0
}

echo "preprocess start."
# export environment variable
fun_export_environment_variable
# generate wrapper-environment file
fun_generate_wrapper_environment_file
# generate wrapper-property.conf
fun_generate_wrapper_property_file
# generate wrapper-additional.conf
fun_generate_wrapper_additional_file
# generate tomcat server.xml
fun_generate_tomcat_server_file
# generate tomcat web.xml
fun_generate_tomcat_web_file
echo "preprocess end."

echo ""
