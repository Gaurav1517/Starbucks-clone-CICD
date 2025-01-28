@Library('Shared') _

pipeline {
    agent any

    tools {
        jdk 'jdk17'
        nodejs 'nodejs'
    }

    environment {
        SCANNER_HOME = tool 'sonar-scanner'
        DOCKER_USERNAME = "${DOCKER_USERNAME}"
        JOB_NAME_LOWER = env.JOB_NAME.toLowerCase()
        IMAGE_NAME = "${DOCKER_USERNAME}/${params.PROJECT_NAME.toLowerCase()}"
        IMAGE_TAG = "${IMAGE_NAME}:${BUILD_NUMBER}"
    }

    parameters {
        string(name: 'PROJECT_NAME', defaultValue: 'starbucks', description: 'Name of the project')
        string(name: 'PROJECT_KEY', defaultValue: 'starbucks', description: 'Unique key for the project')
        string(name: 'DOCKER_USERNAME', defaultValue: 'gchauhan1517', description: 'Docker Hub username')
        string(name: 'DOCKER_PASSWORD', defaultValue: 'your-dockerhub-password', description: 'Docker Hub password')
        string(name: 'DOCKER_IMAGE_NAME', defaultValue: 'your-image-name', description: 'Docker image name')
        string(name: 'DOCKER_TAG', defaultValue: 'latest', description: 'Docker image tag')
    }

    stages {
        stage("clean workspace") {
            steps {
                cleanWs()
            }
        }

        stage('Git Checkout') {
            steps {
                script {
                    git_scm('https://github.com/Gaurav1517/Starbucks-clone-CICD.git', 'main')
                }
            }
        }

        stage('SonarQube Analysis') {
            steps {
                sonarqubeAnalysis(projectName: params.PROJECT_NAME, projectKey: params.PROJECT_KEY)
            }
        }

        stage('Quality Gate') {
            steps {
                script {
                    qualityGate(abortPipeline: false, credentialsId: 'sonar-token')
                }
            }
        }

        stage('Install NPM Dependencies') {
            steps {
                installNpmDependencies()
            }
        }

        stage('OWASP FS SCAN') {
            steps {
                owaspScan()
            }
        }

        stage('Trivy File Scan') {
            steps {
                trivyScan()
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    buildDockerImage(IMAGE_TAG)
                }
            }
        }

        stage('Docker Image Tag') {
            steps {
                script {
                    sh "docker tag ${IMAGE_TAG} ${IMAGE_NAME}:v${BUILD_NUMBER}"
                    sh "docker tag ${IMAGE_TAG} ${IMAGE_NAME}:latest"
                }
            }
        }

        stage('Docker Scout Image') {
            steps {
                script {
                    try {
                        dockerScoutScan(IMAGE_NAME)
                    } catch (Exception e) {
                        error("Docker Scout scan failed: ${e.message}")
                    }
                }
            }
        }

        stage('Docker Push to Registry') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'dockerHub-cred', passwordVariable: 'docker_pass', usernameVariable: 'docker_user')]) {
                        sh "echo ${docker_pass} | docker login -u ${docker_user} --password-stdin"
                        sh "docker push ${IMAGE_NAME}:latest"
                    }
                }
            }
        }

        stage('Deploy to Container') {
            steps {
                sh "docker run -d --name ${JOB_NAME_LOWER} -p 3000:3000 ${IMAGE_NAME}:latest"
            }
        }
    }

    post {
    always {
        script {
            def jobName = env.JOB_NAME
            def buildNumber = env.BUILD_NUMBER
            def pipelineStatus = currentBuild.result ?: 'UNKNOWN'
            def bannerColor = pipelineStatus == 'SUCCESS' ? 'green' : 'red'

            def body = """<html>
                            <body>
                                <div style="border: 4px solid ${bannerColor}; padding: 10px;">
                                    <h2>${jobName} - Build ${buildNumber}</h2>
                                    <div style="background-color: ${bannerColor}; padding: 10px;">
                                        <h3 style="color: white;">Pipeline Status: ${pipelineStatus}</h3>
                                    </div>
                                    <p>Check the <a href="${env.BUILD_URL}">console output</a> for more details.</p>
                                    <p><strong>Build Summary:</strong></p>
                                    <p>${pipelineStatus == 'SUCCESS' ? 'The build completed successfully!' : 'The build failed. Please check the logs for errors.'}</p>
                                </div>
                            </body>
                          </html>"""

            echo "Sending email to: gaurav.mau854@gmail.com"
            echo "Subject: ${jobName} - Build ${buildNumber} - ${pipelineStatus}"

            emailext (
                subject: "${jobName} - Build ${buildNumber} - ${pipelineStatus}",
                body: body,
                to: 'gaurav.mau854@gmail.com',
                from: 'gauravchauhan0854@gmail.com',
                replyTo: 'gauravchauhan0854@gmail.com',
                mimeType: 'text/html',
                attachmentsPattern: 'trivy-fs-report.html'
            )
        }
     }
    }
}
