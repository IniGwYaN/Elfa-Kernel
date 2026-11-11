#!/bin/bash
# Prepare extra I/O schedulers (self-contained)
# maple comes from repo Patches/maple-iosched.c; others downloaded at build time.
set -e
cd "$GITHUB_WORKSPACE/device_kernel"
echo "[+] CWD: $(pwd)"
echo "[+] ls Patches:"; ls Patches/ 2>/dev/null | head -5 || echo "  (tidak ada Patches/)"
# Maple from vendored local copy (cari di beberapa lokasi)
if [[ -f "Patches/maple-iosched.c" ]]; then
  cp Patches/maple-iosched.c block/maple-iosched.c
elif [[ -f "$GITHUB_WORKSPACE/Patches/maple-iosched.c" ]]; then
  cp "$GITHUB_WORKSPACE/Patches/maple-iosched.c" block/maple-iosched.c
else
  echo "[-] maple lokal tidak ketemu, coba unduh dari LawRun"
  curl -fsSL "https://raw.githubusercontent.com/negrroo/LawRun_xiaomi_sdm845_CAF/HEAD/block/maple-iosched.c" -o block/maple-iosched.c || { echo "[-] maple unduh gagal"; exit 1; }
fi
IB="https://raw.githubusercontent.com/negrroo/LawRun_xiaomi_sdm845_CAF/HEAD/block"
for f in anxiety-iosched.c zen-iosched.c tripndroid-iosched.c fiops-iosched.c sio-iosched.c; do
  curl -fsSL "$IB/$f" -o "block/$f" || echo "warning: failed to fetch $f"
done
grep -q 'IOSCHED_MAPLE' block/Kconfig.iosched || cat >> block/Kconfig.iosched <<'KCFG'
config IOSCHED_MAPLE
	tristate "Maple I/O scheduler"
	default n
	---help---
	Maple I/O scheduler.
config IOSCHED_ANXIETY
	tristate "Anxiety I/O scheduler"
	default n
	---help---
	Anxiety I/O scheduler.
config IOSCHED_ZEN
	tristate "Zen I/O scheduler"
	default n
	---help---
	Zen I/O scheduler.
config IOSCHED_TRIPNDROID
	tristate "Tripndroid I/O scheduler"
	default n
	---help---
	Tripndroid I/O scheduler.
config IOSCHED_FIOPS
	tristate "Fiops I/O scheduler"
	default n
	---help---
	Fiops I/O scheduler.
config IOSCHED_SIO
	tristate "SIO I/O scheduler"
	default n
	---help---
	SIO I/O scheduler.
KCFG
grep -q 'anxiety-iosched.o' block/Makefile || cat >> block/Makefile <<'MKF'
obj-$(CONFIG_IOSCHED_ANXIETY) += anxiety-iosched.o
obj-$(CONFIG_IOSCHED_MAPLE) += maple-iosched.o
obj-$(CONFIG_IOSCHED_ZEN) += zen-iosched.o
obj-$(CONFIG_IOSCHED_TRIPNDROID) += tripndroid-iosched.o
obj-$(CONFIG_IOSCHED_FIOPS) += fiops-iosched.o
obj-$(CONFIG_IOSCHED_SIO) += sio-iosched.o
MKF
echo "iosched prepared"
