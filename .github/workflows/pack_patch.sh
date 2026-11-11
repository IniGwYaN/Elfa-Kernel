#!/usr/bin/env bash
set -e

# Jalankan dari $GITHUB_WORKSPACE/device_kernel/
AK="AnyKernel3/anykernel.sh"

# ---- 1) Banner flash (ASCII art) ----
if [ -f "$GITHUB_WORKSPACE/misc/flash_banner.txt" ]; then
  BANNER=$(cat "$GITHUB_WORKSPACE/misc/flash_banner.txt")
  UI_PRINT=""
  while IFS= read -r line; do
    UI_PRINT="${UI_PRINT}ui_print \"${line}\";"$'\n'
  done <<< "$BANNER"
  python3 - "$UI_PRINT" <<'PY'
import sys
banner = sys.argv[1]
fn = "AnyKernel3/anykernel.sh"
s = open(fn).read()
anchor = ". tools/ak3-core.sh;\n"
assert anchor in s, "anchor not found"
s = s.replace(anchor, anchor + "\n# --- banner flash ---\n" + banner + "# --- end ---\n", 1)
open(fn,"w").write(s)
PY
fi

# ---- 2) Paksa maple sebagai IO scheduler (userspace override saat boot) ----
python3 - <<'PY'
fn = "AnyKernel3/anykernel.sh"
s = open(fn).read()
anchor = "dump_boot;"
assert anchor in s, "dump_boot anchor not found"
rc_block = (
    "\n# --- Elfa: paksa maple IO scheduler ---\n"
    "on late_start\n"
    "    write /sys/block/mmcblk0/queue/scheduler maple\n"
    "    write /sys/block/sda/queue/scheduler maple\n"
    "    write /sys/block/sdb/queue/scheduler maple\n"
    "    write /sys/block/sdc/queue/scheduler maple\n"
    "    write /sys/block/sde/queue/scheduler maple\n"
    "on property:sys.boot_completed=1\n"
    "    write /sys/block/mmcblk0/queue/scheduler maple\n"
    "    write /sys/block/sda/queue/scheduler maple\n"
    "    write /sys/block/sdb/queue/scheduler maple\n"
    "    write /sys/block/sdc/queue/scheduler maple\n"
    "    write /sys/block/sde/queue/scheduler maple\n"
    "# --- akhir ---\n"
)
s = s.replace(anchor, anchor + rc_block, 1)
open(fn,"w").write(s)
PY
