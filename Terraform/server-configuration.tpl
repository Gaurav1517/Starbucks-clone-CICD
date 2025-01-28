#!/bin/bash

# Update and install prerequisites
sudo yum update -y
sudo yum install -y curl tar gzip wget

# JDK 17 installation
echo "Installing Amazon Corretto JDK 17..."

# Import the Corretto GPG key
sudo rpm --import https://yum.corretto.aws/corretto.key

# Add the Corretto repository
sudo curl -L -o /etc/yum.repos.d/corretto.repo https://yum.corretto.aws/corretto.repo

# Install Java 17
sudo yum install -y java-17-amazon-corretto

# Setting up JDK environment variables
echo "Configuring Java environment variables..."
echo "export JAVA_HOME=/usr/lib/jvm/java-17-amazon-corretto" | sudo tee -a /etc/profile
echo "export PATH=\$PATH:\$JAVA_HOME/bin" | sudo tee -a /etc/profile

# Source the profile to ensure environment variables are loaded
source /etc/profile

# Verify Java installation
if command -v java &>/dev/null; then
    java -version
else
    echo "Java installation failed. Exiting."
    exit 1
fi

#Git Installation
sudo yum install -y git* 

# If get error to install git . 
sudo yum install git* -y --skip-broken

# Verity version 
git --version 

# Jenkins Installation
echo "Installing Jenkins..."
sudo wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo yum upgrade -y
sudo yum install jenkins -y
sudo systemctl daemon-reload
sudo systemctl enable jenkins
sudo systemctl start jenkins
sudo systemctl status jenkins

# Install Docker
echo "Installing Docker..."
sudo yum update -y
sudo amazon-linux-extras install docker
sudo yum install docker -y
sudo systemctl start docker
sudo systemctl enable docker
# Docker Compose Plugin
echo "Installing Docker Compose..."
# Ref: https://github.com/docker/compose/releases
wget https://github.com/docker/compose/releases/download/v2.32.4/docker-compose-linux-x86_64
 mv docker-compose-linux-x86_64 docker-compose
 chmod +x docker-compose
 mv docker-compose  /usr/bin/
 # Verify installation docker-compose
 docker-compose version

# Add Jenkins user to Docker group to avoid permission error
sudo usermod -aG docker jenkins
# To avoid permission denied while connecting to Docker socket
sudo chmod 666 /var/run/docker.sock


########## INSTALL DOCKER-SCOUT FOR DOCKER IMAGE SCANNING IN JENKINS
# Ref: https://docs.docker.com/scout/install/
# Note: docker should be installed in the system and login to docker hub
# docker login -u <username> -p <password>
# verify docker login by docker info | grep Username
sudo yum install -y curl
curl -sSfL https://raw.githubusercontent.com/docker/scout-cli/main/install.sh -o install-scout.sh
sudo sh install-scout.sh -b /usr/local/bin
docker scout --version
export PATH=$PATH:/usr/local/bin
source ~/.bashrc
sudo ln -s /usr/local/bin/docker-scout /usr/bin/docker-scout
ls -l /usr/bin/docker-scout
docker-scout version
sudo mkdir -p /tmp/docker-scout/sha256
sudo chown -R jenkins:jenkins  /tmp/docker-scout/
sudo systemctl restart docker.service
sudo systemctl restart jenkins.service 
sudo systemctl status docker.service jenkins.service

# Install Trivy
echo "Installing Trivy..."
# Add Trivy repository
cat << EOF | sudo tee /etc/yum.repos.d/trivy.repo
[trivy]
name=Trivy repository
baseurl=https://aquasecurity.github.io/trivy-repo/rpm/releases/\$basearch/
gpgcheck=1
enabled=1
gpgkey=https://aquasecurity.github.io/trivy-repo/rpm/public.key
EOF

# Update the package list and install Trivy
sudo yum -y update
sudo yum -y install trivy
echo "Verify trivy installation."
trivy --version

# Access Jenkins
IP_ADDRESS=$(hostname -I | awk '{print $1}')
echo "Access Jenkins at: http://$IP_ADDRESS:8080"
 

echo "Installation completed successfully."