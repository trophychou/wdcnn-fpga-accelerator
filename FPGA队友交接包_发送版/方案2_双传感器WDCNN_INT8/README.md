# 8 kHz 双 WDCNN FPGA 联调包（原型版）

本包提供新方案专用的 HLS 顶层、C 仿真 testbench、量化参数和 golden vectors。原工程的单通道/四分类顶层不能直接使用本包的参数。

## 当前可验证范围

- 输入是已完成谱前处理、归一化并量化的特征张量：振动 `[5][5120]`、电流 `[2][5120]`，每个元素为有符号 INT8。
- 两个网络分别输出 `[3]` INT8 logits；类别顺序为健康、外圈、内圈。
- C 仿真逐项对比导出的整数 golden logits。
- 参数目录中的 `prototype_fold01/` 是五折评估中的第 1 折模型，仅用于硬件联调，不能称作全量训练部署模型。

## 还未包含在 HLS 顶层内

原始 8 kHz 波形到五通道/四通道谱特征的包络、FFT、相位/白化、归一化和输入量化，以及输出反量化、温度 softmax、条件融合门控，均由 FPGA 外部完成。`interface_contract.json` 固定了网络边界的数据格式。当前 HLS 工程可综合的是网络整数核，不代表完整端到端诊断链路已完成。

## 运行

在安装有 Vitis HLS 的环境中，进入 `hls/` 后运行：

```tcl
vitis_hls -f run_hls.tcl
```

`run_hls.tcl` 会执行 C 仿真、综合和 C/RTL 协同仿真。工具未安装时，可先用 `g++` 编译同一顶层和 testbench 做主机 C++ 对照；该检查不替代 HLS 或 RTL 仿真。目标暂按旧工程记录的 `xczu3eg-sbva484-1-i`、3.33 ns 设置，必须由队友用实际板卡型号和时钟确认。

在 Windows PowerShell 主机上先做文件校验和纯 C++ 对照：

```powershell
python ..\verify_handoff.py
g++ -O2 -std=c++11 wdcnn_dual_top.cpp testbench.cpp -o testbench.exe
.\testbench.exe ..\prototype_fold01
```

该 testbench 覆盖每支路 4 条量化输入，逐元素比对 INT8 logits；当前主机 C++ 编译结果为 24/24 logits bit-exact，记录于 `host_cpp_test_result.json`。`bundle_manifest.json` 锁定所有原型参数和 golden 文件的字节数及 SHA256。

顶层 `wdcnn_dual_top` 采用 AXI master 内存映射接口，输入、参数、输出各为独立指针，一次调用处理一条同步记录。首次调用或参数变化后将 `reload_weights=true`，后续同一组参数设为 `false`；核内静态 BRAM 缓存参数，复位后首次调用会自动装载。HLS 导出后还需按生成的 `component.xml`/驱动寄存器映射接 DMA；本包不预设物理引脚或软件寄存器地址。

## 量化算术

网络采用 signed W8A8；乘加 INT32；重缩放为 `INT64(acc * Q31_multiplier)`，半值远离零舍入，再饱和到 INT8。ReLU 在重缩放后执行；各卷积后做 2 点步长 2 最大池化。权重按 OIK/OI 的 C 顺序存储。不要与旧 HLS 工程的 `inc/shift` 加偏置顺序混用。`postprocess_contract.json` 给出 fold 01 训练侧选择的温度及电流门控参数；硬件核输出两支路 logits，融合仍需软件或后续 HLS 后处理实现。

## 接手前的待办

1. 运行 C 仿真、综合、协同仿真并保存日志；核实本机安装的 HLS 版本是否支持脚本命令。
2. 核对目标板料号和时钟，评估 LUT/DSP/BRAM、时序、延迟和内存带宽。
3. 确定定点化前处理与融合规则，并用端到端向量验证。
4. 训练并量化固定全量训练数据上的部署权重。当前 fold01 参数只适合接口联调。
5. 依据综合接口生成 DMA 驱动，核对缓存一致性、批次边界及错误状态。

因此本包把“可接入的 HLS 网络原型”落实下来，但在跑过真实 HLS 工具和目标板验收前，不应称为已上板或最终部署版。
