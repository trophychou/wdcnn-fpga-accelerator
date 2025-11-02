# FPGA/hls —— WDCNN 加速器（Vitis HLS）

| 目录 | 内容 |
|---|---|
| `src/` | 顶层 `synthesis_top` 与 `hw_lib/` 组件 |
| `data/` | 3 个 CSV（5121 列 = 5120 特征 + 标签），csim 与离线验证用 |
| `weights_csv/` | 7 层 int8 权重/偏置 CSV |
| `hls_k26/` | Vitis HLS 2025.2 工作区：`hls_config.cfg`、导出 IP（`impl/ip`）、综合报告 |

参数：`AXI_WIDTH_IN=512`、`AXI_WIDTH_OUT=32`、`INPUT_ELEMS=5120`、part `xck26-sfvc784-2LV-c`、时钟 10 ns。

综合估算 LUT 47,070（40%）比实现后（21,721）虚高约 2.5 倍——以 Vivado 实现报告为准。

## 文件

| 文件 | Last commit message |
|---|---|
| `data/` | csim 用的 3 个数据集 CSV |
| `hls_k26/` | Vitis HLS 工作区（含导出 IP 与综合报告） |
| `src/` | 加速器 C++ 源码与组件库 |
| `weights_csv/` | 7 层 int8 权重/偏置 CSV |
