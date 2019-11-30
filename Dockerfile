# from registry.cn-hangzhou.aliyuncs.com/rancococ/oraclejre:1.8.0_192.5-alpine
FROM registry.cn-hangzhou.aliyuncs.com/rancococ/oraclejre:1.8.0_192.5-alpine

# maintainer
MAINTAINER "rancococ" <rancococ@qq.com>

# set arg info
ARG WRAPPER_URL=https://github.com/rancococ/wrapper/archive/v3.5.41.1.tar.gz
ARG TOMCAT_URL=https://mirrors.huaweicloud.com/apache/tomcat/tomcat-8/v8.5.40/bin/apache-tomcat-8.5.40.tar.gz
ARG TOMCAT_JULI_URL=https://mirrors.huaweicloud.com/apache/tomcat/tomcat-8/v8.0.53/bin/extras/tomcat-juli.jar
ARG TOMCAT_JULI_ADAPTERS_URL=https://mirrors.huaweicloud.com/apache/tomcat/tomcat-8/v8.0.53/bin/extras/tomcat-juli-adapters.jar
ARG CATALINA_JMX_REMOTE_URL=https://mirrors.huaweicloud.com/apache/tomcat/tomcat-8/v8.5.40/bin/extras/catalina-jmx-remote.jar
ARG CATALINA_WS_URL=https://mirrors.huaweicloud.com/apache/tomcat/tomcat-8/v8.5.40/bin/extras/catalina-ws.jar
ARG TOMCAT_EXTEND_URL=https://github.com/rancococ/tomcat-ext/releases/download/v1.0.0/tomcat-extend-1.0.0-SNAPSHOT.jar
ARG LOG4J2_URL=https://mirrors.huaweicloud.com/apache/logging/log4j/2.11.1/apache-log4j-2.11.1-bin.tar.gz
ARG JMX_EXPORTER_VERSION=0.12.0
ARG JMX_EXPORTER_URL=https://mirrors.huaweicloud.com/repository/maven/io/prometheus/jmx/jmx_prometheus_javaagent/${JMX_EXPORTER_VERSION}/jmx_prometheus_javaagent-${JMX_EXPORTER_VERSION}.jar

# copy script
COPY ./assets/. /tmp/assets/

