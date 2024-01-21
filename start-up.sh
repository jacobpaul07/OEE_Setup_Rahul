#!/bin/bash
# install docker
sudo chmod 777 docker-install.sh
sudo ./docker-install.sh
sudo groupadd docker \
sudo usermod -aG docker $USER \
sudo newgrp docker \
# Deploy the docker images
echo "docker compose begins" \
sudo docker-compose -f ./Kafka-Broker/docker-compose.yml up -d --force-recreate
sudo docker-compose -f ./Kafka-Broker/docker-compose.yml up -d --force-recreate
sudo docker-compose -f ./UI/docker-compose.yml up -d --force-recreate
sudo docker-compose -f ./OPC-Server/docker-compose.yml up -d --force-recreate
sudo docker-compose -f ./BE/docker-compose.yml up -d --force-recreate
echo "docker compose success"
