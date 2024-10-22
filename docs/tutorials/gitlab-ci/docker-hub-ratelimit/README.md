---
description: Tutorial on how to test if Docker-in-Docker service in GitLab CI accesses Docker Hub directly and how to configure pull-through cache to an Kubernetes cluster working as a GitLab runner.
---

# Docker-in-Docker service and Docker Hub ratelimit

The recommended way of running Docker commands in a GitLab CI Kubernets runner is to use a service to run Docker-in-Docker container (`docker:dind`). By default the `docker:dind` container pulls container images from Docker Hub without caching. This can cause problems as pulls from Docker Hub are rate-limited.

This tutorial tests how `docker pull ubuntu:24.04` commands consume Docker Hub ratelimit and provides example on how to configure pull-through cache to an Kubernetes cluster working as a GitLab runner.

## How to check if `docker pull` commands are cached

Create a new GitLab project with `.gitlab-ci.yml` and `scripts/check-docker-hub-ratelimit.sh` files.

The `scripts/check-docker-hub-ratelimit.sh` script prints current Docker Hub ratelimit and also writes the result to a file if filename is given as first parameter. See [Docker Hub usage and rate limits](https://docs.docker.com/docker-hub/download-rate-limit/#how-can-i-check-my-current-rate) article in Docker documentation for more details.

```sh title="scripts/check-docker-hub-ratelimit.sh"
---8<--- "docs/tutorials/gitlab-ci/docker-hub-ratelimit/scripts/check-docker-hub-ratelimit.sh"
```

The pipeline defined by `.gitlab-ci.yml` tries to pull the same Docker image twice and checks if the rate limit headers are different after first and second pull.

```yaml title=".gitlab-ci.yml"
---8<--- "docs/tutorials/gitlab-ci/docker-hub-ratelimit/.gitlab-ci.yml"
```

The pipeline should fail, if images are pulled directly from Docker Hub.

## How to setup pull-through cache to Kubernetes runner

Manifests for configuring pull-through cache and configmap are available in the repository that provides this website.

```sh
git clone https://github.com/cicd-tutorials/cicd-tutorials.net.git
cd docs/tutorials/gitlab-ci/docker-hub-ratelimit
```

Configure pull-through cache and configmap for GitLab runner by running `kubectl apply -f manifests/`.

```sh
kubectl apply -f manifests/
```

These manifests assume that GitLab runner is using gitlab-runner namespace. Edit the namespace value in [docker-config.yaml](./manifests/docker-config.yaml) if this is not the case.

Modify the GitLab runner configuration so that the configmap defined in [docker-config.yaml](./manifests/docker-config.yaml) is mounted to all containers launched by the GitLab runner. Example of a full `values.yaml` help input file below.

```yaml
gitlabUrl: # Your instance URL
rbac: { create: true }
runnerToken: # Your runner token
runners:
  config: |
    [[runners]]
      executor = "kubernetes"
      [runners.kubernetes]
        image = "alpine:3.12"
        privileged = true
        [[runners.kubernetes.volumes.config_map]]
          name = "dockerd-config"
          mount_path = "/etc/docker/daemon.json"
          sub_path = "daemon.json"
```
