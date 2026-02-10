#!/bin/bash

apt-get update -y
apt-get upgrade -y

apt-get install -y \
  openjdk-17-jre \
  ca-certificates \
  curl \
  gnupg \
  wget \
  git \
  unzip

java -version

sudo apt install -y  docker.io
sudo apt install -y docker-compose

sudo systemctl enable docker

apt-get install -y ansible

useradd -m -s /bin/bash jenkins || true
usermod -aG docker jenkins || true

mkdir -p /home/jenkins
chown -R jenkins:jenkins /home/jenkins
