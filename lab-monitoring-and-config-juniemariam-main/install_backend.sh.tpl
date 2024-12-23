#!/bin/bash

# Install NPM
sudo apt-get update
sudo apt-get install -y npm
sudo apt-get install -y postgresql-client


psql postgres://replica_postgresql:UberSecretPassword@${DB_ENDPOINT}/replicaPostgresql -c "CREATE DATABASE user_database;"
psql postgres://replica_postgresql:UberSecretPassword@${DB_ENDPOINT}/user_database -c "CREATE TABLE users (id SERIAL PRIMARY KEY, name VARCHAR(100), email VARCHAR(100) UNIQUE);"
psql postgres://replica_postgresql:UberSecretPassword@${DB_ENDPOINT}/user_database -c "INSERT INTO users (name, email) VALUES ('Test Person', 'Test@email.com');"




# Get pull api backend app.
cd ~ && curl https://534098467822-sample-app.s3.us-west-1.amazonaws.com/api.tar --output api.tar

tar xzf api.tar api

sudo cat <<EOL > ~/api/.env
DATABASE_URL=postgres://replica_postgresql:UberSecretPassword@${DB_ENDPOINT}/user_database
HOST=http://localhost
PORT=8080
EOL

sudo npm install pm2 -g 
cd api && npm install && pm2 start npm -- start

