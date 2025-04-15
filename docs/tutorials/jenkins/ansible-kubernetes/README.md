---
description: Tutorial on how to configure a Jenkins pipeline that deploys an simple hello-world application to a Kubernetes cluster.
tags:
  - Ansible
  - Jenkins
  - Kubernetes
---

# Deploy application to Kubernetes with Ansible

This tutorial contains a pipeline that deploys an simple hello-world application to a Kubernetes cluster.

## Prerequisites

You will need a running Kubernetes cluster, that supports services with `LoadBalancer` type, and a kubeconfig file that can be used to deploy application (a deployment and a service) into the cluster.

## Preparing the Jenkins instance

The pipeline provided by this tutorial can be added to any Jenkins instance you have administrator access and can run pipeline stages with docker agent. For example, Jenkins configuration from [Jenkins with access to hosts Docker engine](../jenkins-host-docker/) tutorial can be used.

We will use secret file to configure credentials for managing the target Kubernetes cluster. To create the secret file credential, open _Global credentials_ from _Jenkins_ credentials store from [Manage Jenkins > Manage Credentials](http://localhost:8080/credentials/) and click _Add Credentials_ from the left side menu.

In the _New credentials_ form:

1. Select _Secret file_ as the credential _kind_
2. Upload your kubeconfig to the _file_ input
3. Configure _ID_ for the credential. [Jenkinsfile](./Jenkinsfile) uses `kubeconfig` as the ID.
4. (Optionally) add a description.

## Configure the pipeline

First, create a new pipeline via [New Item](http://localhost:8080/view/all/newJob) button in the rigth side menu of the Jenkins dashboard. The name of the pipeline could be for example `Animals` and it should be an pipeline.

In the configure pipeline view, scroll to the bottom and under Pipeline sub-header select `Pipeline script from SCM`. SCM type should be `Git` and Repository URL the url of this repository: `https://github.com/cicd-tutorials/cicd-tutorials.net.git`. Ensure that branch specifier includes `main` branch of the repository and modify the Script Path to be `docs/tutorials/jenkins/ansible-kubernetes/Jenkinsfile`.

The pipeline deploys an example application to a Kubernetes cluster using Ansible playbook. The playbook selects a container image tag based on Jenkins build parameter.

```groovy title="Jenkinsfile"
---8<--- "docs/tutorials/jenkins/ansible-kubernetes/Jenkinsfile"
```

After you have created the pipeline, try to execute it by clicking _Build Now_. The pipeline should have deployed the example application into the Kubernetes cluster with the default image tag (`cow`) defined in the [deploy-to-kubernetes.yml](./deploy-to-kubernetes.yml) Ansible playbook.

```yaml title="deploy-to-kubernetes.yml"
---8<--- "docs/tutorials/jenkins/ansible-kubernetes/deploy-to-kubernetes.yml"
```

After the Ansible playbook has been executed, the pipeline runs [wait-until-service-up.sh](./wait-until-service-up.sh) script. The script waits until the load-balancer created by the Kubernetes service has reached running state and parses the URL where the example application is running.

```sh
---8<--- "docs/tutorials/jenkins/ansible-kubernetes/wait-until-service-up.sh"
```

You can find the URL of the created load-balancer from the console output of the build. Open the application with your browser or user curl to see the application response.

In addition, after the first execution Jenkins should have updated the project configuration to contain parameters defined in the pipeline and we can configure the image tag in _Build with Parameters_ menu.
