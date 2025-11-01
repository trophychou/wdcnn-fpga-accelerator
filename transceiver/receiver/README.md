# transceiver/receiver —— KV260 接收端

E573H（WS73）USB dongle 在 aarch64 上的完整链路：内核模块 → 固件下载 → `/dev/hwsle` → 用户态客户端。

| 目录 | 内容 |
|---|---|
| `driver/` | `plat_soc.ko`、`sle_soc.ko` 的源码子集（厂商 SDK 1.10.110） |
| `sdk_headers/` | 编驱动/客户端需要的头文件 |
| `firmware/` | dongle 固件 `ws73.bin` 等（USB 版本） |
| `build_config/` | Kconfig 默认配置与 `ws73_cfg.ini` 模板 |
| `client/` | SLE 用户态客户端（`sle_client.m8`），多连接 + 二进制落盘 |
| `pynq/` | 早期 PYNQ-Z1 方案脚本（存档） |

## 加载顺序

```bash
sudo insmod plat_soc.ko          # 打印 firmware_download_etc::succ! / ===BSP READY===
sleep 1
sudo insmod sle_soc.ko           # 生成 /dev/hwsle (10,120)
sudo pkill -f sle_client; rm -f sle_conf
sudo ./sle_client.m8 > sle.log 2>&1 &
```

## 环境要求

- 内核 5.15（Kria Ubuntu 22.04，`/lib/modules/$(uname -r)/build` 要有内核头）
- 固件路径要短（`/home/ubuntu/fw/`）：`FIRMWARE_BOARD_INFO_PARA_LEN = 50` 会静默截断长路径

## 文件

| 文件 | Last commit message |
|---|---|
| `build_config/` | 驱动编译配置与运行时 ini |
| `client/` | SLE 用户态多连接客户端 |
| `driver/` | WS73 内核驱动源码子集 |
| `firmware/` | dongle 固件（必须放短路径） |
| `pynq/` | 早期 PYNQ 方案脚本（存档） |
| `sdk_headers/` | 编译所需的 SDK 头文件 |
