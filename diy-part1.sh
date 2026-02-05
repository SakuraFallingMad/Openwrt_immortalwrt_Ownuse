#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#
# Copyright (c) 2019-2024 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#

# Uncomment a feed source
#sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

# Add a feed source
#echo 'src-git helloworld https://github.com/fw876/helloworld' >>feeds.conf.default
#echo 'src-git passwall https://github.com/xiaorouji/openwrt-passwall' >>feeds.conf.default

# Directories to search and patterns to match
disablePkgsList=(
    "feeds/pw"
    "feeds/packages"
)

# Function to disable packages using find
disableDuplicatedPkg() {
    local baseDir="$1"
    shift
    local patterns=("$@")

    for pattern in "${patterns[@]}"; do
        find "$baseDir" -type d -path "$baseDir/$pattern" -exec rm -rf {} +
        echo "Disabled packages matching pattern: $pattern in $baseDir"
    done
}

# Patterns for each directory
pwPatterns=(
    "*sing*"
    "naiveproxy"
)

packagesPatterns=(
    "net/*v2ray-*"
    "net/*xray*"
    "net/hysteria"
)

# Update repository and feeds
git pull
./scripts/feeds update -f

# Disable specified packages
disableDuplicatedPkg "feeds/pw" "${pwPatterns[@]}"
disableDuplicatedPkg "feeds/packages" "${packagesPatterns[@]}"

# Install feeds
./scripts/feeds update -i
./scripts/feeds install -a

# Check and create .config if missing
if [ ! -f .config ]; then
    cp myconfig .config
    echo "Default .config created."
fi
