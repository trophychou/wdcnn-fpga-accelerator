# sw/sleclient/lib —— SDK 静态库


`libsle_host.a`（1.58 MB，AArch64）：SDK 编译好的 SLE 主机侧协议栈 + HCI 传输，链接即用。

- 来源：`D:\AMDDesignTools\project\ws73_sdk\application\lib\rk3568\sle\libsle_host.a`
  （rk3568 是 AArch64，和 K26 的 aarch64 通用）
- 运行时依赖：`/dev/hwsle`（`sle_soc.ko` 提供）+ `/lib/ld-linux-aarch64.so.1`（glibc ≥ 2.17）
- 配对密钥会落盘到当前工作目录的 `sle_conf`；**拔插 dongle 或重载驱动后必须删它**，
  否则握手用旧密钥失败（`status = 0x8000600F`，`disconnect reason = 0x11`）。

## 文件

| 文件 | Last commit message |
|---|---|
| `libsle_host.a` | SDK 预编译静态库（AArch64，1.6 MB） |
