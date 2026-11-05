# DeftOS-New-Generation-Arch-Base

Base Arch Linux cho DeftOS (archiso profile).

- `profile/`: profile archiso (baseline), repo Arch chuẩn, kernel `linux` + `linux-lts` dự phòng.
- Chống panic: `profile/airootfs/etc/sysctl.d/99-deftos-panic.conf`.
- Snapshot: `snapper`, `snap-pac`, `grub-btrfs`.
- `golden/`: lưu trạng thái hệ thống (manifest, package lock, rootfs).
- `branding/`: hình nền tạm (logo gốc chưa có).

Chưa làm: kernel Arch tùy chỉnh (đồng bộ với repo chính), tự rollback khi boot lỗi, khóa cập nhật kernel.
