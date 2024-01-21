#!/bin/bash

# jq install for json update -> jq for json file update
sudo apt-get install jq -y in

# yq isnstall for yaml update -> yq for yaml file update
VERSION=v4.21.1
BINARY=yq_linux_amd64

wget https://github.com/mikefarah/yq/releases/download/${VERSION}/${BINARY}.tar.gz -O - |\
  tar xz && mv ${BINARY} /usr/bin/yq
sudo chmod +x /usr/bin/yq


echo "Select Cloud or Edge Application"
echo "Type [cloud/edge]"
read input

# If nothing is entered
if [ "$input" == "" ]; then
  echo "Nothing was entered by the user"

# If it is y or yes?
elif [[ "$input" == "edge" ]] || [[ "$input" == "Edge" ]] || [[ "$input" == "EDGE" ]]; then
  echo "Edge is selected"
  AppMode="edge"
  
  ## read machine ip from user
  echo Please enter your Edge Device IP :
  read ipaddress

  ## read cloud ip from user
  echo Please enter Cloud IP :
  read cloudipaddress

  ## read MTConnect machine ip from user
  echo Please enter your Source PLC/Machine IP :
  read mtconnectip

  ## read MTConnect machine name from user
  echo Please enter your Machine name :
  read machinename

  # Changing the cloud Server for edge Device Configuration
  jq --arg a "$cloudip" ' ."edge device".Services.Kafka.cloudServers |= $a' ./BE/DockerFiles/JsonConfiguration/JSONCONFIG.json > "$tmp" && mv "$tmp" ./BE/DockerFiles/JsonConfiguration/JSONCONFIG.json

# If it is y or yes?
elif [[ "$input" == "cloud" ]] || [[ "$input" == "Cloud" ]] || [[ "$input" == "CLOUD" ]]; then
  AppMode="cloud"
  echo "Cloud is selected"
  echo Please enter Cloud IP :
  read ipaddress
  # Changing the cloud Server for edge Device Configuration
  cloudipaddress="$ipaddress"  

# Wrong input
else
  echo "exit"
fi


tmp=$(mktemp)

## kafka bootstrap server ip address & opcua ipaddress & mtconnect url 
bootstrapserver="$ipaddress:9092"
opcuaserver="opc.tcp://$ipaddress:122"
mtconnectmachine="http://$mtconnectip:8082/$machinename/current"

echo "$bootstrapserver"
echo "$opcuaserver"
echo "$mtconnectmachine"


## backend configuration json file ip address update

jq --arg a "$bootstrapserver" ' ."edge device".Services.Kafka.bootstrap_servers |= $a' ./BE/DockerFiles/JsonConfiguration/JSONCONFIG.json > "$tmp" && mv "$tmp" ./BE/DockerFiles/JsonConfiguration/JSONCONFIG.json
jq --arg a "$opcuaserver" ' ."edge device".DataService.OPCUA.Properties.url |= $a' ./BE/DockerFiles/JsonConfiguration/JSONCONFIG.json > "$tmp" && mv "$tmp" ./BE/DockerFiles/JsonConfiguration/JSONCONFIG.json
jq --arg a "$mtconnectmachine" ' ."edge device".DataService.MTConnect.Properties.url |= $a' ./BE/DockerFiles/JsonConfiguration/JSONCONFIG.json > "$tmp" && mv "$tmp" ./BE/DockerFiles/JsonConfiguration/JSONCONFIG.json
jq --arg a "$cloudipaddress" ' ."edge device".Services.Kafka.cloudServers |= $a' ./BE/DockerFiles/JsonConfiguration/JSONCONFIG.json > "$tmp" && mv "$tmp" ./BE/DockerFiles/JsonConfiguration/JSONCONFIG.json

## update yaml file

## kafka broker docker compose file update
sudo KAFKA_ADVERTISED_LISTENERS="PLAINTEXT://$ipaddress:9092,PLAINTEXT_INTERNAL://broker:29092" yq -i e '.services.broker.environment.KAFKA_ADVERTISED_LISTENERS |= env(KAFKA_ADVERTISED_LISTENERS)' ./Kafka-Broker/docker-compose.yml

## UI docker compose file update
sudo REACT_APP_SOCKET_URL="ws://$ipaddress:8000/ws/app/notifications/" yq -i e '.services.client.environment.REACT_APP_SOCKET_URL |= env(REACT_APP_SOCKET_URL)' ./UI/docker-compose.yml
sudo REACT_APP_SOCKET_WEB_DASHBOARD_URL="ws://$ipaddress:8000/ws/app/webdashboard/" yq -i e '.services.client.environment.REACT_APP_SOCKET_WEB_DASHBOARD_URL |= env(REACT_APP_SOCKET_WEB_DASHBOARD_URL)' ./UI/docker-compose.yml
sudo REACT_APP_SOCKET_WEB_DEVICE_URL="ws://$ipaddress:8000/ws/app/" yq -i e '.services.client.environment.REACT_APP_SOCKET_WEB_DEVICE_URL |= env(REACT_APP_SOCKET_WEB_DEVICE_URL)' ./UI/docker-compose.yml
sudo REACT_APP_API_URL="http://$ipaddress:8000/" yq -i e '.services.client.environment.REACT_APP_API_URL |= env(REACT_APP_API_URL)' ./UI/docker-compose.yml
sudo REACT_APP_siteMode="$AppMode" yq -i e '.services.client.environment.REACT_APP_siteMode |= env(REACT_APP_siteMode)' ./UI/docker-compose.yml

## BE docker compose file update
sudo ApplicationMode="$AppMode" yq -i e '.services.backend.environment.ApplicationMode |= env(ApplicationMode)' ./BE/docker-compose.yml


echo "Update Successful"
exit