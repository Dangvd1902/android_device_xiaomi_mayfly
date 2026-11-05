# Apply as device/xiaomi/mayfly/custom_mayfly.mk after syncing upstream device tree.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# PixelOS 17 common product. Verify existence in synced PixelOS tree.
$(call inherit-product, vendor/pixelos/config/common_full_phone.mk)

$(call inherit-product, device/xiaomi/mayfly/device.mk)

PRODUCT_BRAND := Xiaomi
PRODUCT_DEVICE := mayfly
PRODUCT_MANUFACTURER := Xiaomi
PRODUCT_MODEL := 2206123SC
PRODUCT_NAME := custom_mayfly
PRODUCT_GMS_CLIENTID_BASE := android-xiaomi

# Do not reuse unverified fingerprints or vendor security patch levels.
