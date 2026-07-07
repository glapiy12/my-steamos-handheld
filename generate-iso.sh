#!/bin/bash
set -euo pipefail

IMAGE="${1:-ghcr.io/glapiy12/my-steamos-handheld:latest}"
OUTPUT="${2:-./my-steamos.iso}"

echo "==> Pulling image ${IMAGE}"
docker pull "${IMAGE}"

echo "==> Creating ISO with bootc-image-builder"
mkdir -p output

# Создаём заглушку для /var/lib/containers/storage, чтобы bootc-image-builder не ругался
mkdir -p /tmp/containers-storage/overlay

docker run \
  --rm \
  --privileged \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v "$(pwd)/output":/output \
  -v /tmp/containers-storage:/var/lib/containers/storage \
  quay.io/centos-bootc/bootc-image-builder:latest \
  --type iso \
  --local \
  "${IMAGE}"

# Ищем готовый ISO
ISO_PATH=$(find output -name '*.iso' | head -1)
if [ -z "$ISO_PATH" ]; then
  echo "Error: ISO not found" >&2
  exit 1
fi

mv "$ISO_PATH" "$OUTPUT"
echo "==> ISO saved to ${OUTPUT}"
