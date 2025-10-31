# FPGA/vivado —— Vivado 工程


`wd_k26.xpr`（板卡 `xilinx.com:kv260_som:part0:1.4`，器件 `xck26-sfvc784-2LV-c`）。

| 路径 | 内容 |
|---|---|
| `wd_k26.srcs/sources_1/bd/system/system.bd` | Block Design：PS + DMA + HLS IP + 2×SmartConnect + dwidth converter |
| `export/wd_k26.xsa` | 导出的硬件平台（含 bitstream） |
| `hwh/system.hwh` | 寄存器地址表（软件用的地址来源） |
| `reports/` | 实现后的利用率/时序/DRC 报告 |

## 地址

| 从设备 | 基址 |
|---|---|
| `axi_dma_0/S_AXI_LITE` | `0xA000_0000` |
| `synthesis_top_0/s_axi_control` | `0xA001_0000` |
| `synthesis_top_0/s_axi_control_r` | `0xA002_0000` |

DMA 的 `M_AXI_MM2S`/`M_AXI_S2MM` 与 HLS 的 `m_axi_gmem` 都挂到 `AXI HP0 FPD`（`HP0_DDR_LOW 0x0–2G`）。

## 重建

打开 `.xpr`（IP 仓库已被写成绝对路径，若目录变了要在 Settings → IP → Repository 重新指到
`FPGA/hls/hls_k26/synthesis_top/hls/impl/ip`）→ Reset Runs → 综合 → 实现 → 生成比特流 → Export Hardware。

## 文件

| 文件 | Last commit message |
|---|---|
| `export/` | 导出的硬件平台 |
| `hwh/` | `system.hwh` 副本（寄存器地址） |
| `reports/` | 实现后的利用率 / 时序 / DRC 报告 |
| `wd_k26.srcs/` | BD 源：`sources_1/bd/system/system.bd` 与各 IP 配置 |
| `wd_k26.xpr` | Vivado 工程：板卡 kv260_som、器件 xck26、IP 仓库 |
