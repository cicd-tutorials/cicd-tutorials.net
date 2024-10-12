String d = "docs/examples/jenkins/build-status-pipelines"

folder('Status') {
    description('Example pipelines to produce success, unstable, failed, aborted, and not-built statuses.')
}

def statuses = ['Success', 'Unstable', 'Failed', 'Aborted']
for (status in statuses) {
    def name = "Status/${status}"

    pipelineJob(name) {
        definition {
            cps {
                script(readFileFromWorkspace("$d/${status.toLowerCase()}.Jenkinsfile"))
                sandbox()
            }
        }
    }
    queue(name)
}

pipelineJob('Status/Not built') {
    definition {
        cps {
            script(readFileFromWorkspace("$d/success.Jenkinsfile"))
            sandbox()
        }
    }
}
