#!/bin/bash
set -euo pipefail

IMAGE="${1:-ghcr.io/glapiy12/my-steamos-handheld:latest}"
OUTPUT="${2:-./my-steamos.iso}"

echo "==> Pulling image with Podman"
sudo podman pull "${IMAGE}"

echo "==> Saving image to OCI archive"
sudo podman save "${IMAGE}" --format oci-archive -o /tmp/image.tar

echo "==> Creating ISO with bootc-image-builder"
mkdir -p output

sudo podman run \
  --rm \
  --privileged \
  -v /tmp/image.tar:/tmp/image.tar:ro \
  -v "$(pwd)/output":/output \
  quay.io/centos-bootc/bootc-image-builder:latest \
  --type iso \
  "oci-archive:/tmp/image.tar"

ISO_PATH=$(find output -name '*.iso' | head -1)
if [ -z "$ISO_PATH" ]; then
  echo "Error: ISO not found" >&2
  exit 1
fi

mv "$ISO_PATH" "$OUTPUT"
echo "==> ISO saved to ${OUTPUT}"
