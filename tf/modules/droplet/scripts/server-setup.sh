#!/bin/bash

# Source: https://www.digitalocean.com/community/tutorials/initial-server-setup-with-ubuntu-22-04
# Source: https://github.com/jasonheecs/ubuntu-server-setup

set -e

# - (Optional) Adds a user account with sudo access
# - (Optional) Adds a public ssh key for the new user account
# - (Default) Disables password authentication to the server
# - Setup Uncomplicated Firewall (UFW)
# - Update installed packages (apt-get update)
# - (Optional) Install git
# - Install Docker and Docker-Compose (apt-get install ...)
# - Launch Docker-Compose with Nginx
# - Test connection with Nginx from local device
