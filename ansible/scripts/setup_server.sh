#!/usr/bin/env bash
set -euo pipefail

sudo apt-get update -y
sudo apt-get install -y nginx
sudo systemctl enable --now nginx
sudo ufw allow in "nginx"
echo "Nginx ready on $(hostname)"
