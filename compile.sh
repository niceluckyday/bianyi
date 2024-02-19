#!/bin/bash

# Clone the LEDE repository
git clone https://github.com/coolsnowwolf/lede

# Navigate into the LEDE directory
cd lede

# Add additional package source
sed -i '1i src-git haibo https://github.com/haiibo/openwrt-packages' feeds.conf.default

# Update and install feeds
./scripts/feeds update -a
./scripts/feeds install -a

# Modify default settings
sed -i "s#DISTRIB_REVISION='.*'#DISTRIB_REVISION='2023'#" package/lean/default-settings/files/zzz-default-settings
sed -i "s#DISTRIB_DESCRIPTION='.*'#DISTRIB_DESCRIPTION='Lucky8 '#" package/lean/default-settings/files/zzz-default-settings
sed -i 's/192.168.1.1/10.0.0.2/g' package/base-files/files/bin/config_generate

# Change Luci theme
sed -i 's/luci-theme-bootstrap/luci-theme-argon/' feeds/luci/collections/luci/Makefile

# Change kernel version
sed -i 's/KERNEL_PATCHVER:=6.1/KERNEL_PATCHVER:=6.6/g' ./target/linux/x86/Makefile

# Download configuration file
wget https://raw.githubusercontent.com/niceluckyday/bianyi/main/.config -O .config

# Start compilation
make download -j$(nproc)
make V=s -j$(nproc)

# Delete the script
rm -f "$(pwd)/$(basename "$0")"
