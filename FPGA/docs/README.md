# FPGA/docs —— 重建与说明

本目录收录从零重建这套硬件所需的最小步骤（HLS → Vivado → 板端）。

## HLS

1. Vitis Unified IDE → Set Workspace 到 `FPGA/hls` → New HLS Component（Empty File，名字 `hls_k26`）
2. Design Files：`src/synthesis_top.cpp` + `src/hw_lib/*.hpp`；Top `synthesis_top`；Testbench `src/testbench.cpp`
   CFLAGS（Flags common to all files）填 `-IFPGA/hls/src`
3. Hardware：`xck26-sfvc784-2LV-c`，Clock 10 ns；Settings：`flow_target=vivado`、`package.output.format=ip_catalog`
4. C Simulation → C Synthesis → EXPORT RTL（产物落到 `hls_k26/synthesis_top/hls/impl/ip`）

## Vivado

1. 打开 `FPGA/vivado/wd_k26.xpr`，确认 IP Repository 指向上面的 `impl/ip`
2. Block Design `system` 保持现有连线；Validate → 生成 wrapper
3. Run Synthesis → Implementation → Generate Bitstream
4. bootgen 把 `.bit` 转成 `.bit.bin`（ZynqMP 必须带 header）→ 放到板上

## 板端

见 `transceiver/receiver/README.md`（驱动）与 `FPGA/sw/boot/README.md`（自启）。