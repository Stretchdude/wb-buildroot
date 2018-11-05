SUMMIT_SUPPLICANT_BINARIES_VERSION = 6.0.0.109
SUMMIT_SUPPLICANT_BINARIES_SOURCE = summit_supplicant-arm-eabihf-$(SUMMIT_SUPPLICANT_BINARIES_VERSION).tar.bz2
SUMMIT_SUPPLICANT_BINARIES_LICENSE = GPL-2.0

ifeq ($(SUMMIT_SUPPLICANT_BINARIES_SOURCE_LOCATION),laird_internal)
  SUMMIT_SUPPLICANT_BINARIES_SITE_URL = http://devops.lairdtech.com/share/builds/linux/summit_supplicant/laird/$(SUMMIT_SUPPLICANT_BINARIES_VERSION)
else
  SUMMIT_SUPPLICANT_BINARIES_SITE_URL = https://github.com/LairdCP/wb-package-archive/raw/master
endif

SUMMIT_SUPPLICANT_BINARIES_SITE = $(SUMMIT_SUPPLICANT_BINARIES_SITE_URL)

define SUMMIT_SUPPLICANT_BINARIES_INSTALL_TARGET_CMDS
	tar -xf $(@D)/rootfs.tar -C $(TARGET_DIR) --overwrite
endef

$(eval $(generic-package))
