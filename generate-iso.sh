#!/bin/bash
set -euo pipefail

IMAGE="${1:-ghcr.io/glapiy12/my-steamos-handheld:latest}"
OUTPUT="${2:-./my-steamos.iso}"

echo "==> Pulling image with Podman"
sudo podman pull "${IMAGE}"

echo "==> Installing bootc-image-builder"
# Скачиваем последний статический бинарник
curl -Lo bootc-image-builder https://github.com/osbuild/bootc-image-builder/releases/latest/download/bootc-image-builder-linux-amd64
chmod +x bootc-image-builder
sudo mv bootc-image-builder /usr/local/bin/

echo "==> Creating ISO with bootc-image-builder"
mkdir -p output

# Запускаем бинарник напрямую — он получит доступ к Podman-хранилищу хоста
sudo bootc-image-builder \
  --type iso \
  --local \
  "${IMAGE}"

# Ищем ISO в output (по умолчанию кладёт в bootiso/install.iso)
ISO_PATH=$(find output -name '*.iso' | head -1)
if [ -z "$ISO_PATH" ]; then
  # если не нашли, ищем в стандартном месте
  ISO_PATH=$(find /var/lib/containers/storage -name '*.iso' 2>/dev/null | head -1) || true
  if [ -z "$ISO_PATH" ]; then
    echo "Error: ISO not found" >&2
    exit 1
  fi
fi

mv "$ISO_PATH" "$OUTPUT"
echo "==> ISO saved to ${OUTPUT}"
