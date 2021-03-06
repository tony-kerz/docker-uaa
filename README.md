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
docker run --rm \
  -v /var/run/docker.sock:/var/run/docker.sock:ro \
  -e UAA_CONFIG_URL=https://raw.githubusercontent.com/tony-kerz/docker-uaa/master/uaa.yml \
  -e PUBLIC_HOST=ip-10-0-1-80.ec2.internal \
  -p 8080 \
  healthagen/uaa:2.7.2

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
      "path": "/healthz"
    }
  ],
  "env": {
    "UAA_CONFIG_URL": "https://raw.githubusercontent.com/tony-kerz/docker-uaa/tk/wip/uaa.yml",
    "PUBLIC_HOST": "uaa.x.healthagen.com"
  },
  "labels": {
    "VIRTUAL_HOST": "uaa.x.healthagen.com"
  }
}
'
```
