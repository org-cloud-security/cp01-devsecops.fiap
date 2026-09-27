#!/bin/bash
set -euo pipefail

apt-get update
apt-get install -y docker.io

systemctl enable --now docker
usermod -aG docker azureuser
