# sw/sleclient/src —— 接收端最终源码


| 文件 | Last commit message |
|---|---|
| `sle_client.c` | 客户端主流程：扫描、连接去重、CCCD、心跳、落盘 |
| `sle_uuid_client.c` | 属性发现与通知回调（混合编码，字节级改） |

相对原始示例的 9 处改动（完整 diff 在 `firmware/src/sle_uuid_client.c.diff`）：

1. 扫描结果接受**任意地址**（原来写死 `06:05:04:03:02:01`）
2. 每条 MAC 只发一次 connect（`g_conn_live[]` 去重），最多 8 条并发
3. 找到属性后写 **CCCD 订阅**（`handle+1`，`{0x00,0x02}`）
4. **关掉示例的批量发送线程**（`g_send_flag = IDLE`），只收不发
5. 每 2 s 对每条连接写 1 字节**心跳**
6. 配对失败自动 `sle_remove_paired_remote_device()` 清 bond
7. 连接参数：interval 24–40 slot、`supervision_timeout=1200`（12 s）、2M PHY + MCS
8. 通知回调**二进制写** `/home/ubuntu/sw/wd_rx.bin`（`setvbuf` 1 MB，每 64 包 flush）
9. 每 10 s 读一次 RSSI 打印

**改这个文件只能用字节级替换**（`bytes.replace`）：它是 GBK 与 UTF-8 混合编码，任何解码再编码都会
改变字节、编译报 `invalid storage class for function ...`。