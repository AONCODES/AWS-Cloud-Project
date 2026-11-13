#!/bin/bash

# Update package lists.
apt-get update

# Install Docker and Docker Compose.
apt-get install -y docker.io docker-compose-v2

# Enable and start Docker.
systemctl enable --now docker

# Create the CTFd application directory.
mkdir -p /opt/ctfd

# Write the Docker Compose configuration.
cat > /opt/ctfd/docker-compose.yml <<'COMPOSE'
${docker_compose}
COMPOSE