#!/bin/bash
sudo apt-get remove docker docker-engine docker.io containerd runc -y

sudo apt-get update -y

sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release 

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null 

sudo apt-get update -y
sudo apt-get install docker-ce docker-ce-cli containerd.io -y

# Linux post-install
sudo groupadd docker
sudo usermod -aG docker $USER
sudo systemctl enable docker

# docker-compose install
sudo curl -L --fail https://github.com/docker/compose/releases/download/1.29.2/run.sh -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

