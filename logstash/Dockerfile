FROM docker.elastic.co/logstash/logstash:8.15.0
RUN bin/logstash-plugin install logstash-output-opensearch
ARG MARIADB_CONNECTOR_VERSION=3.5.3
USER root

RUN mkdir -p /usr/share/logstash/drivers && \
    curl -fSL -o /usr/share/logstash/drivers/mariadb-connector.jar \
      "https://repo1.maven.org/maven2/org/mariadb/jdbc/mariadb-java-client/${MARIADB_CONNECTOR_VERSION}/mariadb-java-client-${MARIADB_CONNECTOR_VERSION}.jar" && \
    chown -R logstash:logstash /usr/share/logstash/drivers && \
    chmod 644 /usr/share/logstash/drivers/mariadb-connector.jar
# ---------------------------------------------------------------------------
# tracking state
# ---------------------------------------------------------------------------
RUN mkdir -p /usr/share/logstash/sync_state && \
    chown -R logstash:logstash /usr/share/logstash/sync_state

USER logstash