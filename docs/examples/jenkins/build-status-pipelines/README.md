---
description: Tutorial on how to configure a Jenkins pipeline that creates pipelines with five different statuses into a new folder using Job DSL.
---

# Build status pipelines and Job DSL

This example contains pipelines to produce builds with success, unstable, failed, aborted, and not-built statuses as well as Job DSL script to create a folder with projects that have these five different statuses.

## Preparing the Jenkins instance

The pipeline provided by this example can be added to any Jenkins instance you have administrator access. For example, Jenkins configuration from [Jenkins with access to hosts Docker engine](../jenkins-host-docker/) example can be used.

In order to be able to run the seed project we will need [Job DSL](https://plugins.jenkins.io/job-dsl/) plugin. Install the plugin through Available tab in [Manage Jenkins > Manage Plugins](http://localhost:8080/pluginManager/available).

## Creating and running the seed project

To run the job DSL script, create a new pipeline with following script as an inline pipeline script and run the created pipeline.

```groovy
node {
    git branch: 'main', url: 'https://github.com/kangasta/cicd-examples.git'
    jobDsl targets: 'docs/examples/jenkins/build-status-pipelines/jobs.groovy'
}
```

The execution will likely fail with `ERROR: script not yet approved for use` message. To enable this script, navigate to [Manage Jenkins > In-process Script Approval](http://localhost:8080/scriptApproval/), inspect the script, and click _Approve_. Then try to run the created seed project again. It should now succeed and list the created resources.
