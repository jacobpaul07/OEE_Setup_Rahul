#!/bin/bash 

docker-compose -f /home/ubuntu/desktop/oee/BE/docker-compose.yml down --rmi all 
docker-compose -f /home/ubuntu/desktop/oee/BE/docker-compose.yml  up -d --force-recreate
