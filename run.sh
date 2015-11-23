#!/bin/bash -x

if [ -n "$UAA_CONFIG_URL" ]; then
  curl -Lo /uaa/uaa.yml $UAA_CONFIG_URL
else
  pgLoc="$(docker run --rm healthagen/mesos-dns-discover:c136401 -s uaa-postgres)"
  IFS=:
  toks=($pgLoc)
  export DB_PORT_5432_TCP_ADDR=${toks[0]}
  export DB_PORT_5432_TCP_PORT=${toks[1]}
fi

$CATALINA_HOME/bin/catalina.sh run