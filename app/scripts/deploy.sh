#!/bin/bash
set -euo pipefail

docker pull "$1"
docker rm -f app || true
docker run -d --name app --restart always -p 3000:3000 "$1"
