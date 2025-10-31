# FPGA/sw/weights —— 板上权重


| 文件 | Last commit message |
|---|---|
| `b1.bin` | 第 1 层 Conv1 的偏置（int32） |
| `b2.bin` | 第 2 层 Conv2 的偏置（int32） |
| `b3.bin` | 第 3 层 Conv3 的偏置（int32） |
| `b4.bin` | 第 4 层 Conv4 的偏置（int32） |
| `b5.bin` | 第 5 层 Conv5 的偏置（int32） |
| `b6.bin` | 第 6 层 FC1 的偏置（int32） |
| `b7.bin` | 第 7 层 FC2 的偏置（int32） |
| `i1.bin` | 第 1 层 Conv1 的量化参数（scale/shift） |
| `i2.bin` | 第 2 层 Conv2 的量化参数（scale/shift） |
| `i3.bin` | 第 3 层 Conv3 的量化参数（scale/shift） |
| `i4.bin` | 第 4 层 Conv4 的量化参数（scale/shift） |
| `i5.bin` | 第 5 层 Conv5 的量化参数（scale/shift） |
| `i6.bin` | 第 6 层 FC1 的量化参数（scale/shift） |
| `i7.bin` | 第 7 层 FC2 的量化参数（scale/shift） |
| `sle_wave.bin` | 早期合成器的 24 窗参考波形（每类 6 窗） |
| `w1.bin` | 第 1 层 Conv1 的权重（int8 打包） |
| `w2.bin` | 第 2 层 Conv2 的权重（int8 打包） |
| `w3.bin` | 第 3 层 Conv3 的权重（int8 打包） |
| `w4.bin` | 第 4 层 Conv4 的权重（int8 打包） |
| `w5.bin` | 第 5 层 Conv5 的权重（int8 打包） |
| `w6.bin` | 第 6 层 FC1 的权重（int8 打包） |
| `w7.bin` | 第 7 层 FC2 的权重（int8 打包） |
| `wd_input.bin` | 240 窗 int8 测试输入（240×5120） |
| `wd_label.bin` | 240 个测试标签（uint8） |

与 `model/binary/` 同源；`wd_bench.py` 按固定偏移把它们写进 `/dev/wdmem`。