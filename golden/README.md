# golden/ — trạng thái chuẩn của hệ thống

Mục đích: lưu đúng trạng thái từng file của hệ thống sau mỗi lần build, để có thể đối chiếu và khôi phục.

- `manifest.sha256`: SHA-256 của mọi file trong rootfs (1 dòng / file). Commit vào git, nhỏ, đối chiếu được.
- `packages.lock`: toàn bộ package kèm phiên bản (`pacman -Q`). Commit vào git.
- `pins.env`: ngày snapshot của kho pacman (để build lại đúng cùng bộ package).
- Rootfs đầy đủ (`rootfs.sfs`): không commit (quá lớn). Nằm trong artifact của build.

Build lại trạng thái cũ: đặt `ARCHIVE_DATE` trong `pins.env` về ngày đó, build lại, so `manifest.sha256`.
