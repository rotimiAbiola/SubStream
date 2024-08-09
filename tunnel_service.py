#!/usr/bin/env python3

import os
import random
import string
import subprocess
import sys

# Generate a random port
def generate_random_port():
    return random.randint(1024, 65535)

# Generate a random subdomain
def generate_subdomain():
    return ''.join(random.choices(string.ascii_lowercase + string.digits, k=8))

# Function to handle the cleanup process
def cleanup(subdomain):
    print("Cleaning up before logout...")
    subprocess.run(["sudo", "/path/to/cleanup.sh", subdomain])

# Get the original SSH command
original_command = os.getenv('SSH_ORIGINAL_COMMAND')
if not original_command:
    sys.exit(0)

# Intercept SSH command to replace port 80 with a random port
if "-R 80:" in original_command:
    # Generate a random port on the remote host
    random_port = generate_random_port()
    subdomain = generate_subdomain()
    fqdn = f"{subdomain}.domain.name"

    # Replace port 80 with the random port in the SSH command
    new_command = original_command.replace("-R 80:", f"-R {random_port}:")
    
    # Set up Nginx configuration for this subdomain
    subprocess.run(["sudo", "/path/to/setup_nginx.sh", fqdn, random_port])

    print(f"Subdomain created: {fqdn}")
    
    # Execute the modified SSH command
    try:
        subprocess.run(new_command, shell=True)
    finally:
        cleanup(subdomain)
else:
    print("No port forwarding detected in the SSH command.")
