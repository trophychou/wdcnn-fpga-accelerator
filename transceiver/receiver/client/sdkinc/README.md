# sw/sleclient/sdkinc —— SDK 头文件子集

从 `ws73_sdk/include` 与 `driver` 里挑出来、编译客户端需要的那部分：

| 子目录 | 内容 |
|---|---|
| `bsle/common/` | 公共类型、错误码、日志宏 |
| `bsle/sle/` | SLE API（连接管理、SSAP 客户端/服务端、广播、PHY） |
| `sec/` | 安全/加密接口 |
| `drv/` | 设备节点、ioctl 定义 |
| `osal/` | 系统抽象（内存、线程、时间）——**已修**：删掉与 `<stdint.h>` 冲突的 `uint*_t` typedef |

这些是 SDK 的拷贝，升级 SDK 时同步覆盖即可。

## 文件

| 文件 | Last commit message |
|---|---|
| `bsle/` | SLE/BLE 公共头 |
| `drv/` | 驱动侧头文件 |
| `osal/` | OS 抽象层头（uint 类型重复定义已修） |
| `sec/` | 安全模块头 |
