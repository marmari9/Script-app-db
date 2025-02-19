#!/bin/bash
set -e  # Stop script on error
export DEBIAN_FRONTEND=noninteractive  # Prevent user prompts

# Update system
sudo apt-get update -y
sudo apt-get install -y gnupg curl

# Import MongoDB GPG Key (force overwrite)
curl -fsSL https://www.mongodb.org/static/pgp/server-7.0.asc | \
   sudo gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg --dearmor --yes

# Add MongoDB repository
echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | \
   sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list

# Update package lists
sudo apt-get update -y

# Install MongoDB 7.0.6 (WITHOUT `mongosh`)
sudo apt-get install -y mongodb-org=7.0.6 mongodb-org-database=7.0.6 mongodb-org-server=7.0.6 mongodb-org-mongos=7.0.6 mongodb-org-tools=7.0.6 --no-install-recommends

# Prevent MongoDB from auto-upgrading
sudo apt-mark hold mongodb-org mongodb-org-database mongodb-org-server mongodb-org-mongos mongodb-org-tools

# Start MongoDB
sudo systemctl enable --now mongod
sudo systemctl restart mongod
