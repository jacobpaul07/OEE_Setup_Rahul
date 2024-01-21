echo "Restart Begins"
echo "docker compose begins" \
sudo docker-compose -f ./Kafka-Broker/docker-compose.yml up -d --force-recreate
sudo docker-compose -f ./Kafka-Broker/docker-compose.yml up -d --force-recreate
sudo docker-compose -f ./UI/docker-compose.yml up -d --force-recreate
sudo docker-compose -f ./OPC-Server/docker-compose.yml up -d --force-recreate
sudo docker-compose -f ./BE/docker-compose.yml up -d --force-recreate
echo "docker compose success"