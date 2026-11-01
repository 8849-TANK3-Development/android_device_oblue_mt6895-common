#
# Copyright (C) 2026 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Set permissive for bringup
PRODUCT_PACKAGES += \
    set_permissive.rc \
    set_permissive.sh

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(LOCAL_PATH)

# Inherit the proprietary files
$(call inherit-product, vendor/oblue/mt6895-common/mt6895-common-vendor.mk)
