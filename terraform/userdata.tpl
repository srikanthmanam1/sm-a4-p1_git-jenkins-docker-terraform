#!/bin/bash

# Install Docker
#amazon-linux-extras install docker -y
sudo su -
sudo apt install docker.io -y
systemctl start docker
systemctl enable --now docker
docker --version
## ECR login
#aws ecr get-login-password --region ${region} | \
#docker login --username AWS --password-stdin ${account_id}.dkr.ecr.${region}.amazonaws.com

# Pull latest image
#docker pull ${account_id}.dkr.ecr.${region}.amazonaws.com/${repo_name}:latest

# Stop existing container if any
#docker rm -f app || true

# Run the container
#docker run -d \
#  --name app \
#  -p ${app_port}:${app_port} \
#  ${account_id}.dkr.ecr.${region}.amazonaws.com/${repo_name}:latest


#User Data Script Template
