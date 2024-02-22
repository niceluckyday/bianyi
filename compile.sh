#!/bin/bash

# Clone the LEDE repository, navigate into it, and execute subsequent commands

git clone https://github.com/coolsnowwolf/lede && \
cd lede && \

# Add additional package source

echo "src-git passwall_packages https://github.com/xiaorouji/openwrt-passwall-packages.git;main" >> "feeds.conf.default"
echo "src-git passwall https://github.com/xiaorouji/openwrt-passwall.git;main" >> "feeds.conf.default"
echo "src-git passwall2 https://github.com/xiaorouji/openwrt-passwall2.git;main" >> "feeds.conf.default" && \

# Update and install feeds

./scripts/feeds update -a && \
./scripts/feeds install -a && \

# Modify default settings

sed -i "s#DISTRIB_REVISION='.*'#DISTRIB_REVISION='\$(TZ=UTC-8 date \"+%Y.%m.%d\")'#" package/lean/default-settings/files/zzz-default-settings && \
sed -i "s#DISTRIB_DESCRIPTION='.*'#DISTRIB_DESCRIPTION='Lucky '#" package/lean/default-settings/files/zzz-default-settings && \
sed -i 's/192.168.1.1/10.0.0.2/g' package/base-files/files/bin/config_generate && \

# Change Luci theme

sed -i 's/luci-theme-bootstrap/luci-theme-argon/' feeds/luci/collections/luci/Makefile && \

# Add Luci theme compilation package

cd package/lean
rm -rf luci-theme-argon
git clone -b 18.06 https://github.com/jerrykuku/luci-theme-argon.git luci-theme-argon && \

# Add Luci theme settings package

rm -rf luci-app-argon-config # if it exists
git clone -b 18.06 https://github.com/jerrykuku/luci-app-argon-config.git luci-app-argon-config && \

# Change kernel version

# sed -i 's/KERNEL_PATCHVER:=6.1/KERNEL_PATCHVER:=6.6/g' ./target/linux/x86/Makefile && \

# Generate .config file non-interactively

make defconfig && \
