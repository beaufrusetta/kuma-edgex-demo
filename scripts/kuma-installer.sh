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
  DATAPLANE_NAME="${DATAPLANE_HOSTNAME}"

  #
  # Resolve IP address allocated to the "${DATAPLANE_NAME}" container
  #

  DATAPLANE_IP_ADDRESS=$( resolve_ip ${DATAPLANE_HOSTNAME} )
  if [ -z "${DATAPLANE_IP_ADDRESS}" ]; then
    fail "failed to resolve IP address allocated to the '${DATAPLANE_HOSTNAME}' container"
  fi
  echo "'${DATAPLANE_HOSTNAME}' has the following IP address: ${DATAPLANE_IP_ADDRESS}"

  DATAPLANE_RESOURCE=$(cat /kuma/dataplanes/${DATAPLANE_NAME}.yml | sed -e "s/IP/${DATAPLANE_IP_ADDRESS}/g")

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
# Create Dataplane for all services
#
# DATAPLANES="edgex-core-consul edgex-redis edgex-support-logging edgex-sys-mgmt-agent  \
#             edgex-support-notifications edgex-core-metadata edgex-core-data edgex-core-command \
#             edgex-support-scheduler edgex-app-service-configurable-rules edgex-support-rulesengine \
#             edgex-device-virtual"

DATAPLANES="edgex-core-consul edgex-redis edgex-support-logging"

for DP in ${DATAPLANES}; do 
  create_dataplane ${DP}
done
