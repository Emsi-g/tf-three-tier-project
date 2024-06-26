#!/bin/bash
sleep 20s

# Update OS
sudo apt-get update

# Install apache2
apt install apache2 -y

# Install mysql client
apt install mysql-client -y
