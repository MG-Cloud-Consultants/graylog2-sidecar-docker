# Graylog Sidecar Docker Image with Filebeat
A Docker image for the [Graylog 3.0 sidecar](https://docs.graylog.org/en/3.1/pages/sidecar.html), using [Filebeat](https://www.elastic.co/products/beats/filebeat) for collecting log files


## Configuration

The container uses environment variables for configuring Sidecar. Following parameters are available:

*  GS_SERVER_URL   *(REQUIRED)*
   *  URL to the Graylog API, e.g. http:/localhost:9000/api/
*  GS_SERVER_API_TOKEN   *(REQUIRED)*
   *  The API token to use to authenticate against the Graylog server API
   *  E.g. 1jq26cssvc6rj4qac4bt9oeeh0p4vt5u5kal9jocl1g9mdi4og3n
*  GS_NODE_ID   *(REQUIRED)*
   *  The node ID of the sidecar. This can be a path to a file or an ID string.
   *  Example file path: file:/etc/graylog/sidecar/node-id
   *  Example ID string: 6033137e-d56b-47fc-9762-cd699c11a5a9
   *  ATTENTION: Every sidecar instance needs a unique ID
   *  Default: file:/etc/graylog/sidecar/node-id
*  GS_NODE_NAME
   *  Name of the Sidecar instance, will also show up in the web interface. The hostname will be used if not set
*  GS_UPDATE_INTERVAL
   *  The interval in seconds the sidecar will fetch new configurations from the Graylog server
   *  Default: 10
*  GS_TLS_SKIP_VERIFY
   *  This configures if the sidecar should skip the verification of TLS connections
   *  Default: false
*  GS_SEND_STATUS
   *  This controls the transmission of detailed sidecar information like collector status, metrics and log file lists. It can be disabled to reduce load on the Graylog server if needed
   *  Default: true
*  GS_LIST_LOG_FILES
   *  Send a directory listing to Graylog and display it on the host status page, e.g. /var/log. This can also be a list of directories
   * Default: []
*  GS_CACHE_PATH
   *  The directory where the sidecar stores internal data
   *  Default: /var/cache/graylog-sidecar
*  GS_COLLECTOR_CONFIGURATION_DIRECTORY
   *  The directory where the sidecar generates configurations for collectors.
   *  Default: /var/lib/graylog-sidecar/generated
*  GS_LOG_PATH
   *  The directory where the sidecar stores its logs
   *  Default: /var/log/graylog-sidecar
*  GS_LOG_ROTATE_MAX_FILE_SIZE
   *  The maximum size of the log file before it gets rotated
   *  Default: 10MiB
*  GS_LOG_ROTATE_KEEP_FILES
   *  The maximum number of old log files to retain
   *  Default: 10
*  GS_COLLECTOR_BINARIES_WHITELIST
   *  A list of binaries which are allowed to be executed by the Sidecar
   *  An empty list disables the white list feature
   *  Default: /usr/bin/filebeat, /usr/bin/packetbeat, /usr/bin/metricbeat, /usr/bin/heartbeat, /usr/bin/auditbeat, /usr/bin/journalbeat, /usr/share/filebeat/bin/filebeat, /usr/share/packetbeat/bin/packetbeat, /usr/share/metricbeat/bin/metricbeat, /usr/share/heartbeat/bin/heartbeat, /usr/share/auditbeat/bin/auditbeat, /usr/share/journalbeat/bin/journalbeat, /usr/bin/nxlog, /opt/nxlog/bin/nxlog

Filebeat must be configured in Graylog, see http://docs.graylog.org/en/3.0/pages/sidecar.html#using-configuration-variables

Also, the monitored folder needs to be mounted for the docker container.

## Usage

An example docker-compose file could look like this:
```
version: "2.1"
services:
  graylog-sidecar:
    image: markusgulden/graylog2-sidecar-docker
    environment:
      - GS_SERVER_URL=http://localhost:9000/api/
      - GS_NODE_ID=a-unique-id
      - GS_SERVER_API_TOKEN=mv52k4jo5qvgto6o35ep5rgrhfp3jnq20hlpkrbk6blhporuqj6
      - GS_LIST_LOG_FILES=/var/log/some-folder
    volumes:
      - /c/tmp/docker-fs/applications:/var/log/some-folder:ro
```
