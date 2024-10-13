# CI/CD Pipeline and Tooling Examples

This website contains examples on how to develop CI/CD pipelines and how to configure a development environment for working with CI/CD pipelines.

## What are CI/CD pipelines?

CI/CD refers to the combination of Continuous Integration (CI) and Continuous Delivery (CD) practices. Both of these practices aim to increase the frequency at which changes are released. The increase in release frequency is often enabled by automation pipelines.

### Continuous Integration

In Continuous Integration, code changes are merged from development or feature branches to the main branch as often as possible. This provides more frequent feedback to the developers and should lead into smaller individual changes that are easier to integrate into the main branch.

Continuous Integration is often supported by CI pipeline that automatically validates the changes to be merged into the main branch. These automatic validation can include, for example, static code analysis and automated tests. The CI pipelines are usually automatically triggered by an event in a version control system. For example, a CI pipeline could be automatically triggered when a pull request is created or updated.

In addition to automated validations done by the CI pipeline, continuous integration processes may include manual validations. For example, code review done by another developer might be required in order to be able to merge the change.

### Continuous Delivery

In Continuous Delivery, code changes are continuously built and delivered to a release target. For example, a web application could be updated after each new change on the main branch. Similarly than with Continuous Integration, the goal is to get more frequent feedback on code changes. Delivering changes more frequently should lead into a better delivery routine and more well defined delivery process.

Continuous Delivery is often implemented with a CD pipeline. The CD pipeline could, for example, build the main branch after a code change was merged in and deploy the build result into a test or staging environment. The CD pipeline might also have steps that wait for human approval before they are executed. For example, deployment to a production environment might require human approval.

The CI and CD pipelines are often tightly integrated with each other. Delivery is usually done after validating the code change and more complex validation might require the code change to be delivered into a test environment.

## Installing Docker

Many of the examples provided on this website require Docker and Docker Compose to be installed on your development environment.

See [Get Docker](https://docs.docker.com/get-docker/) for official installation instructions. If you use Docker a lot on a Mac or Windows system, the recommended Docker Desktop is likely a good option for you. Note that, since January 2022, it has required paid subscription, if used for commercial development.

Alternatively, Windows users can [install Docker on top of WSL2](./docker/docker-on-wsl/). For Mac users there are alternatives, such as [Colima](https://github.com/abiosoft/colima), available.
