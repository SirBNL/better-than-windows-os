#!/usr/bin/env bash
# Better Than Windows OS - one-command ISO builder (Debian live-build)
# Usage (on Debian/Ubuntu or WSL Debian/Ubuntu):
#     sudo ./build.sh
set -euo pipefail

if [ "$(id -u)" -ne 0 ]; then
  echo "Please run as root:  sudo ./build.sh"
  exit 1
fi

cd "$(dirname "$0")"

echo "==> Installing build dependencies..."
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y live-build debootstrap git ca-certificates curl dos2unix xorriso squashfs-tools

echo "==> Normalizing line endings & permissions..."
find auto config -type f -print0 | xargs -0 dos2unix -q 2>/dev/null || true
chmod +x auto/config 2>/dev/null || true
chmod +x config/hooks/normal/*.hook.chroot 2>/dev/null || true

echo "==> Cleaning any previous build..."
lb clean --purge || true

echo "==> Configuring live-build..."
lb config

echo "==> Building ISO (this can take 20-60 min and downloads ~1-2 GB)..."
lb build

echo
echo "==> DONE. Resulting ISO:"
ls -lh ./*.iso 2>/dev/null || echo "No ISO produced - check the log above."
