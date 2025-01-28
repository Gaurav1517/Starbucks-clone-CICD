# Deploy Starbucks Clone Application AWS using DevSecOps Approach

![recording](snap/Recording 2025-01-28 174914.mp4)

![Starbucks Clone Deployment](https://github.com/user-attachments/assets/6b654f47-9537-4b88-9584-41c760fc49ac)

## Tools Used

<a href="https://code.visualstudio.com/">
  <img src="https://www.svgrepo.com/show/452129/vs-code.svg" alt="Visual Studio Code" width="80">
</a>
<a href="https://git-scm.com/">
  <img src="https://www.svgrepo.com/show/452210/git.svg" alt="Git" width="80">
</a>
<a href="https://github.com">
  <img src="https://www.svgrepo.com/show/475654/github-color.svg" alt="GitHub" width="80">
</a>
<a href="https://www.kernel.org">
  <img src="https://www.svgrepo.com/show/354004/linux-tux.svg" alt="Linux" width="80">
</a> 
<a href="https://www.docker.com">
  <img src="https://www.svgrepo.com/show/303231/docker-logo.svg" alt="Docker" width="80">
</a>
<a href="https://docker.p2hp.com/wp-content/uploads/2023/10/home-hero-scout.png">
  <img src="https://docker.p2hp.com/wp-content/uploads/2023/10/home-hero-scout.png" alt="Docker Scout" width="80">
</a> 
<a href="https://nodejs.org/">
  <img src="https://www.svgrepo.com/show/303360/nodejs-logo.svg" alt="Node.js" width="80">
</a>
<a href="https://reactjs.org/">
  <img src="https://www.svgrepo.com/show/452092/react.svg" alt="React" width="80">
</a>
<a href="https://www.npmjs.com/">
  <img src="https://www.svgrepo.com/show/452077/npm.svg" alt="npm" width="80">
</a>
<a href="https://logospng.org/wp-content/uploads/java-768x432.png">
  <img src="https://logospng.org/wp-content/uploads/java-768x432.png" alt="Java" width="80">
</a>
<a href="https://www.jenkins.io">
  <img src="https://get.jenkins.io/art/jenkins-logo/logo.svg" alt="Jenkins" width="80">
</a>
<a href="https://github.com/tonistiigi/trivy">
  <img src="https://trivy.dev/v0.46/imgs/logo.png" alt="Trivy" width="80">
</a>
<a href="https://www.svgrepo.com/show/354365/sonarqube.svg">
  <img src="https://www.svgrepo.com/show/354365/sonarqube.svg" alt="SonarQube" width="80">
</a>
<a href="https://roost.ai/hubfs/logos/integrations/logo-dockerhub.png">
  <img src="https://roost.ai/hubfs/logos/integrations/logo-dockerhub.png" alt="DockerHub" width="80">
</a>
<a href="https://nginx.org/">
  <img src="https://www.svgrepo.com/show/354115/nginx.svg" alt="Trivy" width="80">
</a>
<a href="https://www.terraform.io">
  <img src="https://www.svgrepo.com/show/448253/terraform.svg" alt="Terraform" width="80">
</a>
<a href="https://cdn.freelogovectors.net/wp-content/uploads/2021/07/owasp_logo-freelogovectors.net_.png">
  <img src="https://cdn.freelogovectors.net/wp-content/uploads/2021/07/owasp_logo-freelogovectors.net_.png" alt="OWASP" width="80">
</a>
<a href="https://www.svgrepo.com/show/349378/gmail.svg">
  <img src="https://www.svgrepo.com/show/349378/gmail.svg" alt="Gmail" width="80">
</a>
<a href="https://aws.amazon.com">
  <img src="https://www.svgrepo.com/show/376356/aws.svg" alt="AWS" width="80">
</a>
<a href="https://icon.icepanel.io/AWS/svg/Security-Identity-Compliance/IAM-Identity-Center.svg">
  <img src="https://icon.icepanel.io/AWS/svg/Security-Identity-Compliance/IAM-Identity-Center.svg" alt="IAM Identity Center" width="80">
</a>
<a href="https://icon.icepanel.io/AWS/svg/Compute/EC2.svg">
  <img src="https://icon.icepanel.io/AWS/svg/Compute/EC2.svg" alt="EC2" width="80">
</a>


## Overview
This project demonstrates deploying a Starbucks clone application on an AWS EC2 instance using Terraform. The deployment includes setting up essential services such as Jenkins, SonarQube, Docker, and more for continuous integration and deployment.

---

##  Create EC2 Instance  with Terraform , 
**-ref: Terraform/**

- **AMI**: Amazon Linux
- **Instance Type**: t2.xlarge
- **Key Pair**: `starbucks-key`
- **Security Group Rules**:
  - Port 22: SSH
  - Port 8080: Jenkins
  - Port 9000: SonarQube
- **Storage**: 30GB gp3

### User Data Script
```bash
#!/bin/bash
# Update and install prerequisites
sudo yum update -y
sudo yum install -y curl tar gzip wget

# JDK 17 installation
echo "Installing Amazon Corretto JDK 17..."
sudo rpm --import https://yum.corretto.aws/corretto.key
sudo curl -L -o /etc/yum.repos.d/corretto.repo https://yum.corretto.aws/corretto.repo
sudo yum install -y java-17-amazon-corretto
echo "export JAVA_HOME=/usr/lib/jvm/java-17-amazon-corretto" | sudo tee -a /etc/profile
echo "export PATH=\$PATH:\$JAVA_HOME/bin" | sudo tee -a /etc/profile
source /etc/profile

# Verify Java installation
java -version

# Git installation
sudo yum install -y git* --skip-broken
git --version

# Jenkins installation
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo yum upgrade -y
sudo yum install -y jenkins
sudo systemctl daemon-reload
sudo systemctl enable jenkins
sudo systemctl start jenkins

# Docker installation
sudo amazon-linux-extras install docker
sudo yum install -y docker
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker jenkins
sudo chmod 666 /var/run/docker.sock

# Docker Compose installation
wget https://github.com/docker/compose/releases/download/v2.32.4/docker-compose-linux-x86_64
sudo mv docker-compose-linux-x86_64 /usr/bin/docker-compose
sudo chmod +x /usr/bin/docker-compose
docker-compose version

# Docker Scout installation
curl -sSfL https://raw.githubusercontent.com/docker/scout-cli/main/install.sh -o install-scout.sh
sudo sh install-scout.sh -b /usr/local/bin
docker-scout version
sudo mkdir -p /tmp/docker-scout/sha256
sudo chown -R jenkins:jenkins /tmp/docker-scout/

# Install Trivy for security scanning
cat << EOF | sudo tee /etc/yum.repos.d/trivy.repo
[trivy]
name=Trivy repository
baseurl=https://aquasecurity.github.io/trivy-repo/rpm/releases/\$basearch/
gpgcheck=1
enabled=1
gpgkey=https://aquasecurity.github.io/trivy-repo/rpm/public.key
EOF
sudo yum -y update
sudo yum -y install trivy
trivy --version

# Display Jenkins access information
IP_ADDRESS=$(hostname -I | awk '{print $1}')
echo "Access Jenkins at: http://$IP_ADDRESS:8080"
```

---

## Accessing the EC2 Instance
1. Change permissions for the key pair:
   ```bash
   chmod 400 "starbucks-key.pem"
   ```
2. SSH into the instance:
   ```bash
   ssh -i "starbucks-key.pem" ec2-user@<public-ip>
   ```

---

## Installing SonarQube on Docker
1. Pull and run the SonarQube Docker container:
   ```bash
   docker run -d --name sonarqube -p 9000:9000 sonarqube:lts-community
   ```
2. Verify the container:
   ```bash
   docker ps
   ```
3. Access SonarQube in your browser:
   ```
   http://<ec2-ip>:9000
   ```
4. Default credentials:
   - Username: `admin`
   - Password: `admin`
   - Update the password upon first login.

---

## Jenkins Setup
1. Access Jenkins:
   ```
   http://<ec2-ip>:8080
   ```
2. Unlock Jenkins with the initial password:
   ```bash
   sudo cat /var/lib/jenkins/secrets/initialAdminPassword
   ```
3. Install recommended plugins:
   - Eclipse Tamarin Installer
   - SonarQube Scanner
   - NodeJS
   - Docker Commons
   - OWASP Dependency-Check
   - Email Extension Template
   - Blue Ocean

4. Configure SonarQube integration:
   - Generate a token in SonarQube (`Administrator > Security > Tokens`).
   - Add credentials in Jenkins (`Manage Jenkins > Credentials`).

5. Configure Docker Hub integration:
   - Create a token in Docker Hub (`My Account > Security > New Access Token`).
   - Add credentials in Jenkins (`Manage Jenkins > Credentials`).

---

## Email Notification Setup
- **SMTP Server**: smtp.gmail.com
- **SMTP Port**: 465
- **Authentication**: Use your Gmail credentials with an app-specific password or OAuth2.

---

## Jenkinsfile
```groovy
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

            echo "Sending email to: <email-ID.@gmail.com>"
            echo "Subject: ${jobName} - Build ${buildNumber} - ${pipelineStatus}"

            emailext (
                subject: "${jobName} - Build ${buildNumber} - ${pipelineStatus}",
                body: body,
                to: '<email-ID.@gmail.com>',
                from: '<email-ID.@gmail.com>',
                replyTo: '<email-ID.@gmail.com>',
                mimeType: 'text/html',
                attachmentsPattern: 'trivy-fs-report.html'
            )
        }
     }
    }
}
```
Ouputs: 
jenkins pipeline output
![]()

