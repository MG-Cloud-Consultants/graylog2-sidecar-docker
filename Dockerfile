FROM debian:jessie-slim

LABEL maintainer 'Markus Gulden <mg@gulden.consulting>'

RUN apt-get update && apt-get install -y openssl libapr1 libdbi1 libexpat1 ca-certificates

ENV SIDECAR_BINARY_URL https://github.com/Graylog2/collector-sidecar/releases/download/1.0.1/graylog-sidecar_1.0.1-1_amd64.deb
ENV FILEBEAT_BINARY_URL https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-7.1.1-amd64.deb
RUN apt-get install -y --no-install-recommends curl && curl -Lo sidecar.deb ${SIDECAR_BINARY_URL} && dpkg -i sidecar.deb && rm sidecar.deb && curl -Lo filebeat.deb ${FILEBEAT_BINARY_URL} && dpkg -i filebeat.deb && rm filebeat.deb && apt-get purge -y --auto-remove curl
ENV GS_UPDATE_INTERVAL=10 \
    GS_TLS_SKIP_VERIFY="false" \
    GS_SEND_STATUS="true" \
    GS_LIST_LOG_FILES="[]" \
    GS_CACHE_PATH="/var/cache/graylog-sidecar" \
    GS_COLLECTOR_CONFIGURATION_DIRECTORY="/var/lib/graylog-sidecar/generated" \
    GS_LOG_PATH="/var/log/graylog-sidecar" \
	GS_LOG_ROTATE_MAX_FILE_SIZE="10MiB" \
	GS_LOG_ROTATE_KEEP_FILES=10 \
	GS_COLLECTOR_BINARIES_WHITELIST="["/usr/bin/filebeat", "/usr/bin/packetbeat", "/usr/bin/metricbeat", "/usr/bin/heartbeat", "/usr/bin/auditbeat", "/usr/bin/journalbeat", "/usr/share/filebeat/bin/filebeat", "/usr/share/packetbeat/bin/packetbeat", "/usr/share/metricbeat/bin/metricbeat", "/usr/share/heartbeat/bin/heartbeat", "/usr/share/auditbeat/bin/auditbeat", "/usr/share/journalbeat/bin/journalbeat", "/usr/bin/nxlog", "/opt/nxlog/bin/nxlog"]"
ADD ./data /data
CMD /usr/bin/graylog-sidecar -c /data/sidecar.yml