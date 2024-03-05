FROM ubuntu:22.04

ARG CRAC_JDK_URL

ENV JAVA_HOME /opt/jdk
ENV PATH $JAVA_HOME/bin:$PATH
ENV CRAC_FILES_DIR /opt/crac-files

RUN set -eux; \
    apt-get update; \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends curl ca-certificates; \
    rm -rf /var/lib/apt/lists/*; \
    mkdir -p $JAVA_HOME; \
    curl -LfSo $JAVA_HOME/openjdk.tar.gz $CRAC_JDK_URL; \
    cd $JAVA_HOME; \
    tar --extract --file $JAVA_HOME/openjdk.tar.gz --directory "$JAVA_HOME" --strip-components 1; \
    rm $JAVA_HOME/openjdk.tar.gz;

COPY src/scripts/entrypoint.sh /opt/app/entrypoint.sh

RUN mkdir -p /opt/app
COPY target/crac-db-sample-0.0.1-SNAPSHOT.jar /opt/app/crac-db-sample-0.0.1-SNAPSHOT.jar

ENTRYPOINT /opt/app/entrypoint.sh
