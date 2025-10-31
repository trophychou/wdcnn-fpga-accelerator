# sender/app —— sle_uart 应用源码（最终版）


| 文件 | Last commit message |
|---|---|
| `sle_uart_client/` | 客户端示例（本工程不用，保留） |
| `sle_uart_server/` | 服务端：配对回调、广播、`drop_link()` 断链 |
| `CMakeLists.txt` | SDK 构建脚本（新增源文件要登记） |
| `Kconfig` | 编译开关（WAVE_DEV_ID 等） |
| `sle_uart.c` | 发送端主逻辑：32 包/窗、AIMD gap、自愈、心跳 |
| `sle_wave_gen.h` | 波形合成器：4 类 × 12 正弦，Q11 定点 |

相对原 V9 的改动：

1. 数据源从 `g_sle_wave[240][5120]`（2.1 MB 表）改为 `wave_gen_fill()` 实时合成
2. `g_wave_pkt[1] = WAVE_DEV_ID`，接收端按它分 8 路
3. 新增 `wave_self_heal()`：未连接每 5 s 重播，已连接 15 s 无心跳则拆链重播
4. `sle_pair_complete_cbk` 在 `status != 0` 时清句柄并断链
5. 广播地址 `local_addr[5] = WAVE_DEV_ID & 0x3F`（原为固定 `0x06`）

`WAVE_DEV_ID` 由编译宏 `-DWAVE_DEV_ID=n` 传入，`sle_wave_gen.h` 里有 `#ifndef` 守卫。