#!/usr/bin/env bash
set -euo pipefail

sudo apt-get update -y
sudo apt-get install -y nginx
sudo systemctl enable nginx
sudo systemctl start nginx
echo "Nginx ready on $(hostname)"
