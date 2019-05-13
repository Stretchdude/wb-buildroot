ifeq ($(BR2_LRD_DEVEL_BUILD),y)
else

WB50N_FIRMWARE_BINARIES_VERSION = $(call qstrip,$(BR2_PACKAGE_WB50N_FIRMWARE_BINARIES_VERSION_VALUE))
WB50N_FIRMWARE_BINARIES_SOURCE =
WB50N_FIRMWARE_BINARIES_LICENSE = GPL-2.0
WB50N_FIRMWARE_BINARIES_LICENSE_FILES = COPYING

ifeq ($(MSD_BINARIES_SOURCE_LOCATION),laird_internal)
  WB50N_FIRMWARE_BINARIES_SITE = http://devops.lairdtech.com/share/builds/linux/firmware/$(WB50N_FIRMWARE_BINARIES_VERSION)
else
  WB50N_FIRMWARE_BINARIES_SITE = https://github.com/LairdCP/wb-package-archive/releases/download/LRD-REL-$(WB50N_FIRMWARE_BINARIES_VERSION)
endif

ifeq ($(BR2_FIRMWARE_BINARIES_ATH6K_6003),y)
define WB50N_FIRMWARE_BINARIES_ATH6K_6003_INSTALL_TARGET
	tar -xjf $(DL_DIR)/wb50n-firmware-binaries/laird-ath6k-6003-firmware-$(WB50N_FIRMWARE_BINARIES_VERSION).tar.bz2 -C $(TARGET_DIR) --keep-directory-symlink --no-overwrite-dir --touch
endef

WB50N_FIRMWARE_BINARIES_EXTRA_DOWNLOADS += laird-ath6k-6003-firmware-$(WB50N_FIRMWARE_BINARIES_VERSION).tar.bz2
endif

ifeq ($(BR2_FIRMWARE_BINARIES_ATH6K_6004),y)
define WB50N_FIRMWARE_BINARIES_ATH6K_6004_INSTALL_TARGET
	tar -xjf $(DL_DIR)/wb50n-firmware-binaries/laird-ath6k-6004-firmware-$(WB50N_FIRMWARE_BINARIES_VERSION).tar.bz2 -C $(TARGET_DIR) --keep-directory-symlink --no-overwrite-dir --touch
endef

WB50N_FIRMWARE_BINARIES_EXTRA_DOWNLOADS += laird-ath6k-6004-firmware-$(WB50N_FIRMWARE_BINARIES_VERSION).tar.bz2
endif

define WB50N_FIRMWARE_BINARIES_INSTALL_TARGET_CMDS
	$(WB50N_FIRMWARE_BINARIES_ATH6K_6003_INSTALL_TARGET)
	$(WB50N_FIRMWARE_BINARIES_ATH6K_6004_INSTALL_TARGET)
endef

endif

$(eval $(generic-package))
