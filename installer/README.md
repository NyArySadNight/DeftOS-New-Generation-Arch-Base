# DeftOS-Install (Arch)

`deftinstall` là lớp mỏng trên `archinstall`:
- Cấu hình (`archinstall.json`) lấy từ repo này, nên sửa ở đây là áp dụng cho lần cài tiếp theo.
- Kernel mặc định: `linux-deftos` (chưa có trong repo chính thức, cần bước kernel).
- Desktop mặc định: Cinnamon + LightDM.

Dùng: `sudo deftinstall` (có thể truyền thêm tham số của archinstall).
Biến môi trường: `DEFTOS_REPO_RAW`, `DEFTOS_LOCAL_CONFIG`.
