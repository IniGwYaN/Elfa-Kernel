# Elfa Kernel

A custom kernel for the **POCO F1 (beryllium)**, based on **LineageOS 20 (Android 13)** with Linux **4.9.337**.

Built entirely with GitHub Actions and published here as flashable releases.

---

## Features

- **Clean, proven base** — line from the `lineage-20` fork @ `a7809bd68e`, the same source as the v0.5.5 build that boots reliably.
- **BakaSU + SUSFS v2.4.0**
- **GPU fix** — LMH thermal cap removed (`msm_lmh_dcvs.c` without the `CPUFREQ_ADJUST` clamp + `CONFIG_QTI_THERMAL_LIMITS_DCVS=n`). The GPU is no longer stuck at 257 MHz and ramps up immediately under load.
- **Perf tuning** — extra I/O schedulers (zen / maple / fiops / sio / anxiety / tripndroid), tuned interactive cpufreq defaults, zram + swap, westwood TCP, and more.

---

## Releases & Downloads

Latest flashable zips are attached to **GitHub Releases** on this repository.

1. Open the **Releases** tab.
2. Download the latest `Elfa-<version>.zip`.
3. Flash via recovery (see below).

All source and the build workflow live in this repo — the build output is published here too.

---

## Building

The build runs through the `build-kernel.yml` workflow. To trigger it:

- Go to **Actions → build-kernel.yml → Run workflow**.

Environment:

- Runner: `ubuntu-24.04`, container `ubuntu:focal` (gcc 9.4.0)
- Toolchain: Android GCC 4.9 prebuilt (AArch64 + ARM32)
- Kernel source: `android_kernel_xiaomi_sdm845` @ `v0.5.5-playtest`
- Composite actions are shared from `NonGKI_Kernel_Build_2nd@mainline`

---

## Installation

1. **Back up** your current boot partition.
2. Boot into **TWRP** or **OrangeFox**.
3. Flash `Elfa-<version>.zip`, wipe cache/dalvik.
4. Reboot.

---

## Verify GPU Fix

After booting, check the GPU clock:

```sh
cat /sys/class/kgsl/kgsl-3d0/max_gpuclk
cat /sys/class/kgsl/kgsl-3d0/gpuclk
```

Under load (e.g. a game) `gpuclk` should climb (338 / 425 / 487 / 600 MHz) instead of sitting at 257 MHz.

---

## Compatibility

- Device: POCO F1 (beryllium)
- ROM: LineageOS 20 / Android 13–based ROMs
- Kernel: 4.9.337 (AArch64)

---

## License

GPLv2 — follows the upstream Linux kernel license. Kernel drivers retain their original licenses.
