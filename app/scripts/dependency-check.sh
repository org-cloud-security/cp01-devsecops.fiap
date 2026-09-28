#!/bin/bash
set -euo pipefail

docker run --rm \
  -u "$(id -u):$(id -g)" \
  -v "$(pwd):/src" \
  owasp/dependency-check \
  --scan /src/app \
  --project app \
  --format HTML \
  --out /src \
  --failOnCVSS 7 \
  --nvdApiKey "$NVD_API_KEY"