# install wrapper, tomcat, log4j2
RUN mkdir -p /data/app && \
    mkdir -p /data/app/exporter && \
    mkdir -p /data/app/webapps && \
    mkdir -p /data/app/webapps/ROOT && \
    tempuuid=$(cat /proc/sys/kernel/random/uuid) && mkdir -p /tmp/${tempuuid} && \
    wget -c -O /tmp/${tempuuid}/wrapper.tar.gz --no-check-certificate ${WRAPPER_URL} && \
    tar -zxf /tmp/${tempuuid}/wrapper.tar.gz -C /tmp/${tempuuid} && \
    wrappername=$(tar -tf /tmp/${tempuuid}/wrapper.tar.gz | awk -F "/" '{print $1}' | sed -n '1p') && \
    \cp -rf /tmp/${tempuuid}/${wrappername}/. /data/app && \
    \cp -rf /data/app/conf/wrapper.tomcat.temp /data/app/conf/wrapper.conf && \
    \cp -rf /data/app/conf/wrapper-property.tomcat.temp /data/app/conf/wrapper-property.conf && \
    \cp -rf /data/app/conf/wrapper-additional.tomcat.temp /data/app/conf/wrapper-additional.conf && \
    sed -i 's/^set.JAVA_HOME/#&/g' "/data/app/conf/wrapper.conf" && \
    \rm -rf /data/app/conf/*.temp && \
    wget -c -O /data/app/exporter/jmx_prometheus_javaagent-${JMX_EXPORTER_VERSION}.jar --no-check-certificate ${JMX_EXPORTER_URL} && \
    \cp -rf /tmp/assets/jmx_exporter.yml /data/app/exporter/ && \
    sed -i "/^-server$/i\-javaagent:%WRAPPER_BASE_DIR%/exporter/jmx_prometheus_javaagent-${JMX_EXPORTER_VERSION}.jar=9404:%WRAPPER_BASE_DIR%/exporter/jmx_exporter.yml" "/data/app/conf/wrapper-additional.conf" && \
    wget -c -O /tmp/${tempuuid}/tomcat.tar.gz --no-check-certificate ${TOMCAT_URL} && \
    tar -zxf /tmp/${tempuuid}/tomcat.tar.gz -C /tmp/${tempuuid} && \
    tomcatname=$(tar -tf /tmp/${tempuuid}/tomcat.tar.gz | awk -F "/" '{print $1}' | sed -n '1p') && \
    \rm -rf /tmp/${tempuuid}/${tomcatname}/conf/catalina.properties && \
    \rm -rf /tmp/${tempuuid}/${tomcatname}/conf/logging.properties && \
    \rm -rf /tmp/${tempuuid}/${tomcatname}/conf/server.xml && \
    \cp -rf /tmp/${tempuuid}/${tomcatname}/bin/bootstrap.jar /data/app/bin/ && \
    \cp -rf /tmp/${tempuuid}/${tomcatname}/conf/. /data/app/conf/ && \
    \cp -rf /tmp/${tempuuid}/${tomcatname}/lib/. /data/app/lib/ && \
    \cp -rf /tmp/assets/catalina.properties /data/app/conf/ && \
    \cp -rf /tmp/assets/web.xml /data/app/conf/ && \
    \cp -rf /tmp/assets/server.xml /data/app/conf/ && \
    \cp -rf /tmp/assets/log4j2.xml /data/app/lib/ && \
    \rm -rf /tmp/assets && \
    wget -c -O /data/app/bin/tomcat-juli.jar --no-check-certificate ${TOMCAT_JULI_URL} && \
    wget -c -O /data/app/lib/tomcat-juli-adapters.jar --no-check-certificate ${TOMCAT_JULI_ADAPTERS_URL} && \
    wget -c -O /data/app/lib/catalina-jmx-remote.jar --no-check-certificate ${CATALINA_JMX_REMOTE_URL} && \
    wget -c -O /data/app/lib/catalina-ws.jar --no-check-certificate ${CATALINA_WS_URL} && \
    wget -c -O /data/app/lib/tomcat-extend.jar --no-check-certificate ${TOMCAT_EXTEND_URL} && \
    wget -c -O /tmp/${tempuuid}/log4j2.tar.gz --no-check-certificate ${LOG4J2_URL} && \
    tar -zxf /tmp/${tempuuid}/log4j2.tar.gz -C /tmp/${tempuuid} && \
    log4j2name=$(tar -tf /tmp/${tempuuid}/log4j2.tar.gz | awk -F "/" '{print $1}' | sed -n '1p') && \
    \rm -rf /tmp/${tempuuid}/${log4j2name}/*-javadoc.jar && \
    \rm -rf /tmp/${tempuuid}/${log4j2name}/*-sources.jar && \
    \rm -rf /tmp/${tempuuid}/${log4j2name}/*-tests.jar && \
    \cp -rf /tmp/${tempuuid}/${log4j2name}/log4j-1.2-api-*.jar /data/app/lib/ && \
    \cp -rf /tmp/${tempuuid}/${log4j2name}/log4j-api-*.jar /data/app/lib/ && \
    \cp -rf /tmp/${tempuuid}/${log4j2name}/log4j-core-*.jar /data/app/lib/ && \
    \cp -rf /tmp/${tempuuid}/${log4j2name}/log4j-web-*.jar /data/app/lib/ && \
    \rm -rf /tmp/${tempuuid} && \
    \rm -rf /data/app/bin/*.bat && \
    \rm -rf /data/app/bin/*.exe && \
    \rm -rf /data/app/libcore/*.dll && \
    \rm -rf /data/app/libextend/*.dll && \
    \rm -rf /data/app/tool && \
    find /data/app | xargs touch && \
    find /data/app -type d -print | xargs chmod 755 && \
    find /data/app -type f -print | xargs chmod 644 && \
    chmod 744 /data/app/bin/* && \
    chmod 644 /data/app/bin/*.jar && \
    chmod 644 /data/app/bin/*.cnf && \
    chmod 600 /data/app/conf/*.password && \
    chmod 777 /data/app/logs && \
    chmod 777 /data/app/temp && \
    chown -R app:app /data/app && \
    /data/app/bin/wrapper-create-linkfile.sh

# set work home
WORKDIR /data

# expose port
EXPOSE 8080 10087 10001 10002

# stop signal
STOPSIGNAL SIGTERM

# entry point
ENTRYPOINT ["/docker-entrypoint.sh"]

# default command
CMD ["/data/app/bin/wrapper-linux-x86-64", "/data/app/conf/wrapper.conf", "wrapper.syslog.ident=myapp", "wrapper.pidfile=/data/app/bin/myapp.pid", "wrapper.name=myapp", "wrapper.displayname=myapp", "wrapper.statusfile=/data/app/bin/myapp.status", "wrapper.java.statusfile=/data/app/bin/myapp.java.status", "wrapper.script.version=3.5.41"]
