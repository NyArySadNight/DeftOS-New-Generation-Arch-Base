# DeftOS installer (Arch base)

Installer for the Arch-based DeftOS. It keeps the archinstall framework and adds the DeftOS UI, hardware scan and kernel.

## Files
- `ui/index.html`: installer UI (9 steps, generates archinstall.json). Reads `ui/hw.js` when present.
- `bin/deftos-hwscan`: read-only hardware scan. Writes `hw.js` with the real CPU, GPU, RAM, disks, firmware, network and VM status.
- `bin/deftinstall-ui`: runs the scan, serves the UI on 127.0.0.1:8765 and opens a browser.
- `bin/deftinstall`: runs archinstall. `--config FILE` uses the JSON saved from the UI.
- `archinstall.json`: default configuration, used when no file is given and the repo is unreachable.

## Use on the live ISO
1. `deftinstall-ui`, then review the steps in the browser.
2. Press Copy config and save it as `archinstall.json`.
3. `sudo deftinstall --config archinstall.json`

## Notes
- Kernel `linux-deftos` is not in the official repos. Enable the `[deftos]` repo first.
- Snapshots need btrfs for root.
