#!/bin/bash
# Đồng bộ PKGBUILD kernel Arch chính thức, áp cấu hình DeftOS, rồi build.
# Chạy trong container archlinux bằng user thường (makepkg không chạy bằng root).
set -euo pipefail
ROOT=$(cd "$(dirname "$0")/.." && pwd)
W=$ROOT/kernel/build
rm -rf "$W"; mkdir -p "$W"
git clone --depth 1 https://gitlab.archlinux.org/archlinux/packaging/packages/linux.git "$W/src"
cd "$W/src"
# 1. Đổi tên gói để không đè kernel chính thức
sed -i -e 's/^pkgbase=.*/pkgbase=linux-deftos/' PKGBUILD
# 2. Áp fragment cấu hình DeftOS vào config của Arch
while IFS= read -r line; do
  [[ -z "$line" || "$line" == \#* ]] && continue
  opt=${line%%=*}; val=${line#*=}
  case "$val" in
    y) scripts/config --file config --enable "$opt" ;;
    n) scripts/config --file config --disable "$opt" ;;
    *) echo "bỏ qua: $line" ;;
  esac
done < "$ROOT/kernel/deftos.fragment"
# 3. Build (dùng config đã sửa)
makepkg -sf --noconfirm --skippgpcheck
mkdir -p "$ROOT/kernel/out" && cp ./*.pkg.tar.zst "$ROOT/kernel/out/"
ls -lh "$ROOT/kernel/out/"
