#!/bin/bash

# Update package lists.
apt-get update

# Install Docker.
apt-get install -y docker.io

# Enable and start Docker.
systemctl enable --now docker