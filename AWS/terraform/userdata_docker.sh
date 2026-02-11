#!/bin/bash
sudo apt update -y
sudo apt install -y  docker.io 
sudo apt install -y docker-compose

sudo systemctl enable docker

docker --version
docker compose version
