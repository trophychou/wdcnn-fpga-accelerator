# FPGA/sw/bitstream —— 位流


| 文件 | Last commit message |
|---|---|
| `system.hwh` | 寄存器地址表副本 |
| `system_wrapper.bit` | 原始位流 7.4 MB（归档用） |
| `system_wrapper.bit.bin` | 可加载位流，fpgautil -b 用这个 |

```bash
sudo cp system_wrapper.bit.bin /lib/firmware/
sudo fpgautil -b /lib/firmware/system_wrapper.bit.bin
# 成功：BIN FILE loaded through FPGA manager successfully
```