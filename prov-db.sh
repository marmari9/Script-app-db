#!/bin/bash
set -e  # Stop script on error
export DEBIAN_FRONTEND=noninteractive  # Prevent user input prompts

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

# Install MongoDB 7.0.6 (without mongosh)
sudo apt-get install -y --allow-downgrades mongodb-org=7.0.6 mongodb-org-database=7.0.6 mongodb-org-server=7.0.6 mongodb-org-mongos=7.0.6 mongodb-org-tools=7.0.6 --no-install-recommends

# Prevent MongoDB from auto-upgrading
sudo apt-mark hold mongodb-org mongodb-org-database mongodb-org-server mongodb-org-mongos mongodb-org-tools

# Configure MongoDB to accept external connections (bindIP 0.0.0.0)
sudo sed -i 's/bindIp: 127.0.0.1/bindIp: 0.0.0.0/g' /etc/mongod.conf

# Reload systemd to recognize the MongoDB service
sudo systemctl daemon-reload

# Start MongoDB service
sudo systemctl enable mongod
sudo systemctl start mongod
sudo systemctl restart mongod

# Verify MongoDB is running
if systemctl is-active --quiet mongod; then
    echo "✅ MongoDB is running successfully!"
else
    echo "❌ MongoDB failed to start!" >&2
    journalctl -u mongod --no-pager | tail -n 20  # Show last 20 logs
    exit 1
fi
