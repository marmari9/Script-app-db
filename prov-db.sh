#!/bin/bash

# Update and upgrade system packages
echo "Updating and upgrading system packages..."
sudo apt-get update -y
DEBIAN_FRONTEND=noninteractive sudo apt-get upgrade -y

# Install dependencies
echo "Installing required dependencies..."
sudo apt-get install -y gnupg curl

# Add MongoDB GPG key
echo "Adding MongoDB GPG key..."
curl -fsSL https://www.mongodb.org/static/pgp/server-7.0.asc | \
   sudo gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg --dearmor

# Add MongoDB repository
echo "Adding MongoDB repository..."
echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list

# Update package lists
echo "Updating package lists..."
sudo apt-get update

# Install MongoDB (version 7.0.6)
echo "Installing MongoDB 7.0.6..."
sudo apt-get install -y mongodb-org=7.0.6 mongodb-org-database=7.0.6 mongodb-org-server=7.0.6 mongodb-mongosh mongodb-org-mongos=7.0.6 mongodb-org-tools=7.0.6

# Start and enable MongoDB
echo "Starting and enabling MongoDB..."
sudo systemctl start mongod
sudo systemctl enable mongod
sudo systemctl restart mongod

echo "MongoDB provisioning complete!"
