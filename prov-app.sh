#!/bin/bash
set -e  # Stop script on error
export DEBIAN_FRONTEND=noninteractive  # Prevent user input prompts

# Update system
sudo apt-get update -y
sudo apt-get upgrade -y

# Install dependencies
sudo apt-get install -y gnupg curl git nginx

# Install Node.js (version 20)
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs

# Install PM2 to keep app running
sudo npm install -g pm2

# Clone Sparta app from GitHub
cd /home/ubuntu
git clone https://github.com/marmari9/tech501-sparta-app.git sparta-app
cd sparta-app

# Install dependencies
npm install

# Set MongoDB connection string (DB_HOST)- change private ip address
echo 'export DB_HOST="mongodb://172.31.62.252:27017/sparta"' | sudo tee -a /etc/environment
source /etc/environment

# Start the app using PM2
pm2 start app.js --name sparta-app
pm2 save
pm2 startup systemd

# Configure Nginx Reverse Proxy
sudo tee /etc/nginx/sites-available/default <<EOF
server {
    listen 80;
    location / {
        proxy_pass http://localhost:3000;
        
    }
}
EOF

# Restart Nginx
sudo nginx -t
sudo systemctl restart nginx
sudo systemctl enable nginx
