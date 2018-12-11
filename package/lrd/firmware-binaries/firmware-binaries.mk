ifeq ($(BR2_LRD_DEVEL_BUILD),y)
else
FIRMWARE_BINARIES_VERSION = 0.0.0.0

STERLING-LWB-FCC=480-0079
STERLING-LWB-ETSI=480-0080
STERLING-LWB-JP=480-0116
STERLING-LWB5-FCC=480-0081
STERLING-LWB5-ETSI=480-0082
STERLING-LWB5-IC=480-0094
STERLING-LWB5-JP=480-0095
LWB-MFG=480-0108
LWB5-MFG=480-0109
WL-FMAC=930-0081
SOM60=laird-som60-radio-firmware
ATH6K-6003=laird-ath6k-6003-firmware
ATH6K-6004=laird-ath6k-6004-firmware

FIRMWARE_BINARIES_SOURCE =
FIRMWARE_BINARIES_LICENSE = GPL-2.0
FIRMWARE_BINARIES_LICENSE_FILES = COPYING
FIRMWARE_BINARIES_SITE = https://github.com/LairdCP/wb-package-archive/raw/master

define install-firmware-lwb-func
	unzip -p $(DL_DIR)/$(1)-$(FIRMWARE_BINARIES_VERSION).zip | tar -xjf - -C $(TARGET_DIR) --keep-directory-symlink --no-overwrite-dir --touch
endef

define install-firmware-lrd-func
	tar -xjf $(DL_DIR)/$(1)-$(FIRMWARE_BINARIES_VERSION).tar.bz2 -C $(TARGET_DIR) --keep-directory-symlink --no-overwrite-dir --touch
endef

ifeq ($(BR2_FIRMWARE_BINARIES_480_0079),y)
define FIRMWARE_BINARIES_480_0079_INSTALL_TARGET
	$(call install-firmware-lwb-func,$(STERLING-LWB-FCC))
endef

FIRMWARE_BINARIES_EXTRA_DOWNLOADS += $(STERLING-LWB-FCC)-$(FIRMWARE_BINARIES_VERSION).zip
endif

ifeq ($(BR2_FIRMWARE_BINARIES_480_0080),y)
define FIRMWARE_BINARIES_480_0080_INSTALL_TARGET
	$(call install-firmware-lwb-func,$(STERLING-LWB-ETSI))
endef

FIRMWARE_BINARIES_EXTRA_DOWNLOADS += $(STERLING-LWB-ETSI)-$(FIRMWARE_BINARIES_VERSION).zip
endif

ifeq ($(BR2_FIRMWARE_BINARIES_480_0116),y)
define FIRMWARE_BINARIES_480_0116_INSTALL_TARGET
	$(call install-firmware-lwb-func,$(STERLING-LWB-JP))
endef

FIRMWARE_BINARIES_EXTRA_DOWNLOADS += STERLING-LWB-JP)-$(FIRMWARE_BINARIES_VERSION).zip
endif

ifeq ($(BR2_FIRMWARE_BINARIES_480_0108),y)
define FIRMWARE_BINARIES_480_0108_INSTALL_TARGET
	$(call install-firmware-lwb-func,$(LWB-MFG))
endef

FIRMWARE_BINARIES_EXTRA_DOWNLOADS += laird-lwb-firmware-mfg-MFG)-$(FIRMWARE_BINARIES_VERSION).zip
endif

ifeq ($(BR2_FIRMWARE_BINARIES_480_0081),y)
define FIRMWARE_BINARIES_480_0081_INSTALL_TARGET
	call install-firmware-lwb-func,$(STERLING-LWB5-FCC))
endef

FIRMWARE_BINARIES_EXTRA_DOWNLOADS += STERLING-LWB5-FCC)-$(FIRMWARE_BINARIES_VERSION).zip
endif

ifeq ($(BR2_FIRMWARE_BINARIES_480_0082),y)
define FIRMWARE_BINARIES_480_0082_INSTALL_TARGET
	$(call install-firmware-lwb-func,$(STERLING-LWB5-ETSI))
endef

FIRMWARE_BINARIES_EXTRA_DOWNLOADS += STERLING-LWB5-ETSI)-$(FIRMWARE_BINARIES_VERSION).zip
endif

