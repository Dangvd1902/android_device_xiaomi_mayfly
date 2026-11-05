# PixelOS 17 / Xiaomi 12S (mayfly) integration staging

This branch is a staging area, NOT a build-ready PixelOS 17 device tree.
Base branch: fifteen. Do not flash artifacts until kernel/vendor compatibility and build validation are complete.

## Verified upstreams (2026-11-05)

| Component | Repository | Branch | Destination |
| --- | --- | --- | --- |
| Mayfly device (reference) | LineageOS/android_device_xiaomi_mayfly | lineage-24.0 | device/xiaomi/mayfly |
| SM8450 common | Joshabys-Xiaomi-12-Org/android_device_xiaomi_sm8450-common | lineage-24.0 | device/xiaomi/sm8450-common |
| Common proprietary vendor | Joshabys-Xiaomi-12-Org/proprietary_vendor_xiaomi_sm8450-common | lineage-24.0-gpu-driver-863.1 | vendor/xiaomi/sm8450-common |
| Kernel (candidate only) | Joshabys-Xiaomi-12-Org/android_kernel_xiaomi_sm8450 | lineage-23.2 | kernel/xiaomi/sm8450 |
| Kernel modules (reference) | LineageOS/android_kernel_xiaomi_sm8450-modules | lineage-24.0 | kernel/xiaomi/sm8450-modules |

## Pending before build

1. Import/port the LineageOS lineage-24.0 mayfly device files on a reviewed diff, preserving mayfly-specific overlays and configurations.
2. Resolve proprietary vendor/xiaomi/mayfly source or extraction scripts and firmware baseline.
3. Verify that Joshabys lineage-23.2 kernel can build with lineage-24.0 common tree; inspect required kernel configs, modules, toolchain and ABI. Do not assume compatibility.
4. Verify vendor-common GPU driver branch matches kernel and proprietary blobs.
5. Replace LineageOS product naming, lunch choices and version references with PixelOS 17 conventions based on the actual PixelOS manifest/build definitions.
6. Check boot, display, camera, fingerprint, NFC, auto brightness, SELinux and OTA partitions on device.

## Proposed local manifest (incomplete; not ready for repo sync)

```xml
<?xml version="1.0" encoding="UTF-8"?>
<manifest>
  <remote name="github" fetch="https://github.com/" />
  <project name="LineageOS/android_device_xiaomi_mayfly" path="device/xiaomi/mayfly" remote="github" revision="lineage-24.0" />
  <project name="Joshabys-Xiaomi-12-Org/android_device_xiaomi_sm8450-common" path="device/xiaomi/sm8450-common" remote="github" revision="lineage-24.0" />
  <project name="Joshabys-Xiaomi-12-Org/proprietary_vendor_xiaomi_sm8450-common" path="vendor/xiaomi/sm8450-common" remote="github" revision="lineage-24.0-gpu-driver-863.1" />
  <project name="Joshabys-Xiaomi-12-Org/android_kernel_xiaomi_sm8450" path="kernel/xiaomi/sm8450" remote="github" revision="lineage-23.2" />
  <project name="LineageOS/android_kernel_xiaomi_sm8450-modules" path="kernel/xiaomi/sm8450-modules" remote="github" revision="lineage-24.0" />
</manifest>
```

Do not sync this alongside existing projects at the same paths without first removing conflicts. This is an upstream mapping, not a validated build manifest.
