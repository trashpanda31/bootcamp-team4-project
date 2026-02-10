#!/bin/bash
sudo apt update -y
sudo apt upgrade -y

sudo apt-get install -y openjdk-17-jre ca-certificates curl gnupg wget

java -version

sudo mkdir -p /etc/apt/keyrings
sudo wget -q -O /etc/apt/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key

echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

sudo apt update -y
sudo apt-get install -y jenkins

echo 'JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64' | sudo tee -a /etc/default/jenkins > /dev/null

sudo systemctl enable --now jenkins
sudo systemctl status jenkins --no-pager || true
