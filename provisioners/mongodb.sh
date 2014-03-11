#!/usr/bin/env bash

MONGO_VER=2.4.9

# Install MongoDB
if ! type "mongo" > /dev/null; then
  if type "yum" > /dev/null; then
    sudo cp /resources/mongodb.repo /etc/yum.repos.d/mongodb.repo
    sudo yum -y install mongo-10gen-${MONGO_VER} mongo-10gen-server-${MONGO_VER}
  else
    sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
    echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | sudo tee /etc/apt/sources.list.d/mongodb.list
    sudo apt-get -y -q update
    sudo apt-get -y -q install mongodb-10gen=${MONGO_VER}
  fi
fi

# Copy DB configuration
sudo cp /resources/mongodb/mongod.conf /etc/mongod.conf

# Check config
if type "chkconfig" > /dev/null; then
  sudo chkconfig mongod on
fi

# Attempt to start MongoDB
if type "mongo" > /dev/null; then
  if [ -a "/etc/init.d/mongodb" ]; then
    sudo service mongodb start
  else
    sudo service mongod start
  fi
else
  echo "[ ERROR ] Unable to install MongoDB."
fi
