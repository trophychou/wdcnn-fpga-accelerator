# receiver/client —— SLE 用户态客户端


由 SDK 示例 `sle_client.c` + `sle_uuid_client.c` 改出来的多连接接收端，编成 `sle_client.m8`（约 632 KB）。

| 目录 | 说明 |
|---|---|
| `src/` | 最终版源码（2 个） |
| `inc/` | 示例头文件 |
| `lib/libsle_host.a` | SDK 预编译静态库（AArch64，1.6 MB） |
| `sdkinc/` | 客户端需要的 SDK 头子集 |
| `Makefile`、`fix1.sh` | 编译脚本 / 板上生成驱动配置的脚手架 |

## 编译

```bash
gcc -O2 -o sle_client.m8 src/sle_client.c src/sle_uuid_client.c \
    -Iinc -Isdkinc/bsle/common -Isdkinc/bsle/sle -Isdkinc/sec \
    -Isdkinc/drv -Isdkinc/osal lib/libsle_host.a -lpthread -lrt -lm -ldl
```

## 9 处改动

1. 扫描接受任意地址（原版写死 `06:05:04:03:02:01`）
2. 每条 MAC 只连一次（`g_conn_live[]` 去重），最多 8 条并发
3. 找到属性后写 CCCD 订阅（`handle+1`，`{0x00,0x02}`）
4. 关掉示例的批量发送线程（只收不发）
5. 每 2 s 对每条连接写 1 字节心跳
6. 配对失败自动 `sle_remove_paired_remote_device()` 清 bond
7. 连接参数：interval 24–40 slot、supervision 1200（12 s）、2M PHY + MCS
8. 通知回调二进制写 `wd_rx.bin`（`setvbuf` 1 MB，每 64 包 flush）
9. 每 10 s 读一次 RSSI 打印

⚠️ `sle_uuid_client.c` 是 GBK/UTF-8 混合编码，只能用**字节级替换**修改（`bytes.replace`），
任何 decode/encode 都会让编译报 `invalid storage class for function ...`。

⚠️ 配对密钥会落盘成 `sle_conf`；换 dongle、重载驱动或重烧发送端后必须删它，否则握手失败（`0x8000600F`）。

## 文件

| 文件 | Last commit message |
|---|---|
| `inc/` | 示例头文件 |
| `lib/` | 预编译静态库 |
| `sdkinc/` | 客户端需要的 SDK 头子集 |
| `src/` | 客户端源码（最终版） |
| `fix1.sh` | 板上生成驱动配置的脚手架（等价 hconfig.py） |
| `Makefile` | 编译规则：gcc + libsle_host.a |
