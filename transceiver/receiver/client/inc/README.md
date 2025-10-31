# sw/sleclient/inc —— 客户端头文件


| 文件 | Last commit message |
|---|---|
| `sle_package.h` | 打包/解包接口声明 |
| `sle_uuid_client.h` | 示例函数声明：连接、订阅、读写 |

业务协议（我们自己的）不在这里，见 `firmware/README_发送端.md`：
`0xA5 | dev | win LE | pkt LE | n LE | n×int8 | 累加和`。