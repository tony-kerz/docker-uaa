#!/bin/bash -x

if [ -n "$UAA_CONFIG_URL" ]; then
  curl -Lo /uaa/uaa.yml $UAA_CONFIG_URL
fi

pgLoc="$(docker run --rm healthagen/mesos-dns-discover:c136401 -s uaa-postgres)"
IFS=:
toks=($pgLoc)
export DB_PORT_5432_TCP_ADDR=${toks[0]}
export DB_PORT_5432_TCP_PORT=${toks[1]}

# HOST should be set by marathon to dns-name of slave host
export PRIVATE_HOST=$HOST
export PUBLIC_HOST=$PUBLIC_HOST

$CATALINA_HOME/bin/catalina.sh run
