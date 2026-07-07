#!/bin/bash
set -euo pipefail

IMAGE="${1:-ghcr.io/glapiy12/my-steamos-handheld:latest}"
OUTPUT="${2:-./my-steamos.iso}"

echo "==> Pulling image with Podman"
sudo podman pull "${IMAGE}"

echo "==> Installing bootc-image-builder"
curl -L -o bootc-image-builder https://github.com/osbuild/bootc-image-builder/releases/latest/download/bootc-image-builder-linux-amd64
chmod +x bootc-image-builder
sudo mv bootc-image-builder /usr/local/bin/

echo "==> Creating ISO with bootc-image-builder"
mkdir -p output

sudo bootc-image-builder \
  --type iso \
  --local \
  "${IMAGE}"

# bootc-image-builder по умолчанию создаёт папку bootiso, ищем ISO там
ISO_PATH=$(find . -name '*.iso' -type f | head -1)
if [ -z "$ISO_PATH" ]; then
  echo "Error: ISO not found" >&2
  exit 1
fi

mv "$ISO_PATH" "$OUTPUT"
echo "==> ISO saved to ${OUTPUT}"
