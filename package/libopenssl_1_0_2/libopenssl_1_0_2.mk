################################################################################
#
# libopenssl-1.0.2
#
################################################################################

LAIRD_OPENSSL_FIPS_BINARIES_CVE_PRODUCT = libopenssl
LAIRD_OPENSSL_FIPS_BINARIES_CVE_VERSION = 1.0.2u

#0004-Fix-for-OpenSSL-1.0.2-CVE-2020-1968-from-Debian.patch
LAIRD_OPENSSL_FIPS_BINARIES_IGNORE_CVES += CVE-2020-1968

# 0005-Add-a-test-for-GENERAL_NAME_cmp.patch
# 0006-Check-that-multi-strings-CHOICE-types-don-t-use-implicit-.patch
# 0007-Complain-if-we-are-attempting-to-encode-with-an-invalid-A.patch
# 0008-Correctly-compare-EdiPartyName-in-GENERAL_NAME_cmp.patch
# 0009-DirectoryString-is-a-CHOICE-type-and-therefore-uses-expli.patch
LAIRD_OPENSSL_FIPS_BINARIES_IGNORE_CVES += CVE-2020-1971

# 0010-CVE-2021-23840.patch
LAIRD_OPENSSL_FIPS_BINARIES_IGNORE_CVES += CVE-2021-23840

# 0011-CVE-2021-23841.patch
LAIRD_OPENSSL_FIPS_BINARIES_IGNORE_CVES += CVE-2021-23841

ifeq ($(BR2_PACKAGE_LAIRD_OPENSSL_FIPS),y)
# building from closed source git repository
LIBOPENSSL_1_0_2_VERSION = local
LIBOPENSSL_1_0_2_SITE = package/lrd-closed-source/externals/lairdssl_1_0_2
LIBOPENSSL_1_0_2_SITE_METHOD = local
else
LIBOPENSSL_1_0_2_VERSION = 1.0.2u
LIBOPENSSL_1_0_2_SITE = http://www.openssl.org/source
LIBOPENSSL_1_0_2_SOURCE = openssl-$(LIBOPENSSL_1_0_2_VERSION).tar.gz
endif

LIBOPENSSL_1_0_2_LICENSE = OpenSSL or SSLeay
LIBOPENSSL_1_0_2_LICENSE_FILES = LICENSE
LIBOPENSSL_1_0_2_INSTALL_STAGING = YES
LIBOPENSSL_1_0_2_DEPENDENCIES = zlib
HOST_LIBOPENSSL_1_0_2_DEPENDENCIES = host-zlib
LIBOPENSSL_1_0_2_TARGET_ARCH = generic32
LIBOPENSSL_1_0_2_CFLAGS = $(TARGET_CFLAGS)
LIBOPENSSL_1_0_2_PROVIDES = openssl

# require openssl-fips built firstly
ifneq ($(BR2_PACKAGE_OPENSSL_FIPS),)
LIBOPENSSL_1_0_2_DEPENDENCIES += openssl-fips
LIBOPENSSL_1_0_2_FIPS_CFG = fips
LIBOPENSSL_1_0_2_FIPS_OPT = FIPSDIR=$(STAGING_DIR)/usr/local/ssl/fips-2.0 \
                   FIPS_SIG=$(STAGING_DIR)/usr/local/ssl/fips-2.0/bin/incore
LIBOPENSSL_1_0_2_FIPS_MAKE_OPT = FIPS_SIG=$(STAGING_DIR)/usr/local/ssl/fips-2.0/bin/incore
endif

LIBOPENSSL_1_0_2_PATCH = \
	https://gitweb.gentoo.org/repo/gentoo.git/plain/dev-libs/openssl/files/openssl-1.0.2d-parallel-build.patch?id=c8abcbe8de5d3b6cdd68c162f398c011ff6e2d9d \
	https://gitweb.gentoo.org/repo/gentoo.git/plain/dev-libs/openssl/files/openssl-1.0.2a-parallel-obj-headers.patch?id=c8abcbe8de5d3b6cdd68c162f398c011ff6e2d9d \
	https://gitweb.gentoo.org/repo/gentoo.git/plain/dev-libs/openssl/files/openssl-1.0.2a-parallel-install-dirs.patch?id=c8abcbe8de5d3b6cdd68c162f398c011ff6e2d9d \
	https://gitweb.gentoo.org/repo/gentoo.git/plain/dev-libs/openssl/files/openssl-1.0.2a-parallel-symlinking.patch?id=c8abcbe8de5d3b6cdd68c162f398c011ff6e2d9d

