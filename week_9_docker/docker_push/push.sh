# 1. Log in to Docker Hub
docker login

# 2. Tag the image
docker tag my_custom_nginx:latest yourusername/my_custom_nginx:latest

# 3. Push the image
docker push yourusername/my_custom_nginx:latest
