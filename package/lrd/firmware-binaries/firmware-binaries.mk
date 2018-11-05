FIRMWARE_BINARIES_VERSION = 6.0.1.19
FIRMWARE_BINARIES_COMPANY_PROJECT = $(call qstrip,$(BR2_FIRMWARE_BINARIES_COMPANY_PROJECT))
FIRMWARE_BINARIES_SOURCE = firmware-binaries-$(FIRMWARE_BINARIES_COMPANY_PROJECT)-$(FIRMWARE_BINARIES_VERSION).tar.bz2
FIRMWARE_BINARIES_LICENSE = GPL-2.0
FIRMWARE_BINARIES_LICENSE_FILES = COPYING
FIRMWARE_BINARIES_SITE = https://github.com/LairdCP/wb-package-archive/raw/master

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
LRD-MWL=laird-sterling-60

define FIRMWARE_BINARIES_EXTRACT_CMDS
	$(TAR) -C "$(@D)" -xjf $(BR2_DL_DIR)/$(FIRMWARE_BINARIES_SOURCE)
endef

define FIRMWARE_BINARIES_CONFIGURE_CMDS

endef

define install-firmware-func
	rm $(@D)/lib -fr;
	test -f $(@D)/$(1)-*.zip && cd $(@D) && unzip -u $(1)-*.zip;
	cd $(@D) && tar -xjf $(1).tar.bz2;
	cp $(@D)/lib/firmware/* $(TARGET_DIR)/lib/firmware/ -dprf;
endef


define FIRMWARE_BINARIES_480_0079_INSTALL_TARGET
	$(call install-firmware-func,$(STERLING-LWB-FCC))
endef
ifeq ($(BR2_FIRMWARE_BINARIES_480_0079),y)
	FIRMWARE_BINARIES_POST_INSTALL_TARGET_HOOKS += FIRMWARE_BINARIES_480_0079_INSTALL_TARGET
endif

define FIRMWARE_BINARIES_480_0080_INSTALL_TARGET
	$(call install-firmware-func,$(STERLING-LWB-ETSI))
endef
ifeq ($(BR2_FIRMWARE_BINARIES_480_0080),y)
	FIRMWARE_BINARIES_POST_INSTALL_TARGET_HOOKS += FIRMWARE_BINARIES_480_0080_INSTALL_TARGET
endif

define FIRMWARE_BINARIES_480_0081_INSTALL_TARGET
	$(call install-firmware-func,$(STERLING-LWB5-FCC))
endef
ifeq ($(BR2_FIRMWARE_BINARIES_480_0081),y)
	FIRMWARE_BINARIES_POST_INSTALL_TARGET_HOOKS += FIRMWARE_BINARIES_480_0081_INSTALL_TARGET
endif

define FIRMWARE_BINARIES_480_0082_INSTALL_TARGET
	$(call install-firmware-func,$(STERLING-LWB5-ETSI))
endef
ifeq ($(BR2_FIRMWARE_BINARIES_480_0082),y)
	FIRMWARE_BINARIES_POST_INSTALL_TARGET_HOOKS += FIRMWARE_BINARIES_480_0082_INSTALL_TARGET
endif

define FIRMWARE_BINARIES_480_0094_INSTALL_TARGET
	$(call install-firmware-func,$(STERLING-LWB5-IC))
endef
ifeq ($(BR2_FIRMWARE_BINARIES_480_0094),y)
	FIRMWARE_BINARIES_POST_INSTALL_TARGET_HOOKS += FIRMWARE_BINARIES_480_0094_INSTALL_TARGET
endif

define FIRMWARE_BINARIES_480_0095_INSTALL_TARGET
	$(call install-firmware-func,$(STERLING-LWB5-JP))
endef
ifeq ($(BR2_FIRMWARE_BINARIES_480_0095),y)
	FIRMWARE_BINARIES_POST_INSTALL_TARGET_HOOKS += FIRMWARE_BINARIES_480_0095_INSTALL_TARGET
endif

define FIRMWARE_BINARIES_480_0116_INSTALL_TARGET
	$(call install-firmware-func,$(STERLING-LWB-JP))
endef
ifeq ($(BR2_FIRMWARE_BINARIES_480_0116),y)
	FIRMWARE_BINARIES_POST_INSTALL_TARGET_HOOKS += FIRMWARE_BINARIES_480_0116_INSTALL_TARGET
endif

define FIRMWARE_BINARIES_480_0108_INSTALL_TARGET
	rm $(@D)/lib -fr;
	test -f $(@D)/$(LWB-MFG)-*.zip && cd $(@D) && unzip -u $(LWB-MFG)-*.zip;
	cd $(@D) && tar -xjf laird-lwb-firmware-mfg-*.tar.bz2;
	cp $(@D)/lib/firmware/* $(TARGET_DIR)/lib/firmware/ -dprf;
endef
ifeq ($(BR2_FIRMWARE_BINARIES_480_0108),y)
	FIRMWARE_BINARIES_POST_INSTALL_TARGET_HOOKS += FIRMWARE_BINARIES_480_0108_INSTALL_TARGET
endif

define FIRMWARE_BINARIES_480_0109_INSTALL_TARGET
	rm $(@D)/lib -fr;
	test -f $(@D)/$(LWB5-MFG)-*.zip && cd $(@D) && unzip -u $(LWB5-MFG)-*.zip;
	cd $(@D) && tar -xjf laird-lwb5-firmware-mfg-*.tar.bz2;
	cp $(@D)/lib/firmware/* $(TARGET_DIR)/lib/firmware/ -dprf;
endef
ifeq ($(BR2_FIRMWARE_BINARIES_480_0109),y)
	FIRMWARE_BINARIES_POST_INSTALL_TARGET_HOOKS += FIRMWARE_BINARIES_480_0109_INSTALL_TARGET
endif

define FIRMWARE_BINARIES_930_0081_INSTALL_TARGET
	rm $(@D)/wl_fmac -fr
	test -f $(@D)/$(WL-FMAC)-*.zip && cd $(@D) && unzip -u $(WL-FMAC)-*.zip;
	cp $(@D)/wl_fmac $(TARGET_DIR)/usr/bin/ -f;
endef
ifeq ($(BR2_FIRMWARE_BINARIES_930_0081),y)
	FIRMWARE_BINARIES_POST_INSTALL_TARGET_HOOKS += FIRMWARE_BINARIES_930_0081_INSTALL_TARGET
endif

define FIRMWARE_BINARIES_STERLING_60_INSTALL_TARGET
	rm $(@D)/lib/ -fr;
	test -f $(@D)/$(LRD-MWL)-*.tar.bz2 && cd $(@D) && tar -xjf $(LRD-MWL)-*.tar.bz2;
	cp $(@D)/lib/firmware/* $(TARGET_DIR)/lib/firmware/ -dprf;
endef
ifeq ($(BR2_FIRMWARE_BINARIES_STERLING_60),y)
	FIRMWARE_BINARIES_POST_INSTALL_TARGET_HOOKS += FIRMWARE_BINARIES_STERLING_60_INSTALL_TARGET
endif

FIRMWARE_BINARIES_DEPENDENCIES += linux

$(eval $(generic-package))
