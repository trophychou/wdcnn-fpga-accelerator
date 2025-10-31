# receiver/build_config —— 驱动配置


| 文件 | Last commit message |
|---|---|
| `ws73_cfg_default.ini` | 运行时参数模板（板上拷成 ws73_cfg.ini） |
| `ws73_default.config` | Kconfig 默认配置 |
| `ws73_light.config` | 裁剪配置：去掉 WiFi |
| `ws73_usb_light.config` | USB 轻量配置 |
| `ws73_usb_light_v2.config` | USB 轻量配置 v2 |

板上改过的关键项：`WSCFG_KERNEL_DIR=/lib/modules/5.15.0-1027-xilinx-zynqmp/build`、
`WSCFG_ARCH_NAME=arm64`、`WSCFG_BUS_USB=y`、`CONFIG_FIRMWARE_BIN_PATH=/home/ubuntu/fw/ws73.bin`。

缺 `ws73_cfg.ini` 时 `insmod` 会报 `plat_init_etc: fail`。