---
description: Tutorial on how to configure a Jenkins pipeline that executes Robot Framework automation tasks with docker agent in parallel stages as well as combines and stores the produced HTML/XML report files.
---

# Parallel Robot Framework pipeline

This directory provides an example of a Jenkins pipeline that executes Robot Framework automation tasks with docker agent in parallel stages as well as combines and stores the produced HTML/XML report files.

## Preparing the Jenkins instance

The pipeline provided by this example can be added to any Jenkins instance you have administrator access and can run pipeline stages with docker agent. For example, Jenkins configuration from [Jenkins with access to hosts Docker engine](../jenkins-host-docker/) example can be used.

In order to be able to run the pipeline we will need [Docker Pipeline](https://plugins.jenkins.io/docker-workflow/) and [Robot Framework](https://plugins.jenkins.io/robot/) plugins. Install these plugins through _Available_ tab in [Manage Jenkins > Manage Plugins](http://localhost:8080/pluginManager/available) and restart the Jenkins instance after these plugins have been installed. The restart can be done, for example, from the plugins page or by restarting the container with `docker compose down` and `docker compose up`.

## Configure the pipeline

First, create a new pipeline via _[New Item](http://localhost:8080/view/all/newJob)_ button in the rigth side menu of the Jenkins dashboard. The name of the pipeline could be for example `Screenshots` and it should be an pipeline.

In the configure pipeline view, scroll to the bottom and under Pipeline sub-header select `Pipeline script from SCM`. SCM type should be `Git` and Repository URL the url of this repository: `https://github.com/kangasta/cicd-examples.git`. Ensure that branch specifier includes `main` branch of the repository and modify the Script Path to be `docs/examples/jenkins/parallel-robot-pipeline/Jenkinsfile`.

The pipeline executes the same Robot Framework suite twice: once with Firefox and once with Chromium. This is done in parallel. After the test suites have finished, the log files are combined in the next stage.

```groovy title="Jenkinsfile"
---8<--- "docs/examples/jenkins/parallel-robot-pipeline/Jenkinsfile"
```

After you have created the pipeline, try to execute it by clicking _Build Now_. All Robot Framework tasks should be in Skipped state as we did not specify an URL variable. In addition, after the first execution Jenkins should have updated the project configuration to contain parameters defined in the pipeline and we can now pass target URL to our automation tasks in _Build with Parameters_ menu.

The Robot Framework suite defined in [suites/screenshot.robot](./suites/screenshot.robot) uses Browser library to take a screenshot of the page available in the URL defined with the URL variable.

```robot title="suites/screenshot.robot"
---8<--- "docs/examples/jenkins/parallel-robot-pipeline/suites/screenshot.robot"
```

Finally, If the robot log cannot be loaded after task execution, see [this stackoverflow post](https://stackoverflow.com/questions/36607394/error-opening-robot-framework-log-failed) for solution. To summarize, run following command in Jenkins Script Console to modify Jenkins servers Content Security Policy (CSP):

```groovy
System.setProperty("hudson.model.DirectoryBrowserSupport.CSP","sandbox allow-scripts; default-src 'none'; img-src 'self' data: ; style-src 'self' 'unsafe-inline' data: ; script-src 'self' 'unsafe-inline' 'unsafe-eval' ;")
```

## Building and running the Docker container

The Jenkins pipeline listed above uses container image from Github Container Registry to run the pipelines. The container image is created using [Dockerfile](./Dockerfile) defined by this tutorial.

```Dockerfile title="Dockerfile"
---8<--- "docs/examples/jenkins/parallel-robot-pipeline/Dockerfile"
```

The Dockerfile is based on Playwright image that contains the Browser binaries and other Playwright related dependencies of the Browser library. In addition, the Dockerfile installs Python and Python libraries defined in [requirements.txt](./requirements.txt) to the container image.

```txt title="requirements.txt"
---8<--- "docs/examples/jenkins/parallel-robot-pipeline/requirements.txt"
```

## Running the tasks locally

Build the Docker containers with `docker build`:

```sh
docker build . --tag rf-screenshot
```

Execute the Robot Framework suites with `docker run`:

```sh
# Chromium
docker run --rm -v $(pwd)/out:/out -e BROWSER=chromium rf-screenshot -d /out -v URL:https://kangasta.github.io/cicd-examples/

# Firefox
docker run --rm -v $(pwd)/out:/out -e BROWSER=firefox rf-screenshot -d /out -v URL:https://kangasta.github.io/cicd-examples/
```
