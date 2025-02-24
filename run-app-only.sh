#!/bin/bash
export DB_HOST="mongodb://172.31.63.6:27017/sparta"  # Updated DB Private IP

cd /home/ubuntu/sparta-app
npm install 
pm2 start app.js --name sparta-app
pm2 save
