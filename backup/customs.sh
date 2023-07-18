#!/bin/bash

# Add ImmortalWrt prepareCompile.sh
disablePkgsList="
./feeds/kenzo/luci-app-argon-config
./feeds/kenzo/luci-app-argonne-config
./feeds/kenzo/luci-app-serverchan
./feeds/kenzo/luci-theme-argon
./feeds/kenzo/luci-theme-argonne
"

function disableDulicatedPkg()
{
	if [ -d $1 ];then
		rm -rf $1
		echo $1" Disabled."
	fi
}

git pull
./scripts/feeds update -a

for disablePkg in $disablePkgsList
do
	disableDulicatedPkg $disablePkg
done

./scripts/feeds update -i
./scripts/feeds install -a

if [ ! -f .config ];then
cp myconfig .config
echo "Default .config created."
make defconfig
fi
