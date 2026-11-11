# Elfa Kernel

Kernel kustom untuk **Poco F1 (beryllium)** — berbasis LineageOS 20 (Android 13), kernel **4.9.337**.

## Fitur
- Base bersih: fork `lineage-20` @ `a7809bd68e` (sama dengan v0.5.5 yang terbukti boot)
- **BakaSU** (KernelSU fork) + **SUSFS v2.3.0** (Chimera)
- **GPU fix**: `msm_lmh_dcvs.c` tanpa clamp `CPUFREQ_ADJUST` + `CONFIG_QTI_THERMAL_LIMITS_DCVS=n` — GPU tidak dikunci di 257 MHz, langsung naik saat main game
- Perf defaults: scheduler io (zen/maple/fiops/sio/anxiety/tripndroid), interactive tuning, zram, westwood, dll.

## Build
Build berjalan di GitHub Actions (workflow `build-kernel.yml`). Jalankan manual via tab **Actions → Run workflow**.

- `runs-on: ubuntu-24.04`, `container: ubuntu:focal` (gcc 9.4.0)
- Toolchain: Android GCC 4.9 prebuilt (64 & 32 bit)
- Source kernel: `android_kernel_xiaomi_sdm845` @ `v0.5.5-playtest`
- Komposit action memakai harness `NonGKI_Kernel_Build_2nd@mainline`

## Flash
Flash lewat TWRP/OrangeFox. Back up boot lama dulu.

## Verifikasi GPU
Setelah boot, cek GPU di terminal:
```sh
cat /sys/class/kgsl/kgsl-3d0/max_gpuclk
cat /sys/class/kgsl/kgsl-3d0/gpuclk
```
Saat bermain game, `gpuclk` harus naik (338/425/487/600 MHz), bukan mentok 257 MHz.

## Lisensi
GPLv2 — kernel sumber mengikuti lisensi asli Linux.
