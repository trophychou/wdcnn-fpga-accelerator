# sender/fwpkg —— 8 份固件


| 文件 | Last commit message |
|---|---|
| `spec1.fwpkg` | dev1 固件：正常 波形，应判 code=0 |
| `spec2.fwpkg` | dev2 固件：正常 波形，应判 code=0 |
| `spec3.fwpkg` | dev3 固件：外圈 波形，应判 code=1 |
| `spec4.fwpkg` | dev4 固件：外圈 波形，应判 code=1 |
| `spec5.fwpkg` | dev5 固件：内圈 波形，应判 code=2 |
| `spec6.fwpkg` | dev6 固件：内圈 波形，应判 code=2 |
| `spec7.fwpkg` | dev7 固件：滚动体 波形，应判 code=3 |
| `spec8.fwpkg` | dev8 固件：滚动体 波形，应判 code=3 |

每份 1,385 KB，md5 两两不同（唯一广播地址 + 各自波形）。包内 9 个 entry，与厂商原包结构一致。

烧写必须完整走完：BurnTool 烧 → 关 BurnTool → 拔烧写线 → **断电 3 秒** → 上电。
烧完可用 `tools/inspect_pkg.py` 核对包结构（9 个 entry、magic `dfadbeef`）。