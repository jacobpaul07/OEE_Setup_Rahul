#!/bin/bash 

docker-compose -f /home/ubuntu/desktop/oee/UI/docker-compose.yml down --rmi all 
docker-compose -f /home/ubuntu/desktop/oee/UI/docker-compose.yml  up -d --force-recreate
