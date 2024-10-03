#!/bin/bash

# Install NPM
sudo apt-get update
sudo apt-get install -y npm
sudo apt-get install -y postgresql-client

# Get pull api backend app.
curl https://534098467822-sample-app.s3.us-west-1.amazonaws.com/api.tar --output api.tar

tar xzf api.tar api

# cd api && npm install && npm start &

