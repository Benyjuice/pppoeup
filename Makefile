# Copyright (C) 2011 Manuel Munz <freifunk at somakoma de>
# This is free software, licensed under the Apache 2.0 license.

include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-pppoeup
PKG_RELEASE:=1

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/luci-app-pppoeup
  SECTION:=luci
  CATEGORY:=LuCI
  SUBMENU:=pppoeup
  TITLE:=pppoeup
endef

define Package/freifunk-common/description
  PPPoE Up.
endef

define Package/luci-mod-freifunk/conffiles
/etc/config/pppoeup
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/freifunk-common/install
	$(CP) ./files/* $(1)/
endef

$(eval $(call BuildPackage,luci-app-pppoeup))
