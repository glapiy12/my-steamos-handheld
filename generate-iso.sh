#!/bin/bash
set -euo pipefail

IMAGE="${1:-ghcr.io/glapiy12/my-steamos-handheld:latest}"
OUTPUT="${2:-./my-steamos.iso}"

echo "==> Pulling image with Podman"
sudo podman pull "${IMAGE}"

echo "==> Creating ISO with bootc-image-builder"
mkdir -p output

sudo podman run \
  --rm \
  --privileged \
  -v /var/lib/containers:/var/lib/containers \
  -v "$(pwd)/output":/output \
  quay.io/centos-bootc/bootc-image-builder:latest \
  --type iso \
  "${IMAGE}"

# Ищем готовый ISO
ISO_PATH=$(find output -name '*.iso' | head -1)
if [ -z "$ISO_PATH" ]; then
  echo "Error: ISO not found" >&2
  exit 1
fi

mv "$ISO_PATH" "$OUTPUT"
echo "==> ISO saved to ${OUTPUT}"
