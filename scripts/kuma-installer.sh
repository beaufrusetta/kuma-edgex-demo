#!/usr/bin/env sh

set -e

#
# Utility functions
#

function resolve_ip {
  nslookup "${1}" 2>/dev/null | tail -1 | awk '{print $3}'
}

function fail {
  printf 'Error: %s\n' "${1}" >&2  ## Send message to stderr. Exclude >&2 if you don't want it that way.
  exit "${2-1}"                    ## Return a code specified by $2 or 1 by default.
}

function create_dataplane {
  DATAPLANE_HOSTNAME="$1"
  DATAPLANE_RESOURCE="$2"
  DATAPLANE_NAME="${DATAPLANE_HOSTNAME}"

  #
  # Resolve IP address allocated to the "${DATAPLANE_NAME}" container
  #

  DATAPLANE_IP_ADDRESS=$( resolve_ip ${DATAPLANE_HOSTNAME} )
  if [ -z "${DATAPLANE_IP_ADDRESS}" ]; then
    fail "failed to resolve IP address allocated to the '${DATAPLANE_HOSTNAME}' container"
  fi
  echo "'${DATAPLANE_HOSTNAME}' has the following IP address: ${DATAPLANE_IP_ADDRESS}"

  #
  # Create Dataplane for "${DATAPLANE_NAME}"
  #

  echo "${DATAPLANE_RESOURCE}" | kumactl apply -f - \
    --var IP=${DATAPLANE_IP_ADDRESS}

  #
  # Create token for "${DATAPLANE_NAME}"
  #
  [ ! -d "/sidecar-data/${DATAPLANE_HOSTNAME}" ] && mkdir -p /sidecar-data/${DATAPLANE_HOSTNAME}
  kumactl generate dataplane-token --dataplane=${DATAPLANE_HOSTNAME} > /sidecar-data/${DATAPLANE_HOSTNAME}/token
}

#
# Arguments
#

KUMA_CONTROL_PLANE_URL=http://kuma-control-plane:5681

#
# Configure `kumactl`
#

kumactl config control-planes add --name universal --address ${KUMA_CONTROL_PLANE_URL} --admin-client-cert /certs/client/cert.pem --admin-client-key /certs/client/cert.key --overwrite

#
# Create Dataplane for `edgex-core-consul` service
#

create_dataplane "edgex-core-consul" "
type: Dataplane
mesh: default
name: edgex-core-consul
networking:
  inbound:
    - interface: {{ IP }}:58400:8400
      tags:
        service: edgex-core-consul
    - interface: {{ IP }}:58500:8500
      tags:
        service: edgex-core-consul"

create_dataplane "edgex-redis" "
type: Dataplane
mesh: default
name: edgex-redis
networking:
  inbound:
    - interface: {{ IP }}:56379:6379
      tags:
        service: edgex-redis"

create_dataplane "edgex-support-logging" "
type: Dataplane
mesh: default
name: edgex-support-logging
networking:
  inbound:
    - interface: {{ IP }}:58061:48061
      tags:
        service: edgex-support-logging"

# create_dataplane "edgex-sys-mgmt-agent" "
# type: Dataplane
# mesh: default
# name: edgex-sys-mgmt-agent
# networking:
#   inbound:
#     - interface: {{ IP }}:58090:48090
#       tags:
#         service: edgex-sys-mgmt-agent"

# create_dataplane "edgex-support-notifications" "
# type: Dataplane
# mesh: default
# name: edgex-support-notifications
# networking:
#   inbound:
#     - interface: {{ IP }}:58060:48060
#       tags:
#         service: edgex-support-notifications"

create_dataplane "edgex-core-metadata" "
type: Dataplane
mesh: default
name: edgex-core-metadata
networking:
  inbound:
    - interface: {{ IP }}:58081:48081
      tags:
        service: edgex-core-metadata"

create_dataplane "edgex-core-data" "
type: Dataplane
mesh: default
name: edgex-core-data
networking:
  inbound:
    - interface: {{ IP }}:58080:48080
      tags:
        service: edgex-core-data
    - interface: {{ IP }}:55563:5563
      tags:
        service: edgex-core-data"

# create_dataplane "edgex-core-command" "
# type: Dataplane
# mesh: default
# name: edgex-core-command
# networking:
#   inbound:
#     - interface: {{ IP }}:58082:48082
#       tags:
#         service: edgex-core-command"

# create_dataplane "edgex-support-scheduler" "
# type: Dataplane
# mesh: default
# name: edgex-support-scheduler
# networking:
#   inbound:
#     - interface: {{ IP }}:58085:48085
#       tags:
#         service: edgex-support-scheduler"

create_dataplane "edgex-app-service-configurable-rules" "
type: Dataplane
mesh: default
name: edgex-app-service-configurable-rules
networking:
  inbound:
    - interface: {{ IP }}:58100:48100
      tags:
        service: edgex-app-service-configurable-rules"

# create_dataplane "edgex-support-rulesengine" "
# type: Dataplane
# mesh: default
# name: edgex-support-rulesengine
# networking:
#   inbound:
#     - interface: {{ IP }}:58075:48075
#       tags:
#         service: edgex-support-rulesengine"

# create_dataplane "edgex-device-virtual" "
# type: Dataplane
# mesh: default
# name: edgex-device-virtual
# networking:
#   inbound:
#     - interface: {{ IP }}:59990:49990
#       tags:
#         service: edgex-device-virtual"
