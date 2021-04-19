BASE64_VERSION = master
BASE64_SITE = $(call github,stretchdude,base64,$(BASE64_VERSION))
BASE64_LICENSE =  GPL
BASE64_LICENSE_FILES = LICENSE
BASE64_INSTALL_STAGING = YES
BASE64_INSTALL_TARGET = NO


define BASE64_INSTALL_STAGING_CMDS
       $(INSTALL) -D -m 755 $(@D)/base64.h $(STAGING_DIR)/usr/include
endef


#header only -> needs no build
#$(eval $(autotools-package))
$(eval $(generic-package))

