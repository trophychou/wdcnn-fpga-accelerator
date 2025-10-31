# FPGA/sw —— 板上运行时


| 文件 | Last commit message |
|---|---|
| `bitstream/` | 位流与寄存器地址表 |
| `boot/` | 开机自启脚本与 systemd unit |
| `weights/` | 板上用的 21 个权重/参数 bin + 测试输入 |
| `rxstat.py` | 统计 wd_rx.bin：每路包数、窗数、坏包 |
| `sh.ps1` | 串口命令封装（COM5、115200、去 ANSI） |
| `spec_check.py` | 频谱标定自检：应 16/16 正确 |
| `txsl.ps1` | 大文件分块传输（600 KB 约 1.1 分钟） |
| `upload.ps1` | PC → 板 base64 分块上传并核对 md5 |
| `wd_bench.py` | 加速器封装：开 /dev/wdmem 与 /dev/mem，run(x) → (分数, dt 秒) |
| `wd_bin.py` | 实时上屏：跟 wd_rx.bin 增量解析、按 dev 拼窗推理 |
| `wd_live1.py` | 单路实时验证：68 窗、0.84 ms/窗、70 窗/分 |
| `wd_multi8.py` | 多设备：按 dev 分 8 路、32 包一窗、run_safe 重试 |
| `wd_prof.py` | 分段计时：DMA / 计算 / 写回 |
| `wd_replay.py` | 离线回放已录到的包 |
| `wd_seq.py` | 顺序回放 240 窗自检，对比标签 |
| `wdmem.c` | 内核模块：4 MiB 连续物理内存（GFP_DMA32）+ 字符设备 |

上电后必须显式 `fpgautil` 加载位流：overlay 显示 `operating` 不代表 PL 已配置，读 `0xA0000000` 会挂死总线。