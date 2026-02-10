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
sudo apt install -y  docker.io
sudo apt install -y docker-compose

echo 'JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64' | sudo tee -a /etc/default/jenkins > /dev/null

sudo python3 -m venv /opt/ansible-venv
sudo /opt/ansible-venv/bin/pip install --upgrade pip
sudo /opt/ansible-venv/bin/pip install ansible
/opt/ansible-venv/bin/ansible --version

sudo chmod -R a+rX /opt/ansible-venv

sudo systemctl enable --now jenkins
sudo systemctl status jenkins --no-pager || true
sudo systemctl enable --now  docker
