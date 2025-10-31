# sender/tools —— 波形生成与编译工具


| 文件 | Last commit message |
|---|---|
| `build_sender.ps1` | 批量编 8 份固件并打印 md5 |
| `inspect_pkg.py` | 解包 fwpkg，列 entry 与 magic |
| `wave_spec_gen.py` | 按真实 PSD 合成 4 类波形，生成头文件 |

## 波形参数

每类取真实数据 PSD 的前 12 个峰（6 Hz 内合并），幅度 ∝ √PSD，按类目标 RMS 归一：
class0 2.90 / class1 17.41 / class2 2.38 / class3 27.0（int8 量程），叠加 6% 噪声。

⚠️ 早期版本把共振放在 3.1–3.45 kHz，与真实数据（能量集中在 170–640 Hz）不符，模型会全部判 0；
现在的版本已在板上验证 16/16 正确。