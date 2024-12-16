#!/bin/bash

# Directories to search and patterns to match
disablePkgsList=(
    "feeds/small"
)

# Function to disable packages using find
disableDuplicatedPkg() {
    local baseDir="$1"
    shift
    local patterns=("$@")

    for pattern in "${patterns[@]}"; do
        find "$baseDir" -type d -name "$pattern" -exec rm -rf {} +
        echo "Disabled packages matching pattern: $pattern in $baseDir"
    done
}

# Patterns for each directory
smallPatterns=(
    "*mosdns*"
    "*xray*"
    "*v2ray*"
    "*sing*"
)

# Update repository and feeds
git pull
./scripts/feeds update -a

# Disable specified packages
disableDuplicatedPkg "feeds/small" "${smallPatterns[@]}"

# Install feeds
./scripts/feeds update -i
./scripts/feeds install -a

# Check and create .config if missing
if [ ! -f .config ]; then
    cp myconfig .config
    echo "Default .config created."
fi

# Update default IP address
sed -i 's/192.168.1.1/192.168.86.1/g' package/base-files/files/bin/config_generate
