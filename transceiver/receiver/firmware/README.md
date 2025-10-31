# receiver/firmware —— dongle 固件


WS73 USB 版本固件，`plat_soc.ko` 加载时由驱动下载进 dongle：

| 文件 | Last commit message |
|---|---|
| `btc_cali.bin` | 蓝牙校准数据 7,772 B |
| `wifi_cali.bin` | WiFi 校准数据 21,044 B |
| `wow.bin` | 低功耗唤醒固件 22,859 B |
| `ws73.bin` | dongle 主固件 143,956 B |

必须放在**短路径**（如 `/home/ubuntu/fw/`）：固件路径被编进 `plat_soc.ko` 的命令串，
`FIRMWARE_BOARD_INFO_PARA_LEN = 50` 超长会静默截断，现象是 `filp_open [.../ws73.b] fail!!`。

加载成功的标志：`sha256sum check succ!` ×3 → `firmware_download_etc::succ!` → `===BSP READY===`。