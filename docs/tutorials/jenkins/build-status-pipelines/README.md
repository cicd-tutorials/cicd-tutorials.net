---
description: Tutorial on how to configure a Jenkins pipeline that creates pipelines with five different statuses into a new folder using Job DSL.
tags:
  - Jenkins
---

# Build status pipelines and Job DSL

This tutorial contains pipelines to produce builds with success, unstable, failed, aborted, and not-built statuses as well as Job DSL script to create a folder with projects that have these five different statuses.

## Preparing the Jenkins instance

The pipeline provided by this tutorial can be added to any Jenkins instance you have administrator access. For example, Jenkins configuration from [Jenkins with access to hosts Docker engine](../jenkins-host-docker/) tutorial can be used.

In order to be able to run the seed project we will need [Job DSL](https://plugins.jenkins.io/job-dsl/) plugin. Install the plugin through Available tab in [Manage Jenkins > Manage Plugins](http://localhost:8080/pluginManager/available).

## Creating and running the seed project

To run the job DSL script, create a new pipeline with following script as an inline pipeline script and run the created pipeline.

```groovy
node {
    git branch: 'main', url: 'https://github.com/cicd-tutorials/cicd-tutorials.net.git'
    jobDsl targets: 'docs/tutorials/jenkins/build-status-pipelines/jobs.groovy'
}
```

The execution will likely fail with `ERROR: script not yet approved for use` message. To enable this script, navigate to [Manage Jenkins > In-process Script Approval](http://localhost:8080/scriptApproval/), inspect the script, and click _Approve_. Then try to run the created seed project again. It should now succeed and list the created resources.

The scripted pipeline listed above executes [jobs.groovy](./jobs.groovy) script. This script creates five new pipelines and executes four of those.

```groovy title="jobs.groovy"
---8<--- "docs/tutorials/jenkins/build-status-pipelines/jobs.groovy"
```

The four different pipeline scripts used to create the jobs are listed below. The final job, `Status/Not built`, uses the same script as `Status/Success`, but the build is not executed.

=== "Aborted"

    Defines a pipeline that has a three minute timeout and build step that takes more than three minutes.

    ```groovy title="aborted.Jenkinsfile"
    ---8<--- "docs/tutorials/jenkins/build-status-pipelines/aborted.Jenkinsfile"
    ```

=== "Failed"

    Defines a pipeline with single `sh` step that produces a non-zero exit code.

    ```groovy title="failed.Jenkinsfile"
    ---8<--- "docs/tutorials/jenkins/build-status-pipelines/failed.Jenkinsfile"
    ```

=== "Success"

    Defines a pipeline with single succeeding `sh` step.

    ```groovy title="success.Jenkinsfile"
    ---8<--- "docs/tutorials/jenkins/build-status-pipelines/success.Jenkinsfile"
    ```

=== "Unstable"

    Defines a pipeline with single `unstable` step.

    ```groovy title="unstable.Jenkinsfile"
    ---8<--- "docs/tutorials/jenkins/build-status-pipelines/unstable.Jenkinsfile"
    ```
