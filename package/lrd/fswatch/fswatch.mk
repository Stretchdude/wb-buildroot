#############################################################
#
# Laird Filesystem Monitor
#
#############################################################

FSWATCH_VERSION = v1.0
FSWATCH_SITE = http://github.com/LairdCP/fs_watch/tarball/$(FSWATCH_VERSION)
FSWATCH_DEPENDENCIES = inotify-tools
FSWATCH_LICENSE = GPL
FSWATCH_LICENSE_FILES = COPYING

FSWATCH_MAKE_ENV = CC="$(TARGET_CC)" \
                    CXX="$(TARGET_CXX)" \
                    ARCH="$(KERNEL_ARCH)" \
                    CFLAGS="$(TARGET_CFLAGS) -I $(STAGING_DIR)/usr/include -L $(STAGING_DIR)/usr/lib"

define FSWATCH_BUILD_CMDS
    $(MAKE) -C $(@D) clean
	$(FSWATCH_MAKE_ENV) $(MAKE) -C $(@D)
endef

define FSWATCH_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 755 $(@D)/fs_watch $(TARGET_DIR)/usr/bin/fs_watch
endef

define FSWATCH_UNINSTALL_TARGET_CMDS
	rm -f $(TARGET_DIR)/usr/bin/fs_watch
endef

define FSWATCH_INSTALL_INITSCRIPT
	$(INSTALL) -D -m 755 package/lrd/fswatch/S03fs_watch $(TARGET_DIR)/etc/init.d/S03fs_watch
endef

FSWATCH_POST_INSTALL_TARGET_HOOKS += FSWATCH_INSTALL_INITSCRIPT

$(eval $(generic-package))
