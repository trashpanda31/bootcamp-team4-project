#!/bin/bash
sudo apt update -y
sudo apt install -y docker.io docker-compose jq

sudo systemctl enable docker
sudo systemctl start docker

SECRET=$(aws secretsmanager get-secret-value --secret-id team4/wordpress/rds --query SecretString --output text)
DB_USER=$(echo $SECRET | jq -r .username)
DB_PASS=$(echo $SECRET | jq -r .password)
DB_HOST=$(echo $SECRET | jq -r .host)
DB_NAME="cloudsprint_team4"

sudo docker run -d \
  -e WORDPRESS_DB_HOST=$DB_HOST \
  -e WORDPRESS_DB_USER=$DB_USER \
  -e WORDPRESS_DB_PASSWORD=$DB_PASS \
  -e WORDPRESS_DB_NAME=$DB_NAME \
  -p 80:80 \
  wordpress:latest
