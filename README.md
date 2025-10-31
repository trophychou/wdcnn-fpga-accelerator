# wdcnn-fpga-accelerator


KV260（XCK26）上的一维卷积振动识别加速器：ws63 无线发送端 → 星闪（SLE）→ USB dongle → KV260 →
AXI DMA → HLS 加速器 → 4 分类结果。含硬件工程、量化模型、收发链路与板上运行时。

## 结构

| 目录 | 内容 |
|---|---|
| `transceiver/` | 收发链路：ws63 发送端固件、aarch64 接收端驱动与 SLE 客户端、PYNQ 旧脚本 |
| `model/` | 当前在用的 4 分类 WDCNN：网络结构、训练权重、int8 量化、权重导出 |
| `FPGA/` | HLS 加速器工程、Vivado 硬件平台、板上位流与运行时脚本 |

## 关键数字

- 输入 5120 点/窗（8 kHz，640 ms），int8 定点网络，4 类输出
- 加速器 **0.84 ms/窗**（100 MHz），窗口占空比 0.13%
- 实现资源：LUT 21,721（18.55%）、FF 27,207、BRAM 49.5、DSP 102

## 链路协议

```
包 = 0xA5 | dev | win_id(LE16) | pkt_id(LE16) | n(LE16) | n×int8 | 累加和
一窗 = 32 包 × 160 点 = 5120 点
```

## 快速开始

1. 发送端：`transceiver/sender/` 烧 `fwpkg/specN.fwpkg`（BurnTool，烧完断电 3 s）
2. 板子：装 Kria Ubuntu 22.04 → 编 `transceiver/receiver/driver` 的两个 `.ko` → 起 `client/sle_client.m8`
3. 位流：`FPGA/sw/bitstream/system_wrapper.bit.bin` 用 `fpgautil` 加载
4. 运行：`python3 FPGA/sw/wd_bin.py 8 /home/ubuntu/sw/wd_rx.bin`

## 文件

| 文件 | Last commit message |
|---|---|
| `FPGA/` | K26 硬件工程与板上运行时 |
| `model/` | 当前在用的 4 分类 WDCNN |
| `transceiver/` | 星闪收发链路（ws63 发送端 → KV260 接收端） |
| `.gitattributes` | Git 属性：二进制与大文件按 binary 处理 |
