#!/bin/bash
set -euxo pipefail

exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

if command -v apt-get >/dev/null 2>&1; then
  apt-get update -y
  apt-get install -y fontconfig openjdk-17-jre curl gnupg

  curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
  echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list

  apt-get update -y
  apt-get install -y jenkins

  systemctl enable --now jenkins

elif command -v dnf >/dev/null 2>&1; then
  dnf update -y
  dnf install -y java-17-amazon-corretto wget

  wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
  rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

  dnf install -y jenkins
  systemctl enable --now jenkins

elif command -v yum >/dev/null 2>&1; then
  yum update -y
  yum install -y java-17-amazon-corretto wget

  wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
  rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

  yum install -y jenkins
  systemctl enable --now jenkins

else
  exit 1
fi

systemctl --no-pager status jenkins || true
cat /var/lib/jenkins/secrets/initialAdminPassword || true
