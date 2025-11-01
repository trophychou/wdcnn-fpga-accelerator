#!/bin/sh
cd $HOME/sw/ws73 || exit 1
CFG=my_k26.config
KREL=$(uname -r)
cp -f build/config/ws73_default.config $CFG || exit 1
sed -i \
 -e 's|^WSCFG_CROSS_COMPILE=.*|WSCFG_CROSS_COMPILE=""|' \
 -e "s|^WSCFG_KERNEL_DIR=.*|WSCFG_KERNEL_DIR=\"/lib/modules/$KREL/build\"|" \
 -e 's|^WSCFG_ARCH_NAME=.*|WSCFG_ARCH_NAME="arm64"|' \
 -e 's|^WSCFG_BUS_SDIO=y|# WSCFG_BUS_SDIO is not set|' \
 -e 's|^# WSCFG_BUS_USB is not set|WSCFG_BUS_USB=y|' \
 -e 's|^_PRE_PLAT_HCC_SDIO=y|_PRE_PLAT_HCC_USB=y|' \
 -e 's|^CONFIG_HCC_SDIO_SUPPORT_SCATTER=y|# CONFIG_HCC_SDIO_SUPPORT_SCATTER is not set|' \
 -e 's|^CONFIG_SDIO_RESCAN=y|# CONFIG_SDIO_RESCAN is not set|' \
 -e 's|^CONFIG_FIRMWARE_BIN_PATH=.*|CONFIG_FIRMWARE_BIN_PATH="/home/ubuntu/sw/ws73/firmware/ws73.bin"|' \
 -e 's|^CONFIG_FIRMWARE_WIFICALI_PATH=.*|CONFIG_FIRMWARE_WIFICALI_PATH="/home/ubuntu/sw/ws73/firmware/wifi_cali.bin"|' \
 -e 's|^CONFIG_FIRMWARE_BSLECALI_PATH=.*|CONFIG_FIRMWARE_BSLECALI_PATH="/home/ubuntu/sw/ws73/firmware/btc_cali.bin"|' \
 -e 's|^CONFIG_FIRMWARE_WOW_PATH=.*|CONFIG_FIRMWARE_WOW_PATH="/home/ubuntu/sw/ws73/firmware/wow.bin"|' \
 -e 's|^CONFIG_INI_FILE_PATH=.*|CONFIG_INI_FILE_PATH="/home/ubuntu/sw/ws73/ws73_cfg.ini"|' \
 $CFG
echo "=== config:"
grep -E 'KERNEL_DIR|ARCH_NAME|BUS_|_PRE_PLAT_HCC|FIRMWARE_BIN' $CFG
echo "=== firmware:"
ls -l firmware/ 2>/dev/null | head
echo "=== python3/make/gcc:"
which python3 make gcc
echo "=== start build:"
cd driver/platform
make -j4 WSCFG_KCONFIG_CONFIG=$HOME/sw/ws73/my_k26.config DIR_MAP_CONFIG_FILE=release.mk > /tmp/build_plat.log 2>&1
echo "RC=$?"
tail -25 /tmp/build_plat.log
ls -l plat_soc.ko 2>/dev/null
echo BUILD_DONE
