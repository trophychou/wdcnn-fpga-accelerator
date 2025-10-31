# receiver/pynq —— 早期 PYNQ 方案（存档）


`recv_csv.py`：在 PYNQ-Z1 上从 `sclient` 的串口输出里解析十六进制包、拼窗、写 CSV 的脚本。

现在的主力方案已换成 KV260 + aarch64 驱动 + `client/sle_client.m8`（二进制落盘，吞吐高一个数量级）。
保留此文件只为对照旧协议与旧调试方式。

## 文件

| 文件 | Last commit message |
|---|---|
| `.gitignore` | 忽略日志与产物 |
| `recv_csv.py` | 旧 PYNQ 方案：解析十六进制包写 CSV |
