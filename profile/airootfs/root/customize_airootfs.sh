#!/usr/bin/env bash
set -e
# Live user: khong mat khau, sudo khong can mat khau.
id liveuser >/dev/null 2>&1 || useradd -m -G wheel -s /bin/bash liveuser
passwd -d liveuser >/dev/null
echo "%wheel ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers.d/10-liveuser
chmod 440 /etc/sudoers.d/10-liveuser
