# FPGA —— K26 硬件与板上运行时

| 目录 | 内容 |
|---|---|
| `hls/` | WDCNN 加速器 C++ 源码、数据集、int8 权重 CSV、Vitis HLS 工作区（含导出 IP） |
| `vivado/` | Block Design、XSA、实现报告（`.xpr` 打开即可重建） |
| `sw/` | 板上运行时：位流、权重、`wdmem` 内核模块、开自启脚本、推理脚本 |
| `docs/` | 重建步骤 |

## 硬件结构

```
PS(ddr) ── AXI HP0 ── SmartConnect ──┬─ AXI DMA (MM2S/S2MM, 32 bit, 无 SG)
                                     └─ HLS synthesis_top (m_axi_gmem + AXIS in/out)
AXI-Lite: DMA 0xA0000000 | s_axi_control 0xA0010000 | s_axi_control_r 0xA0020000
```

ZynqMP 的 PL 从设备必须放在 `0xA000_0000` 以上；`0x4000_0000` 在 ZynqMP 上是 DDR，不能给 PL 用。

## 性能

单窗 5120 点 @100 MHz：**0.84 ms**（首窗 9.7 ms，含权重加载）；实现资源 LUT 21,721（18.55%）。

## 文件

| 文件 | Last commit message |
|---|---|
| `docs/` | 从零重建硬件的步骤 |
| `hls/` | WDCNN 加速器的 HLS 工程 |
| `sw/` | 板上运行时：位流、权重、内核模块、推理脚本 |
| `vivado/` | Block Design、XSA 与实现报告 |
