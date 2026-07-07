#!/bin/bash
set -euo pipefail

IMAGE="${1:-ghcr.io/glapiy12/my-steamos-handheld:latest}"
OUTPUT="${2:-./my-steamos.iso}"

echo "==> Pulling image ${IMAGE}"
docker pull "${IMAGE}"

echo "==> Creating ISO with bootc-image-builder"
mkdir -p output

docker run \
  --rm \
  --privileged \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v "$(pwd)/output":/output \
  quay.io/centos-bootc/bootc-image-builder:latest \
  --type iso \
  "docker-daemon:${IMAGE}"

# Ищем готовый ISO
ISO_PATH=$(find output -name '*.iso' | head -1)
if [ -z "$ISO_PATH" ]; then
  echo "Error: ISO not found" >&2
  exit 1
fi

mv "$ISO_PATH" "$OUTPUT"
echo "==> ISO saved to ${OUTPUT}"
