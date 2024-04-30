#!/bin/bash

# Add ImmortalWrt prepareCompile.sh
disablePkgsList="
./feeds/kenzo/luci-app-argon-config
./feeds/kenzo/luci-app-argone-config
./feeds/kenzo/luci-app-serverchan
./feeds/kenzo/luci-theme-argon
./feeds/kenzo/luci-theme-argone
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
fi
sed -i 's/192.168.1.1/192.168.86.1/g' package/base-files/files/bin/config_generate
