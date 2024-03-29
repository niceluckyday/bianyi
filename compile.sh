#!/bin/bash

# Clone the LEDE repository, navigate into it, and execute subsequent commands
git clone https://github.com/coolsnowwolf/lede && \
cd lede && \

# Add additional package source
sed -i '$a src-git kenzo https://github.com/kenzok8/openwrt-packages' feeds.conf.default && \
sed -i '$a src-git small https://github.com/kenzok8/small' feeds.conf.default && \

# Update and install feeds
./scripts/feeds update -a && \
./scripts/feeds install -a && \

# Modify default settings
sed -i "s#DISTRIB_REVISION='.*'#DISTRIB_REVISION='\$(TZ=UTC-8 date \"+%Y.%m.%d\")'#" package/lean/default-settings/files/zzz-default-settings && \
sed -i "s#DISTRIB_DESCRIPTION='.*'#DISTRIB_DESCRIPTION='Lucky '#" package/lean/default-settings/files/zzz-default-settings && \
sed -i 's/192.168.1.1/10.0.0.2/g' package/base-files/files/bin/config_generate && \

# Change Luci theme
sed -i 's/luci-theme-bootstrap/luci-theme-argone/' feeds/luci/collections/luci/Makefile && \

# Change kernel version
# sed -i 's/KERNEL_PATCHVER:=6.1/KERNEL_PATCHVER:=6.6/g' ./target/linux/x86/Makefile && \

# Generate .config file non-interactively
make defconfig && \

# Copy your custom .config file
wget https://raw.githubusercontent.com/niceluckyday/bianyi/main/.config -O .config && \

# Start compilation
make download -j$(nproc) && \
make V=s -j$(nproc)
