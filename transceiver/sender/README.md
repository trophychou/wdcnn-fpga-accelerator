# transceiver/sender —— ws63 发送端

板上实时合成轴承振动信号（不再依赖老师给的 240 组波形表），按设备号区分 8 个通道。

| 目录 | 内容 |
|---|---|
| `app/` | 完整的 `sle_uart` 应用源码（最终版），可直接放回 SDK 的 `application/samples/products/sle_uart` |
| `fwpkg/` | 8 份固件 `spec1..8.fwpkg`（各 1.35 MB，md5 互不相同） |
| `tools/` | 波形生成器、批量编译脚本、固件包检查工具 |

## 设备 → 类别

| dev | 波形 | 应判 code |
|---|---|---|
| 1, 2 | 正常 | 0 |
| 3, 4 | 外圈 | 1 |
| 5, 6 | 内圈 | 2 |
| 7, 8 | 滚动体 | 3 |

## 编译

```powershell
cd <SDK 根>
python build.py ws63-liteos-app -def=WAVE_DEV_ID=3    # 编 dev3
```
或用 `tools/build_sender.ps1` 批量出 8 份（需要 `cmake` 在 PATH）。

## 烧写

BurnTool（COM4，921600）→ 烧完**关 BurnTool、拔烧写线、断电 3 秒再上电**。
缺断电这一步芯片停在 bootloader，串口一个字节都没有。

## 文件

| 文件 | Last commit message |
|---|---|
| `app/` | sle_uart 应用源码（最终版） |
| `fwpkg/` | 8 份可直接烧的固件（各 1.35 MB） |
| `tools/` | 波形生成、批量编译、固件包检查 |
