# FPGA/hls/src —— 加速器 C++ 源码


| 文件 | Last commit message |
|---|---|
| `hw_lib/` | 组件库（卷积/池化/激活/流转换） |
| `activation_utils.hpp` | 与 hw_lib 同源的拍平副本（activation_utils），供 #include 直接命中 |
| `config.hpp` | 尺寸常量：5120 点、512 位输入、16–32 通道、4 类 |
| `conv1_specialized.hpp` | 与 hw_lib 同源的拍平副本（conv1_specialized），供 #include 直接命中 |
| `general_1d_conv_accelerator.hpp` | 与 hw_lib 同源的拍平副本（general_1d_conv_accelerator），供 #include 直接命中 |
| `pool_accelerator.hpp` | 与 hw_lib 同源的拍平副本（pool_accelerator），供 #include 直接命中 |
| `run_hls.tcl` | 命令行流程：open_project → csim → csynth → export_design |
| `stream_utils.hpp` | 与 hw_lib 同源的拍平副本（stream_utils），供 #include 直接命中 |
| `synthesis_top.cpp` | 加速器顶层：512 位 AXIS 入 → 5 层卷积+池化+FC → 4 类分数出 |
| `testbench.cpp` | csim 测试台：读数据集与权重，跑 240 组打印精度 |

顶层签名：

```cpp
void synthesis_top(stream<ap_axiu<512,0,0,0>>& in, stream<ap_axiu<32,0,0,0>>& out,
                   21 个权重/偏置指针, int num_samples, bool reload_weights);
```

`num_samples` 是**窗口数**不是点数（每个 stage 的 reps 都用它）。
`reload_weights` 每窗置 1 会让每窗重读 168 KB 权重（9.7 ms/窗）；只在首窗置 1，硬件部分降到 0.84 ms。