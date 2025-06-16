---
description: Tutorial on how to configure a Jenkins pipeline that deploys an feedback application to a Kubernetes cluster.
---

# Deploy application to Kubernetes with OpenTofu

This tutorial contains a pipeline that deploys an feedback application to a Kubernetes cluster.

## Prerequisites and preparing the Jenkins instance

See [Deploy application to Kubernetes with Ansible](../ansible-kubernetes/) tutorial for prerequisites and instruction for configuring access from the Jenkins instance to the Kubernetes cluster.

## Configure the pipeline

First, create a new pipeline via [New Item](http://localhost:8080/view/all/newJob) button in the right side menu of the Jenkins dashboard. The name of the pipeline could be for example `Feedback-Deploy` and it should be an pipeline.

In the configure pipeline view, scroll to the bottom and under Pipeline sub-header select `Pipeline script`. Copy the script from below to the _Script_ textarea.

The pipeline deploys an example application to a Kubernetes cluster using OpenTofu configuration. The pipeline will first plan the deployment and then ask approval from an user before applying the plan to the target cluster.

```groovy title="Jenkinsfile"
---8<--- "docs/tutorials/jenkins/opentofu-kubernetes/Jenkinsfile"
```

After you have created the pipeline, try to execute it by clicking _Build Now_. The pipeline should have deployed the example application.

You can find the URL of the created application from the console output of the build. Open the application with your browser or use curl to see the application response.
