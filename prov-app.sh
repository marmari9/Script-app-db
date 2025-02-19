#!/bin/bash

# Update and upgrade system packages
echo "Updating and upgrading system packages..."
sudo apt-get update -y
DEBIAN_FRONTEND=noninteractive sudo apt-get upgrade -y

# Install dependencies
echo "Installing required dependencies..."
sudo apt-get install -y gnupg curl

# Install Node.js (version 20)
echo "Installing Node.js 20..."
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs

# Install PM2 to manage the Node.js application
echo "Installing PM2..."
sudo npm install -g pm2

# Clone Sparta test app from your repository
echo "Cloning the Sparta test app..."
git clone https://github.com/marmari9/tech501-sparta-app.git /home/ubuntu/sparta-app
cd /home/ubuntu/sparta-app

# Install application dependencies
echo "Installing application dependencies..."
npm install

# Set up environment variables (modify connection string as needed)
echo "Setting up environment variables..."
echo "export DB_HOST=mongodb://your-db-ip:27017/sparta" | sudo tee -a /etc/environment
source /etc/environment

# Start the application using PM2
echo "Starting the Sparta test app..."
pm2 start app.js --name sparta-app
pm2 startup systemd
pm2 save

# Configure Nginx as a reverse proxy
echo "Installing and configuring Nginx..."
sudo apt-get install -y nginx
sudo tee /etc/nginx/sites-available/sparta <<EOF
server {
    listen 80;
    server_name your-domain.com;

    location / {
        proxy_pass http://localhost:3000;
    }
}
EOF

# Enable the Nginx configuration
sudo ln -s /etc/nginx/sites-available/sparta /etc/nginx/sites-enabled/
sudo systemctl restart nginx

echo "App provisioning complete!"
