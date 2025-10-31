# FPGA/hls/src/hw_lib —— 组件库


纯头文件，被源码以 `#include "xxx.hpp"` 引用（无目录前缀，编译时要 `-I` 到本目录）。

| 文件 | Last commit message |
|---|---|
| `activation_utils.hpp` | 激活与量化：ReLU + 分层移位缩放 |
| `conv1_specialized.hpp` | 第 1 层专用卷积：1→16 通道，直吃 512 位 AXIS |
| `general_1d_conv_accelerator.hpp` | 通用 1D 卷积（3 抽头），Conv2–5 复用 |
| `pool_accelerator.hpp` | 2 点最大池化（通道/长度可配） |
| `readme.txt` | 原工程自带的英文说明 |
| `stream_utils.hpp` | AXIS 与 HLS stream 的拆包/打包 |
| `stream_utils.hpp` | AXIS 与 HLS stream 的拆包/打包 |