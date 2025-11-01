# transceiver —— 星闪收发链路

从 7–8 个 ws63 发送端（小熊派 H3863）经 SLE 无线送到 KV260 上的 E573H USB dongle，再由板上的驱动与
用户态客户端把数据落盘给推理脚本。

| 目录 | 内容 |
|---|---|
| `sender/` | ws63 侧：合成波形固件源码、8 份 `.fwpkg`、编译与波形生成工具 |
| `receiver/` | KV260 侧：`plat_soc.ko`/`sle_soc.ko` 源码子集、固件、SLE 客户端、旧 PYNQ 脚本 |
| `pynq/` | （在 `receiver/pynq`）早期 PYNQ-Z1 方案收到的 CSV 记录脚本，仅存档 |

## 协议

- 发送端每窗 32 包，每包 160 点 int8，包头 8 字节
- 接收端按包头 `dev` 字节分路，每 32 包拼成一窗送加速器
- 接收端每 2 s 回写 1 字节心跳；发送端 15 s 收不到就主动断链重新广播（自愈）

## 已知限制

单 dongle 同时连 7 台时，实测空中吞吐约 90 包/s（需求 350 包/s），断链原因多为
`SLE_ERR_CONN_TIMEOUT`；RSSI 实测 -38…-53 dBm，不是距离问题。

## 文件

| 文件 | Last commit message |
|---|---|
| `receiver/` | KV260 侧：驱动、固件、客户端 |
| `sender/` | ws63 侧：固件源码、8 份 fwpkg、工具 |
