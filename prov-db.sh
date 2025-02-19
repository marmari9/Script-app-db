#!/bin/bash

set -e  # Stop script on first error

# Prevent user input prompts
export DEBIAN_FRONTEND=noninteractive

# Update and upgrade system packages
echo "Updating and upgrading system packages..."
sudo apt-get update -y
sudo apt-get upgrade -yq

# Install dependencies
echo "Installing required dependencies..."
sudo apt-get install -yq gnupg curl

# Add MongoDB GPG key
echo "Adding MongoDB GPG key..."
curl -fsSL https://www.mongodb.org/static/pgp/server-7.0.asc | \
    sudo gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg --dearmor

# Add MongoDB repository
echo "Adding MongoDB repository..."
echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | \
    sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list

# Update package lists
echo "Updating package lists..."
sudo apt-get update -y

# Install MongoDB (version 7.0.6)
echo "Installing MongoDB 7.0.6..."
sudo apt-get install -yq mongodb-org=7.0.6 mongodb-org-database=7.0.6 mongodb-org-server=7.0.6 mongodb-mongosh mongodb-org-mongos=7.0.6 mongodb-org-tools=7.0.6

# Start and enable MongoDB
echo "Starting and enabling MongoDB..."
sudo systemctl enable --now mongod
sudo systemctl restart mongod

# Verify MongoDB is running
if systemctl is-active --quiet mongod; then
    echo "MongoDB is running successfully!"
else
    echo "MongoDB failed to start!" >&2
    exit 1
fi

echo "MongoDB provisioning complete!"
