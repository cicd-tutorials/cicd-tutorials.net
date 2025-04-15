---
description: Tutorial on how to run Jenkins inside a container with Docker client that controls host machines Docker engine using a socket.
tags:
  - Docker
  - Jenkins
---

# Jenkins with access to hosts Docker engine

This tutorial provider Docker Compose configuration for running Jenkins inside a container with Docker client that controls host machines Docker engine using a socket. This works well in development environments as you can inspect containers created by Jenkins from the host system.

Note that by default each of the example Docker Compose configurations will create their own volumes for the data. This might not be what you want, if you want to use configuration from [Integrating Jenkins and SonarQube](../sonarqube-jenkins/README.md) as well. In order to use the same volumes for every docker compose configuration, run docker compose with `-p` (or `--project-name`) option. This can also be done by setting `COMPOSE_PROJECT_NAME` environment variable:

```sh
export COMPOSE_PROJECT_NAME=jenkins
```

## Jenkins image with Docker client

To be able run Docker commands from inside the Jenkins container, we will need to install the Docker client. This can be done with a suitable Dockerfile:

```Dockerfile title="Dockerfile"
--8<-- "docs/tutorials/jenkins/jenkins-host-docker/Dockerfile"
```

## Jenkins container with access to hosts Docker engine

When running Jenkins in a container, we will want to define ports and volumes. To do this, we will use a `docker-compose.yml` configuration:

```yaml title="docker-compose.yml"
--8<-- "docs/tutorials/jenkins/jenkins-host-docker/docker-compose.yml"
```

These files are available in the repository that provides this website. In order to run Jenkins container with Docker-in-Docker support, `cd` into `docs/tutorials/jenkins/jenkins-host-docker` directory and run `docker compose up`.

=== "Background"

    To run the Jenkins container in the background, execute `docker compose up` command with `-d`/`--detach` flag:

    ```sh
    cd docs/tutorials/jenkins/jenkins-host-docker

    docker compose up --build --detach
    ```

    This allows the Jenkins container to continue running even if you close the terminal session. Use `docker compose logs` command to see the logs.

=== "Foreground"

    To run the Jenkins container in the foreground, execute `docker compose up` command without `-d`/`--detach` flag:

    ```sh
    cd docs/tutorials/jenkins/jenkins-host-docker

    docker compose up --build
    ```

    You can now monitor the logs produced by the Jenkins container in your current shell. However, if you close the terminal session or send an interrupt signal (for example by pressing CTRL+C), the Jenkins container will be stopped.

---

The initial admin password can be printed with `docker compose exec` command:

```sh
docker compose exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```

In order to get started with Jenkins, the suggested plugins are often good a starting point. If you are planning to create pipeline projects with stages running in on-demand Docker containers, you will also need [Docker Pipeline](https://plugins.jenkins.io/docker-workflow/) plugin. This can be installed through the [Manage Jenkins > Manage plugins](http://localhost:8080/pluginManager/available) menu.
