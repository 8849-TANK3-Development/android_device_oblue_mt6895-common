#
# Copyright (C) 2026 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Enable updating of APEXes
$(call inherit-product, $(SRC_TARGET_DIR)/product/updatable_apex.mk)

# Inherit generic_ramdisk product configuration
$(call inherit-product, $(SRC_TARGET_DIR)/product/generic_ramdisk.mk)

# Installs gsi keys into ramdisk, to boot a developer GSI with verified boot.
$(call inherit-product, $(SRC_TARGET_DIR)/product/developer_gsi_keys.mk)

# A/B
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota/launch_with_vendor_ramdisk.mk)

PRODUCT_PACKAGES += \
    update_engine \
    update_engine_sideload \
    update_verifier

PRODUCT_PACKAGES_DEBUG += \
    update_engine_client

# Boot control HAL
PRODUCT_PACKAGES += \
    bootctrl.default \
    android.hardware.boot@1.2-impl \
    android.hardware.boot@1.2-service \
    android.hardware.boot@1.2-impl.recovery \
    android.hardware.boot@1.2.recovery

# Dynamic Partitions
PRODUCT_USE_DYNAMIC_PARTITIONS := true
PRODUCT_BUILD_SUPER_PARTITION := false

# Modules
PRODUCT_PACKAGES += \
    init.insmod.sh \
    init.insmod.mt6895.cfg

# MTK plpath utils
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/mtk_plpath_utils/mtk_plpath_utils-system:$(TARGET_COPY_OUT_SYSTEM)/bin/mtk_plpath_utils \
    $(LOCAL_PATH)/mtk_plpath_utils/mtk-plpath-utils.rc:$(TARGET_COPY_OUT_SYSTEM)/etc/init/mtk-plpath-utils.rc \
    $(LOCAL_PATH)/mtk_plpath_utils/mtk_plpath_utils-recovery:recovery/root/system/bin/mtk_plpath_utils \
    $(LOCAL_PATH)/mtk_plpath_utils/mtk-plpath-utils.rc:recovery/root/system/etc/init/mtk-plpath-utils.rc

# Overlay
DEVICE_PACKAGE_OVERLAYS += \
    $(LOCAL_PATH)/overlay
PRODUCT_ENFORCE_RRO_TARGETS := *

# Rootdir
PRODUCT_PACKAGES += \
    fstab.enableswap \
    fstab.mt6895 \
    fstab.mt6895.vendor_ramdisk \
    init.cgroup.rc \
    init.connectivity.rc \
    init.modem.rc \
    init.mt6895.rc \
    init.mt6895.usb.rc \
    init.mtkgki.rc \
    init.project.rc \
    init.sensor_2_0.rc \
    init.recovery.mt6895.rc \
    ueventd.mt6895.rc

# Set permissive for bringup
PRODUCT_PACKAGES += \
    set_permissive.rc \
    set_permissive.sh

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(LOCAL_PATH)

# Inherit the proprietary files
$(call inherit-product, vendor/oblue/mt6895-common/mt6895-common-vendor.mk)
