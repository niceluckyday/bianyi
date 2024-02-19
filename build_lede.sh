#!/bin/bash

# 进入 lede 目录
cd lede || exit

# 拉取最新代码
git pull

# 更新软件包索引
./scripts/feeds update -a

# 安装所有软件包
./scripts/feeds install -a

# 使用默认配置
make defconfig

# 下载依赖的软件包
make download -j$(nproc)

# 编译 LEDE/OpenWrt，同时显示详细信息
make V=s -j$(nproc)
