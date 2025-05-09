#!/bin/bash

# Directories to search and patterns to match
disablePkgsList=(
    "feeds/pw"
    "feeds/packages"
    "feeds/luci"
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
    "*v2ray*"
    "*sing*"
    "naiveproxy"
)

packagesPatterns=(
    "net/*xray*"
)

luciPatterns=(
    "applications/*argon*"
    "themes/*argon*"
)

# Update repository and feeds
git pull
./scripts/feeds update -a

# Disable specified packages
disableDuplicatedPkg "feeds/pw" "${pwPatterns[@]}"
disableDuplicatedPkg "feeds/packages" "${packagesPatterns[@]}"
disableDuplicatedPkg "feeds/luci" "${luciPatterns[@]}"

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