# relocation truncated to fit: R_68K_GOT16O
ifeq ($(BR2_m68k_cf),y)
LIBOPENSSL_1_0_2_CFLAGS += -mxgot
endif

ifeq ($(BR2_USE_MMU),)
LIBOPENSSL_1_0_2_CFLAGS += -DHAVE_FORK=0
endif

ifeq ($(BR2_PACKAGE_HAS_CRYPTODEV),y)
LIBOPENSSL_1_0_2_CFLAGS += -DHAVE_CRYPTODEV -DUSE_CRYPTODEV_DIGESTS
LIBOPENSSL_1_0_2_DEPENDENCIES += cryptodev
endif

# Some architectures are optimized in OpenSSL
# Doesn't work for thumb-only (Cortex-M?)
ifeq ($(BR2_ARM_CPU_HAS_ARM),y)
LIBOPENSSL_1_0_2_TARGET_ARCH = armv4
endif
ifeq ($(ARCH),aarch64)
LIBOPENSSL_1_0_2_TARGET_ARCH = aarch64
endif
ifeq ($(ARCH),powerpc)
# 4xx cores seem to have trouble with openssl's ASM optimizations
ifeq ($(BR2_powerpc_401)$(BR2_powerpc_403)$(BR2_powerpc_405)$(BR2_powerpc_405fp)$(BR2_powerpc_440)$(BR2_powerpc_440fp),)
LIBOPENSSL_1_0_2_TARGET_ARCH = ppc
endif
endif
ifeq ($(ARCH),powerpc64)
LIBOPENSSL_1_0_2_TARGET_ARCH = ppc64
endif
ifeq ($(ARCH),powerpc64le)
LIBOPENSSL_1_0_2_TARGET_ARCH = ppc64le
endif
ifeq ($(ARCH),x86_64)
LIBOPENSSL_1_0_2_TARGET_ARCH = x86_64
endif

define HOST_LIBOPENSSL_1_0_2_CONFIGURE_CMDS
	(cd $(@D); \
		$(HOST_CONFIGURE_OPTS) \
		./config \
		--prefix=$(HOST_DIR) \
		--openssldir=$(HOST_DIR)/etc/ssl \
		--libdir=/lib \
		shared \
		zlib-dynamic \
	)
	$(SED) "s#-O[0-9]#$(HOST_CFLAGS)#" $(@D)/Makefile
endef

ifeq ($(BR2_PACKAGE_LAIRD_OPENSSL_FIPS),y)
LIBOPENSSL_1_0_2_DEVRANDOM = '"/dev/hwrng"'
else
LIBOPENSSL_1_0_2_DEVRANDOM = '"/dev/hwrng","/dev/urandom"'
endif

define LIBOPENSSL_1_0_2_CONFIGURE_CMDS
	(cd $(@D); \
		$(TARGET_CONFIGURE_ARGS) \
		$(TARGET_CONFIGURE_OPTS) \
		$(LIBOPENSSL_1_0_2_FIPS_OPT) \
		./Configure \
			linux-$(LIBOPENSSL_1_0_2_TARGET_ARCH) \
			--prefix=/usr \
			--openssldir=/etc/ssl \
			--libdir=/lib \
			$(if $(BR2_TOOLCHAIN_HAS_THREADS),threads,no-threads) \
			$(if $(BR2_STATIC_LIBS),no-shared,shared) \
			no-rc5 \
			enable-camellia \
			enable-mdc2 \
			enable-tlsext \
			$(if $(BR2_STATIC_LIBS),zlib,zlib-dynamic) \
			$(if $(BR2_STATIC_LIBS),no-dso) \
			$(LIBOPENSSL_1_0_2_FIPS_CFG) \
			-DDEVRANDOM=$(LIBOPENSSL_1_0_2_DEVRANDOM) \
	)
	$(SED) "s#-march=[-a-z0-9] ##" -e "s#-mcpu=[-a-z0-9] ##g" $(@D)/Makefile
	$(SED) "s#-O[0-9]#$(LIBOPENSSL_1_0_2_CFLAGS)#" $(@D)/Makefile
	$(SED) "s# build_tests##" $(@D)/Makefile
