#!/bin/bash

# Update package lists
echo "Updating package lists..."
sudo apt update -y
sudo apt install npm -y

# Install Nginx if it's not already installed
if ! command -v nginx &> /dev/null; then
    echo "Installing Nginx..."
    sudo apt install nginx -y
else
    echo "Nginx is already installed."
fi

# Define Nginx configuration
NGINX_CONFIG="/etc/nginx/sites-available/default"


# Create the Nginx configuration
echo "Configuring Nginx..."
sudo cat <<'EOL' > $NGINX_CONFIG
server {
    listen 80;
    server_name your_public_domain_or_ip;

    root /var/www/html;
    index index.html;

    location / {
        try_files $uri $uri/ =404;
    }

    location /api/ {
        proxy_pass http://172.16.101.10:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        add_header 'Access-Control-Allow-Origin' '*';
        add_header 'Access-Control-Allow-Methods' 'GET, POST, OPTIONS';
        add_header 'Access-Control-Allow-Headers' 'Origin, X-Requested-With, Content-Type, Accept, Authorization';
    }
}
EOL

# Test Nginx configuration
echo "Testing Nginx configuration..."
sudo nginx -t

# Reload Nginx to apply the changes
echo "Reloading Nginx..."
sudo systemctl reload nginx

echo "Nginx setup complete!"


# Pull the frontend app, then build and move to serving nginx dir

curl https://534098467822-sample-app.s3.us-west-1.amazonaws.com/client.tar --output client.tar

tar xzf client.tar client

cd client && npm run build

cd build && sudo mv * /var/www/html
