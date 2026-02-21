#
# ViPER4AndroidFX configuration
# This file is required by LineageOS build system
#

# Enable ViPER4AndroidFX when TARGET_INCLUDE_VIPERFX := true (set in device makefile).
#
# - ViPER4AndroidFX: prebuilt product app (UI/service)
# - libv4a_re: vendor audio effect library (/vendor/lib64/soundfx/libv4a_re.so)
PRODUCT_PACKAGES += \
    ViPER4AndroidFX \
    libv4a_re
