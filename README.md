# simple-satis

### Usage

```
version: "3.1"

services:
  satis:
    image: dots/docker-satis:dev-alpine
    hostname: satis
    environment:
      CRONTAB_FREQUENCY: "*/15 * * * *"
      GITHUB_OAUTH_TOKEN: da244fafb424928beb48003093e0b805c7c195b2
      PRIVATE_REPO_DOMAIN_LIST: github.com
      SATIS_REPO: /run/secrets/satis.json
      SERVICE_PORTS: "8080"
      FORCE_SSL: "true"
    secrets:
      - satis.json
    healthcheck:
      test: ["CMD", "curl", "--fail", "http://localhost:8080/nginx-status"]
      interval: 60s
      timeout: 15s
      retries: 3
    deploy:
      resources:
        memory: 128M
      replicas: 1
      restart_policy:
        condition: on-failure

secrets:
  satis.json:
    file: satis.json
```
