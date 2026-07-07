#!/bin/bash
set -euo pipefail

IMAGE="${1:-ghcr.io/glapiy12/my-steamos-handheld:latest}"
OUTPUT="${2:-./my-steamos.iso}"

echo "==> Pulling image ${IMAGE}"
docker pull "${IMAGE}"

echo "==> Exporting image to tar archive"
docker save "${IMAGE}" -o /tmp/my-image.tar

echo "==> Creating ISO with bootc-image-builder"
mkdir -p output

docker run \
  --rm \
  --privileged \
  -v "$(pwd)/output":/output \
  -v /tmp/my-image.tar:/tmp/my-image.tar:ro \
  quay.io/centos-bootc/bootc-image-builder:latest \
  --type iso \
  --source oci-archive:/tmp/my-image.tar

ISO_PATH=$(find output -name '*.iso' | head -1)
if [ -z "$ISO_PATH" ]; then
  echo "Error: ISO not found" >&2
  exit 1
fi

mv "$ISO_PATH" "$OUTPUT"
echo "==> ISO saved to ${OUTPUT}"