ifeq ($(BR2_FIRMWARE_BINARIES_480_0094),y)
define FIRMWARE_BINARIES_480_0094_INSTALL_TARGET
	$(call install-firmware-lwb-func,$(STERLING-LWB5-IC))
endef

FIRMWARE_BINARIES_EXTRA_DOWNLOADS += STERLING-LWB5-IC)-$(FIRMWARE_BINARIES_VERSION).zip
endif

ifeq ($(BR2_FIRMWARE_BINARIES_480_0095),y)
define FIRMWARE_BINARIES_480_0095_INSTALL_TARGET
	$(call install-firmware-lwb-func,$(STERLING-LWB5-JP))
endef

FIRMWARE_BINARIES_EXTRA_DOWNLOADS += STERLING-LWB5-JP)-$(FIRMWARE_BINARIES_VERSION).zip
endif

ifeq ($(BR2_FIRMWARE_BINARIES_480_0109),y)
define FIRMWARE_BINARIES_480_0109_INSTALL_TARGET
	$(call install-firmware-lwb-func,$(LWB5-MFG))
endef

FIRMWARE_BINARIES_EXTRA_DOWNLOADS += laird-lwb5-firmware-mfg-$(FIRMWARE_BINARIES_VERSION).zip
endif

ifeq ($(BR2_FIRMWARE_BINARIES_930_0081),y)
define FIRMWARE_BINARIES_930_0081_INSTALL_TARGET
	unzip -uo $(DL_DIR)/$(WL-FMAC)-$(FIRMWARE_BINARIES_VERSION).zip -d $(TARGET_DIR)/usr/bin/
endef

FIRMWARE_BINARIES_EXTRA_DOWNLOADS += $(WL-FMAC)-$(FIRMWARE_BINARIES_VERSION).zip
endif

ifeq ($(BR2_FIRMWARE_BINARIES_SOM60),y)
define FIRMWARE_BINARIES_SOM60_INSTALL_TARGET
	$(call install-firmware-lrd-func,$(SOM60))
endef

FIRMWARE_BINARIES_EXTRA_DOWNLOADS += $(SOM60)-$(FIRMWARE_BINARIES_VERSION).tar.bz2
endif

ifeq ($(BR2_FIRMWARE_BINARIES_ATH6K_6003),y)
define FIRMWARE_BINARIES_ATH6K_6003_INSTALL_TARGET
	$(call install-firmware-lrd-func,$(ATH6K-6003))
endef

FIRMWARE_BINARIES_EXTRA_DOWNLOADS += $(ATH6K-6003)-$(FIRMWARE_BINARIES_VERSION).tar.bz2
endif

ifeq ($(BR2_FIRMWARE_BINARIES_ATH6K_6004),y)
define FIRMWARE_BINARIES_ATH6K_6004_INSTALL_TARGET
	$(call install-firmware-lrd-func,$(ATH6K-6004))
endef

FIRMWARE_BINARIES_EXTRA_DOWNLOADS += $(ATH6K-6004)-$(FIRMWARE_BINARIES_VERSION).tar.bz2
endif

define FIRMWARE_BINARIES_INSTALL_TARGET_CMDS
	$(FIRMWARE_BINARIES_480_0079_INSTALL_TARGET)
	$(FIRMWARE_BINARIES_480_0080_INSTALL_TARGET)
	$(FIRMWARE_BINARIES_480_0116_INSTALL_TARGET)
	$(FIRMWARE_BINARIES_480_0108_INSTALL_TARGET)
	$(FIRMWARE_BINARIES_480_0081_INSTALL_TARGET)
	$(FIRMWARE_BINARIES_480_0082_INSTALL_TARGET)
	$(FIRMWARE_BINARIES_480_0094_INSTALL_TARGET)
	$(FIRMWARE_BINARIES_480_0095_INSTALL_TARGET)
	$(FIRMWARE_BINARIES_480_0109_INSTALL_TARGET)
	$(FIRMWARE_BINARIES_930_0081_INSTALL_TARGET)
	$(FIRMWARE_BINARIES_SOM60_INSTALL_TARGET)
	$(FIRMWARE_BINARIES_ATH6K_6003_INSTALL_TARGET)
	$(FIRMWARE_BINARIES_ATH6K_6004_INSTALL_TARGET)
endef

endif

$(eval $(generic-package))
