# model/binary —— 板上权重（扁平二进制）


| 文件 | Last commit message |
|---|---|
| `b1.bin` | 第 1 层 Conv1 的偏置（int32）（model/binary） |
| `b2.bin` | 第 2 层 Conv2 的偏置（int32）（model/binary） |
| `b3.bin` | 第 3 层 Conv3 的偏置（int32）（model/binary） |
| `b4.bin` | 第 4 层 Conv4 的偏置（int32）（model/binary） |
| `b5.bin` | 第 5 层 Conv5 的偏置（int32）（model/binary） |
| `b6.bin` | 第 6 层 FC1 的偏置（int32）（model/binary） |
| `b7.bin` | 第 7 层 FC2 的偏置（int32）（model/binary） |
| `i1.bin` | 第 1 层 Conv1 的量化参数（scale/shift）（model/binary） |
| `i2.bin` | 第 2 层 Conv2 的量化参数（scale/shift）（model/binary） |
| `i3.bin` | 第 3 层 Conv3 的量化参数（scale/shift）（model/binary） |
| `i4.bin` | 第 4 层 Conv4 的量化参数（scale/shift）（model/binary） |
| `i5.bin` | 第 5 层 Conv5 的量化参数（scale/shift）（model/binary） |
| `i6.bin` | 第 6 层 FC1 的量化参数（scale/shift）（model/binary） |
| `i7.bin` | 第 7 层 FC2 的量化参数（scale/shift）（model/binary） |
| `sle_wave.bin` | 参考波形副本（同 FPGA/sw/weights/sle_wave.bin） |
| `w1.bin` | 第 1 层 Conv1 的权重（int8 打包）（model/binary） |
| `w2.bin` | 第 2 层 Conv2 的权重（int8 打包）（model/binary） |
| `w3.bin` | 第 3 层 Conv3 的权重（int8 打包）（model/binary） |
| `w4.bin` | 第 4 层 Conv4 的权重（int8 打包）（model/binary） |
| `w5.bin` | 第 5 层 Conv5 的权重（int8 打包）（model/binary） |
| `w6.bin` | 第 6 层 FC1 的权重（int8 打包）（model/binary） |
| `w7.bin` | 第 7 层 FC2 的权重（int8 打包）（model/binary） |
| `wd_input.bin` | 240 窗 int8 测试输入 |
| `wd_label.bin` | 240 个测试标签 |

板上 `wd_bench.py` 启动时按 21 个指针顺序把它们读进 `/dev/wdmem`：
`0x000000` 权重区、`0x030000` 量化参数区、`0x040000` 偏置区。