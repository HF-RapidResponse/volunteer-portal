#!/bin/bash

# This script is to be used to set up container with python installed.

curl -sL https://deb.nodesource.com/setup_14.x | bash -
apt-get install -y nodejs

apt install -y nginx
