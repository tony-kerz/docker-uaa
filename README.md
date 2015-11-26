```
curl -sSv -X POST -H 'Content-type: application/json' master.mesos:8080/v2/apps -d \
'{
  "id": "uaa-postgres",
  "cpus": 1,
  "mem": 1024,
  "container": {
    "type": "DOCKER",
    "docker": {
      "image": "postgres:9.5",
      "network": "BRIDGE",
      "portMappings": [
        {
          "containerPort": 5432
        }
      ]
    },
    "volumes": [
      {
        "containerPath": "/var/lib/postgresql/data",
        "hostPath": "/var/lib/uaa-postgres",
        "mode": "RW"
      }
    ]
  },
  "healthChecks": [
    {
      "protocol": "TCP",
      "gracePeriodSeconds": 300
    }
  ],
  "constraints": [
    ["hostname", "CLUSTER", "ip-10-0-1-80.ec2.internal"]
  ]
}'
```
```
#docker run --rm -e DB_PORT_5432_TCP_ADDR=10.0.1.80 -e DB_PORT_5432_TCP_PORT=5432 healthagen/uaa:2.7.1
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock:ro healthagen/uaa:2.7.2
```
```
curl -sSv -X POST -H 'Content-type: application/json' master.mesos:8080/v2/apps -d \
'
{
  "id": "uaa",
  "cpus": 0.50,
  "mem": 1024,
  "container": {
    "type": "DOCKER",
    "docker": {
      "image": "healthagen/uaa:2.7.2",
      "forcePullImage": true,
      "network": "BRIDGE",
      "portMappings": [
        {
          "containerPort": 8080
        }
      ]
    },
    "volumes": [
      {
        "containerPath": "/var/run/docker.sock",
        "hostPath": "/var/run/docker.sock",
        "mode": "RO"
      }
    ]
  },
  "healthChecks": [
    {
      "path": "/login"
    }
  ],
  "env": {
    "PUBLIC_HOST": "uaa.x.healthagen.com"
  },
  "labels": {
    "VIRTUAL_HOST": "uaa.x.healthagen.com"
  }
}
'
```
