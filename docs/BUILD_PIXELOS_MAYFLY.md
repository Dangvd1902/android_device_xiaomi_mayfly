# Build PixelOS 15 for Xiaomi 12S (`mayfly`)

This guide records the Worker 3 build that produced PixelOS Android 15, build `20261104-1403`.
The build completed successfully. Its OTA package was not fully installed on the phone: ADB sideload stopped at about 47%.

## Build host and source tree

- Host: Worker 3, Ubuntu 22.04 under WSL2.
- Checkout: `/home/dangvd/android/pixelos`.
- Device target: `aosp_mayfly-bp1a-userdebug`.
- Build command: `m bacon -j12`.
- Keep using the existing checkout and its local manifest. The Android 15 source changes described below are not all part of the public device-tree repository.

## Rebuild

```bash
cd /home/dangvd/android/pixelos
set -o pipefail
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/home/dangvd/bin
export CC_WRAPPER=/usr/bin/ccache
export USE_CCACHE=1
export CCACHE_EXEC=/usr/bin/ccache
export CCACHE_DIR=/home/dangvd/.cache/ccache
unset ALLOW_MISSING_DEPENDENCIES
source build/envsetup.sh
lunch aosp_mayfly-bp1a-userdebug
m bacon -j12 2>&1 | tee /home/dangvd/pixelos-build.log
```

Use `-j12` on the current Worker 3 WSL configuration. Increase it only after checking the memory limit available to WSL. Do not start a second build in the same checkout.

## Source state used for build `20261104-1403`

- `.repo/local_manifests/mayfly.xml` replaces `vendor_gms` with `vendor_gms-15`, pinned to `b660c02ae56aa5dd39e5205231e1e8408bd7e52e`.
- `vendor/aosp/config/common.mk` inherits `vendor/gms/products/gms.mk`.
- Framework profile support is in `frameworks/base/core/java/com/android/internal/util/CertifiedPropsConfig.java` and `PropImitationHooks.java`.
- The device overlay is `device/xiaomi/mayfly/pihooks-overlay/`; it pins the public crDroid certification profile commit `5adb1318dcbab747c84206899afde57d9606561a`.
- The health HAL SELinux service-context fix is in `device/lineage/sepolicy/common/dynamic/service_contexts` for `vendor.lineage.health.IFastCharge/default`.

If rebuilding from a fresh checkout, restore these source changes and the local manifest before building. Do not assume that syncing the public `fifteen` device-tree branch alone restores the complete build state.

## Output and validation

- OTA: `out/target/product/mayfly/PixelOS_mayfly-15.0-20261104-1403.zip`
- Boot images: `boot.img`, `dtbo.img`, `recovery.img`, `vendor_boot.img`, `vbmeta.img`, `vbmeta_system.img` in the same output directory.
- Build log from this run: `/home/dangvd/pixelos-gms15-pihooks-build.log`.
- Expected OTA metadata: `pre-device=mayfly`, `post-sdk-level=35` (Android 15).
- The Java profile helper, resource overlay, and repo manifest were checked before the full build; the full build reported success.

This build has not been verified to boot with Google apps or pass Play Integrity/banking-app checks. No private attestation keybox is included. Back up user data before any installation, and never relock the bootloader while a custom ROM is installed.

