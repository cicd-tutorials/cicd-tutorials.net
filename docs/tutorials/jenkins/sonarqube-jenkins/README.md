---
description: Tutorial on how to push code scanning results from Jenkins pipeline to SonarQube and how to display SonarQube data in Jenkins.
tags:
  - Jenkins
  - SonarQube
---

# Integrating Jenkins and SonarQube

This tutorial uses the same Jenkins configuration as the [Jenkins with access to hosts Docker engine](../jenkins-host-docker/) tutorial. If you did any configuration in [jenkins-host-docker](../jenkins-host-docker/) directory, sync the project names with `-p`/`--project-name` option or `COMPOSE_PROJECT_NAME` environment variable to use the same volumes. For example:

```sh
# Replace jenkins with jenkins-host-docker, if you used default project name in jenkins-host-docker directory.

# With -p/--project-name argument:
docker compose -p jenkins up -d

# With COMPOSE_PROJECT_NAME environment variable:
export COMPOSE_PROJECT_NAME=jenkins
docker compose up -d
```

In additions to `jenkins` service, we now define a `sonarqube` service as well in the [docker-compose.yml](./docker-compose.yml):

```yaml title="docker-compose.yml"
---8<--- "docs/tutorials/jenkins/sonarqube-jenkins/docker-compose.yml"
```

## Gettings started with SonarQube

To get started with SonarQube, access the [Web UI](http://localhost:9000) and login with `admin:admin` credentials. Create a access token in [My account > Security](http://localhost:9000/account/security/) and store the token. Use this access token to authenticate to SonarQube from CI instead of the username and password combination.

In order to test the SonarQube installation, run `sonar-scanner` in a code repository. This can be done, for example, by using the [sonarsource/sonar-scanner-cli](https://hub.docker.com/r/sonarsource/sonar-scanner-cli) Docker image:

```bash
# This command should be run in the repository root directory
docker run \
  --rm \
  --net host \
  -e SONAR_HOST_URL="http://localhost:9000" \
  -v ${PWD}:/usr/src \
  sonarsource/sonar-scanner-cli \
  -D"sonar.projectKey=$(basename ${PWD})" \
  -D"sonar.login=${your_sonar_access_token}"
```

If this succeeds, you are ready to move this analysis into Jenkins.

## Using SonarQube from Jenkins pipeline

First, install SonarQube Scanner plugin to your Jenkins instance through [Manage Jenkins > Manage plugins](http://localhost:8080/pluginManager/available) menu. Configure SonarQube instance to SonarQube servers section of the [Manage Jenkins > Configure System](http://localhost:8080/configure) menu: Use `http://sonarqube:9000` as the server URL and create a secret text credential for the access token you stored earlier.

After the SonarQube server is configured to Jenkins, sonar-scanner can be executed in a stage that uses the same [sonarsource/sonar-scanner-cli](https://hub.docker.com/r/sonarsource/sonar-scanner-cli) Docker image that was used in the previous step as well. This can be done with a stage level Docker agent:

```Groovy title="Jenkinsfile"
---8<-- "docs/tutorials/jenkins/sonarqube-jenkins/Jenkinsfile"
```

See [Jenkinsfile](./Jenkinsfile) for a example of a complete pipeline. If you try to execute this example pipeline replace `${GIT_URL}` with the URL to your git repository of choice.

After the pipeline with sonar-scanner run has been executed, the job view in Jenkins should include the SonarQube quality gate status of the linked Sonar Project. Note that in this demo setup these links will not work as the Jenkins uses the `http://sonarqube:9000` URL for the SonarQube server which is likely not accessible from your browser. To see the projects in SonarQube, replace `http://sonarqube:9000` with `http://localhost:9000` in the URL.

Alternative for using `http://sonarqube:9000` or `http://localhost:9000` as the SonarQube URL would be to use your host machines local IP: `http://${HOST_IP}:9000`. On linux systems, you can find your local IP with `hostname -I` command. On Windows systems, you can find your local by looking for IP address from the output of `ipconfig` command. You only need to configure this to the [Manage Jenkins > Configure System](http://localhost:8080/configure) menu. When using local host IP, you can omit the network argument from docker agent block and the links from the job view should work as is.

Note that this setup should only be used for development. For anything production like, configure SonarQube to use database such as postgres, do not use root or admin credentials, and setup the Jenkins and SonarQube to a suitable private network. See also Jenkins and SonarQube documentation for production usage instructions.
