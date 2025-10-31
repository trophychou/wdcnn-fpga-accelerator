# FPGA/hls/hls_k26 —— Vitis HLS 工作区


| 路径 | 内容 |
|---|---|
| `hls_config.cfg` | 组件配置：源文件、top `synthesis_top`、part、10 ns、`package.output.format=ip_catalog` |
| `synthesis_top/hls/impl/ip/` | **导出的 IP**（`component.xml` + RTL + 约束），Vivado 的 IP 仓库指向这里 |
| `synthesis_top/hls/syn/report/` | 综合报告（`synthesis_top_csynth.rpt`：7.300 ns、LUT 47,070） |
| `synthesis_top/reports/`、`logs/` | 组件级摘要与日志 |

重跑：Vitis Unified IDE 打开本目录 → 组件 `synthesis_top` → C Synthesis → EXPORT RTL。
csim/syn 的中间产物（`.autopilot`、`csim/build`）没有入库，需要时重新生成。

## 文件

| 文件 | Last commit message |
|---|---|
| `synthesis_top/` | 组件产物：`hls/impl/ip`（导出 IP）、`hls/syn/report`、logs |
| `hls_config.cfg` | HLS 组件配置：源文件、top、part、10 ns、ip_catalog |
