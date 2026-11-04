#!/bin/bash
# Sau mkarchiso: lưu manifest, package lock và rootfs đầy đủ vào golden/.
# Usage: make-golden.sh <airootfs_dir> <out_dir>
set -euo pipefail
ROOTFS=$1; OUT=$2
G=$(cd "$(dirname "$0")/.." && pwd)
mkdir -p "$G"
# 1. Manifest: hash từng file (bỏ qua /proc, /sys, /dev, /run, /tmp)
( cd "$ROOTFS" && find . -xdev \( -path ./proc -o -path ./sys -o -path ./dev -o -path ./run -o -path ./tmp \) -prune -o -type f -print0 \
  | sort -z | xargs -0 sha256sum ) > "$G/manifest.sha256"
# 2. Danh sách package có phiên bản
arch-chroot "$ROOTFS" pacman -Q > "$G/packages.lock"
# 3. Rootfs đầy đủ (artifact, không commit)
mkdir -p "$OUT"
mksquashfs "$ROOTFS" "$OUT/rootfs.sfs" -comp zstd -noappend
echo "manifest: $(wc -l < "$G/manifest.sha256") files, packages: $(wc -l < "$G/packages.lock")"
