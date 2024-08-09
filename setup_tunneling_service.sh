#!/bin/bash

# Ensure necessary packages are installed
sudo apt-get update
sudo apt-get install -y python3 python3-pip nginx openssh-server

# Create the user 'host' without a home directory and with a disabled password
sudo adduser --disabled-password --no-create-home --shell /bin/bash host

# Make the password actually empty
sudo sed -i -re 's/^host:[^:]+:/host::/' /etc/passwd /etc/shadow

# Start and enable Nginx and SSH server at boot
sudo systemctl start nginx
sudo systemctl enable nginx
sudo systemctl start ssh
sudo systemctl enable ssh

# Allow blank passwords for SSH sessions in PAM
sudo sed -i -re 's/^@include common-auth$/auth [success=1 default=ignore] pam_unix.so nullok\nauth requisite pam_deny.so\nauth required pam_permit.so/' /etc/pam.d/sshd

# Add the host user to sudoers with NOPASSWD for necessary scripts
sudo bash -c "echo 'host ALL=(ALL) NOPASSWD: /path/to/setup_nginx.sh, /path/to/cleanup.sh' >> /etc/sudoers"

# Allow blank passwords and set ForceCommand for the 'host' user in SSHD config
sudo bash -c "echo -e '\nMatch User host\n    PermitEmptyPasswords yes\n    ForceCommand /path/to/tunnel_service.py' >> /etc/ssh/sshd_config"

# Restart SSH service to apply changes
sudo systemctl reload ssh.service

echo "Tunneling service setup complete."
