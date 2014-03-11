#!/usr/bin/env bash

if ! type "foreman" > /dev/null; then
  sudo gem install foreman
fi

if ! type "node" > /dev/null; then
VERSION=0.10.24

mkdir -p /tmp/node-build
cd /tmp/node-build

wget http://nodejs.org/dist/v${VERSION}/node-v${VERSION}.tar.gz
tar -xvf node-v${VERSION}.tar.gz
cd node-v${VERSION}

./configure
make
sudo make install
sudo ln -s /usr/local/bin/node /usr/bin/node

cd /tmp
rm -rf /tmp/node-build

sudo adduser --system --no-create-home --disabled-login --disabled-password --group node
fi


if ! type "nodemon" > /dev/null; then
  sudo npm install nodemon -g
fi
