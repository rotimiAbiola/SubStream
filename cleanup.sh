#!/bin/bash

# Arguments
fqdn="$1"

# Remove the Nginx config files
rm -f /etc/nginx/sites-available/"$fqdn"
rm -f /etc/nginx/sites-enabled/"$fqdn"

# Reload Nginx to apply changes
systemctl reload nginx
