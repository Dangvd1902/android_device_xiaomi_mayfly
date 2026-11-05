# Mayfly PixelOS 17 staging kit

This is **not yet a buildable or flashable ROM**.

## Validated
- PixelOS official source branch: `seventeen`.
- LineageOS mayfly `lineage-24.0` has device.mk and BoardConfig.mk.
- LineageOS mayfly inherits `device/xiaomi/sm8450-common` and requires `vendor/xiaomi/mayfly`.
- Joshabys common tree, vendor common, kernel source repository exist. Pinned SHA references are candidate snapshots, **not a verified matched build set**.

## Preparation on a Linux build machine

```bash
mkdir -p ~/pixelos17 && cd ~/pixelos17
repo init -u https://github.com/PixelOS-AOSP/android_manifest.git -b seventeen --git-lfs
# Review upstream manifest for duplicate project paths before adding mayfly.xml.
mkdir -p .repo/local_manifests
cp /path/to/android_device_xiaomi_mayfly/integration/pixelos17/mayfly.xml .repo/local_manifests/mayfly.xml
repo sync -j4
```

**STOP** if repo sync reports duplicate paths or missing repos. The device-specific proprietary vendor tree is not included and must be sourced or extracted lawfully from the correct firmware.

## Product overlay (only after sources are complete)

Back up the LineageOS product files. Copy `custom_mayfly.mk` to `device/xiaomi/mayfly/` and replace `device/xiaomi/mayfly/AndroidProducts.mk` with the staged version. Verify the PixelOS common product path exists, and audit LineageOS-specific references in the common tree and device tree.

```bash
test -f vendor/pixelos/config/common_full_phone.mk || echo "BLOCKED: verify PixelOS product inheritance"
test -f vendor/xiaomi/mayfly/BoardConfigVendor.mk || echo "BLOCKED: missing mayfly vendor blobs"
test -f vendor/xiaomi/mayfly/mayfly-vendor.mk || echo "BLOCKED: missing mayfly vendor product"
test -f kernel/xiaomi/sm8450/arch/arm64/configs/vendor/mayfly_GKI.config || echo "BLOCKED: kernel mayfly config missing or relocated"
```

Only when all requirements and dependencies are resolved:

```bash
. build/envsetup.sh
lunch custom_mayfly-cp2a-userdebug
m pixelos
```

## Compatibility gates

- Kernel 5.10.269 PhoenyxCore v3 from Telegram is **not** proven to correspond to the pinned Joshabys kernel SHA.
- Verify kernel modules ABI, vendor GPU 863.1, DTBO, camera and firmware matching.
- Verify proprietary mayfly vendor sources, extraction, SELinux, boot, display, fingerprint, auto brightness, NFC, audio, and recovery.
- Do not add KernelSU, SuSFS or MIUI Camera ports to the first boot baseline.
- Do not flash to physical hardware before boot image and partition compatibility checks.
