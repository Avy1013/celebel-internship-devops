# Create a custom bridge network
docker network create --driver bridge my_custom_network

# Run containers on the custom network
docker run -d --name web1 --network my_custom_network nginx
docker run -d --name web2 --network my_custom_network nginx

# Inspect the custom network
docker network inspect my_custom_network
