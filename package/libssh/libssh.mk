################################################################################
#
# libssh
#
################################################################################

LIBSSH_VERSION_MAJOR = 0.8
LIBSSH_VERSION = $(LIBSSH_VERSION_MAJOR).1
LIBSSH_SOURCE = libssh-$(LIBSSH_VERSION).tar.xz
LIBSSH_SITE = https://www.libssh.org/files/$(LIBSSH_VERSION_MAJOR)
LIBSSH_LICENSE = LGPL-2.1
LIBSSH_LICENSE_FILES = COPYING
LIBSSH_INSTALL_STAGING = YES
LIBSSH_SUPPORTS_IN_SOURCE_BUILD = NO
LIBSSH_CONF_OPTS = \
	-DWITH_STACK_PROTECTOR=OFF \
	-DWITH_SERVER=ON \
	-DWITH_EXAMPLES=OFF

ifeq ($(BR2_PACKAGE_ZLIB),y)
LIBSSH_CONF_OPTS += -DWITH_ZLIB=ON
LIBSSH_DEPENDENCIES += zlib
else
LIBSSH_CONF_OPTS += -DWITH_ZLIB=OFF
endif

# Dependency is either on libgcrypt or openssl, guaranteed in Config.in.
# Favour libgcrypt.
ifeq ($(BR2_PACKAGE_LIBGCRYPT),y)
LIBSSH_CONF_OPTS += -DWITH_GCRYPT=ON
LIBSSH_DEPENDENCIES += libgcrypt
else
LIBSSH_CONF_OPTS += -DWITH_GCRYPT=OFF
LIBSSH_DEPENDENCIES += openssl
endif

$(eval $(cmake-package))
