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
# Bỏ target tài liệu (cần texlive/sphinx nặng, không cần cho kernel)
sed -i -e 's/\bhtmldocs\b//g' -e 's/\bpdfdocs\b//g' -e 's/\bmandocs\b//g' PKGBUILD
# 2. Giải nén + prepare() (chưa build) để có mã nguồn kernel và .config
makepkg -o -d --noconfirm --skippgpcheck
# Bỏ -Werror của tools/ (cảnh báo format-security làm hỏng bpf)
find src/*/tools -name 'Makefile*' -o -name '*.mk' 2>/dev/null | xargs -r sed -i -e 's/-Werror=format-security//g' -e 's/ -Werror//g'
CFG=$(find src -maxdepth 2 -name .config | head -1)
SRCDIR=$(dirname "$CFG")
# 3. Áp fragment DeftOS vào .config (đúng cây mã nguồn kernel)
while IFS= read -r line; do
  [[ -z "$line" || "$line" == \#* ]] && continue
  opt=${line%%=*}; val=${line#*=}
  case "$val" in
    y) "$SRCDIR/scripts/config" --file "$CFG" --enable "$opt" ;;
    n) "$SRCDIR/scripts/config" --file "$CFG" --disable "$opt" ;;
    *) echo "bỏ qua: $line" ;;
  esac
done < "$ROOT/kernel/deftos.fragment"
# 3b. Dựng các công cụ host (archscripts) tuần tự để tránh lỗi race fixdep khi -j
make -C "$SRCDIR" olddefconfig >/dev/null
make -C "$SRCDIR" -j1 archscripts
# 4. Build dùng mã nguồn đã sửa (-e: không giải nén lại)
makepkg -e -d --noconfirm --skippgpcheck
mkdir -p "$ROOT/kernel/out" && cp ./*.pkg.tar.zst "$ROOT/kernel/out/"
ls -lh "$ROOT/kernel/out/"
