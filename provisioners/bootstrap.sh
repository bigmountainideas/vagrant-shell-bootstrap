#!/usr/bin/env bash

sudo apt-get update

# Install Make and other build tools
if ! type "make" > /dev/null; then
  sudo apt-get -q -y install build-essential checkinstall
fi

# Install CURL
if ! type "curl" > /dev/null; then
  sudo apt-get -q -y install curl
fi
