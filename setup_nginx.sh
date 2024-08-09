#!/bin/bash

# Arguments
fqdn="$1"
random_port="$2"

# Nginx configuration content
nginx_config="
server {
    listen 80;
    server_name $fqdn;

    location / {
        proxy_pass http://127.0.0.1:$random_port;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
"

# Write the Nginx configuration
echo "$nginx_config" > /etc/nginx/sites-available/"$fqdn"

# Create a symlink in sites-enabled
ln -s /etc/nginx/sites-available/"$fqdn" /etc/nginx/sites-enabled/"$fqdn"

# Reload Nginx to apply the new configuration
systemctl reload nginx
