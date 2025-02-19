# Update and upgrade
sudo apt-get update -y 
DEBIAN_FRONTEND=noninteractive sudo apt-get upgrade -y

# Install gnupg and curl:
sudo apt-get install gnupg curl

#Download gpg key:
curl -fsSL https://www.mongodb.org/static/pgp/server-7.0.asc | \
   sudo gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg \
   --dearmor

#Create file list:
echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list

#Update:
sudo apt-get update

#Install a specific release: 7.0.6
sudo apt-get install -y mongodb-org=7.0.6 mongodb-org-database=7.0.6 mongodb-org-server=7.0.6 mongodb-mongosh mongodb-org-mongos=7.0.6 mongodb-org-tools=7.0.6

#Start mongodb:
sudo systemctl start mongod

#Enable mongodb
sudo systemctl enabled mongod

# Restart mongodb service
sudo systemctl restart mongod