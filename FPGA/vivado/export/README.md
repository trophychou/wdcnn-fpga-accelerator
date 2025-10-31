# vivado/wd_k26/export —— 导出的硬件平台


`wd_k26.xsa`（2.1 MB）：`File → Export → Export Hardware` 生成，包含**实现后的 bitstream 描述**。

用途：

- 给 Vitis 建平台/应用（本工程实际没用 Vitis 应用，裸机那条路在 7020 上走过）
- 归档硬件配置：`.xsa` 里含 `.hwh`（寄存器地址表），板上 `wd_bench.py` 用的寄存器偏移就是从
  `.hwh` 与 `synthesis_top_control_s_axi.v` 反查出来的

## 文件

| 文件 | Last commit message |
|---|---|
| `wd_k26.xsa` | 导出的硬件平台（含 bitstream），Vitis/PYNQ 用 |