endef

# libdl is not available in a static build, and this is not implied by no-dso
ifeq ($(BR2_STATIC_LIBS),y)
define LIBOPENSSL_1_0_2_FIXUP_STATIC_MAKEFILE
	$(SED) 's#-ldl##g' $(@D)/Makefile
endef
LIBOPENSSL_1_0_2_POST_CONFIGURE_HOOKS += LIBOPENSSL_1_0_2_FIXUP_STATIC_MAKEFILE
endif

define HOST_LIBOPENSSL_1_0_2_BUILD_CMDS
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D)
endef

define LIBOPENSSL_1_0_2_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(LIBOPENSSL_1_0_2_FIPS_MAKE_OPT) -C $(@D)
endef

define LIBOPENSSL_1_0_2_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) INSTALL_PREFIX=$(STAGING_DIR) install
endef

define HOST_LIBOPENSSL_1_0_2_INSTALL_CMDS
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D) install
endef

define LIBOPENSSL_1_0_2_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) INSTALL_PREFIX=$(TARGET_DIR) install
	rm -rf $(TARGET_DIR)/usr/lib/ssl
	rm -f $(TARGET_DIR)/usr/bin/c_rehash
endef

# libdl has no business in a static build
ifeq ($(BR2_STATIC_LIBS),y)
define LIBOPENSSL_1_0_2_FIXUP_STATIC_PKGCONFIG
	$(SED) 's#-ldl##' $(STAGING_DIR)/usr/lib/pkgconfig/libcrypto.pc
	$(SED) 's#-ldl##' $(STAGING_DIR)/usr/lib/pkgconfig/libssl.pc
	$(SED) 's#-ldl##' $(STAGING_DIR)/usr/lib/pkgconfig/openssl.pc
endef
LIBOPENSSL_1_0_2_POST_INSTALL_STAGING_HOOKS += LIBOPENSSL_1_0_2_FIXUP_STATIC_PKGCONFIG
endif

ifneq ($(BR2_STATIC_LIBS),y)
# libraries gets installed read only, so strip fails
define LIBOPENSSL_1_0_2_INSTALL_FIXUPS_SHARED
	chmod +w $(TARGET_DIR)/usr/lib/engines/lib*.so
	for i in $(addprefix $(TARGET_DIR)/usr/lib/,libcrypto.so.* libssl.so.*); \
	do chmod +w $$i; done
endef
LIBOPENSSL_1_0_2_POST_INSTALL_TARGET_HOOKS += LIBOPENSSL_1_0_2_INSTALL_FIXUPS_SHARED
endif

ifeq ($(BR2_PACKAGE_PERL),)
define LIBOPENSSL_1_0_2_REMOVE_PERL_SCRIPTS
	$(RM) -f $(TARGET_DIR)/etc/ssl/misc/{CA.pl,tsget}
endef
LIBOPENSSL_1_0_2_POST_INSTALL_TARGET_HOOKS += LIBOPENSSL_1_0_2_REMOVE_PERL_SCRIPTS
endif

ifeq ($(BR2_PACKAGE_LIBOPENSSL_BIN),)
define LIBOPENSSL_1_0_2_REMOVE_BIN
	$(RM) -f $(TARGET_DIR)/usr/bin/openssl
	$(RM) -f $(TARGET_DIR)/etc/ssl/misc/{CA.*,c_*}
endef
LIBOPENSSL_1_0_2_POST_INSTALL_TARGET_HOOKS += LIBOPENSSL_1_0_2_REMOVE_BIN
endif

ifneq ($(BR2_PACKAGE_LIBOPENSSL_1_0_2_ENGINES),y)
define LIBOPENSSL_1_0_2_REMOVE_LIBOPENSSL_1_0_2_ENGINES
	rm -rf $(TARGET_DIR)/usr/lib/engines
endef
LIBOPENSSL_1_0_2_POST_INSTALL_TARGET_HOOKS += LIBOPENSSL_1_0_2_REMOVE_LIBOPENSSL_1_0_2_ENGINES
endif

$(eval $(generic-package))
$(eval $(host-generic-package))
