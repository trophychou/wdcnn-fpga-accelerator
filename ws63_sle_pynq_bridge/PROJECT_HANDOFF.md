# H3863 SLE 数据网关交接说明

## 目标与当前状态

目标链路是多块 BearPi Pico H3863 发送模拟传感器数据，经 SLE 到接收端，再交给 PYNQ-Z2 上的 Linux 保存和处理。

当前可用的验证路径是：

    H3863 Server -> SLE -> H3863 Client -> 板载 CH340 USB 串口 -> PYNQ-Z2 USB Host -> Linux Python

H3863 当前发送的是固件内置的模拟数据，不是从真实传感器读取。数据集有 20 行，每 100 ms 发送一行；连接后用 SLE SSAP Notification 推送。现在的帧格式为：

    device_id,seq,temperature_c,humidity_pct,pressure_hpa

device_id 是 1 到 255 的发送端编号，由 SLE_DATASET_DEVICE_ID 配置，默认值为 1。多块板必须设置不同编号。seq 在每块板内从 1 到 20 循环。编号有助于接收端区分数据来源，但单独增加编号并不会自动实现多连接管理、空口调度或重传。

已有串口抓包记录显示，旧的四列格式曾连续收到 769 帧，约 90 秒，平均间隔约 112 ms；期间有一次 SLE 断链并自动重连。当前代码已经扩展为五列、带 device_id 的格式，重新烧录后的五列格式和多发送端汇聚尚待实板验证。

## 发送端构建

sender/sle_uart/ 保存本项目用到的 SLE UART Server/Client 样例源码；sender/ws63_liteos_app.config 是当前 Server 构建配置快照；sender/dataset.csv 是 20 行数据源；sender/tools/generate_sle_dataset.py 用于生成 sle_dataset_data.h。

将 sle_uart 目录放入 HiSpark fbb_ws63 SDK 的：

    src/application/samples/bt/sle/sle_uart/

在 SDK 的 Kconfig 配置中启用 SLE 样例和 SLE UART Server。每块发送板设置唯一的 SLE_DATASET_DEVICE_ID。当前完整配置快照可用于对照，但更换 SDK 版本或板卡配置时应先核对 UART 引脚和其他选项。

在 SDK 的 src 目录执行：

    python fbb.py build ws63-liteos-app -j 4

构建后烧录最新固件，再从串口日志和接收端确认每行包含五列。烧录前应核对实际 COM 口；设备重新插拔后 COM 编号可能变化。

Client 端收到 Notification 后写入所配置的数据 UART。已有抓包是在板载 CH340 上观察到裸 CSV，但历史配置显示数据 UART 与 CH340 的映射尚未完全解释。若 PYNQ 侧没有数据，先在 PC 串口助手确认实际数据口、115200 8N1 和五列帧格式。

## PYNQ-Z2：CH340 串口接收路线

这是目前最直接的接收方式，不使用 E573 dongle。

1. 将 H3863 Client 的 USB 接到 PYNQ-Z2 的 USB-A Host 口。
2. 在 PYNQ 检查 USB Host 和设备枚举：

       dmesg | tail -30
       lsusb
       ls -l /dev/ttyUSB*

3. 若内核包含但尚未加载 CH340 驱动，可尝试：

       sudo modprobe ch341

   若设备仍没有 ttyUSB 节点，需要确认 PYNQ Linux 内核启用了 USB Host、USB Serial 和 CH341 驱动；驱动通常可由内核内建或模块提供，不一定需要单独下载厂商驱动。

4. Python 接收脚本依赖 pyserial。缺少时安装：

       python3 -m pip install pyserial

5. 在仓库根目录运行：

       python3 ws63_sle_pynq_bridge/pynq/recv_csv.py /dev/ttyUSB0 115200 received.csv 20

脚本识别新五列格式，并按 device_id 分别统计帧数、序号缺口和速率；旧四列帧会以 device_id=0 标记。串口名称可能是 ttyUSB1 等，应以 PYNQ 实际枚举结果为准。需要访问串口的用户还需具有对应设备节点权限。

## E573H-USBDG：原生 USB 星闪路线

E573H-USBDG 规格书说明该板基于 Hi3873E，支持 SLE 1.0，通过 USB 2.0 与主机通信。规格书列出的 4 个金手指信号是 GND、DP、DN、VBUS，因此它是 USB 星闪 dongle，不是 USB-TTL/CH340 串口设备；插入后不应期待它直接生成 /dev/ttyUSB0。

本机 E573H-USBDG 资料目录中与接收端最相关的内容：

- e573h-usbdg 星闪开发板规格书：芯片、SLE 版本、USB 接口和四针定义。
- M573H-USBDG开发资料/WS73V100 Linux平台驱动移植 用户指南_08.pdf：USB 检测、内核驱动编译和加载步骤。
- M573H-USBDG开发资料/WS73V100 Linux SLE软件 开发指南_06.pdf：Linux SLE/SSAP Client API 与应用样例流程。
- ws73_sdk_linux_WS73_1.10.110/：包含 USB HCC、SLE 驱动源码、头文件和 SLE UUID Client 样例。
- 附件/香橙派5Plus_rk3588_linux5.10.160的编译结果ko/：包含 plat_soc.ko、sle_soc.ko 等预编译模块，仅适用于对应 Orange Pi/RK3588 内核环境，不能直接用于 PYNQ-Z2。

若选 E573 路线，PYNQ 侧至少还要完成：

1. 用 lsusb -nn 和 dmesg 确认 E573 被 USB Host 枚举，并记录 PYNQ 的 uname -r、uname -m。
2. 准备与 PYNQ 正在运行的内核版本、CPU 架构和配置匹配的内核头文件/构建目录、Module.symvers 及 ARM 交叉工具链。
3. 基于 WS73 SDK 为该内核重编 plat_soc.ko 与 sle_soc.ko；不能复用 RK3588 预编译 .ko。按指南放置匹配的固件和配置文件，再加载 plat_soc.ko、sle_soc.ko。
4. 移植或构建 Linux 用户态 SLE Client，扫描并连接 H3863 Server，发现服务后订阅 Notification。WS73 SDK 的 SSAP Client 示例可作起点；本工程的服务 UUID 为 0x2222、属性 UUID 为 0x2323。
5. 在 Client 回调中解析 device_id、seq 和 CSV 字段，再写文件或转发给 PYNQ 应用。

这条路线目前没有在 PYNQ-Z2 上验证。WS73 SDK 文档还提到一个进程只支持注册一个 SSAP Client 实体；它是否支持同时维护多块 H3863 的连接，以及具体连接数，仍需用 SDK/API 和实板确认。

## 多发送端待办

- 给每块 H3863 分配固定且唯一的 SLE_DATASET_DEVICE_ID，并烧录对应 Server 固件。
- 先用一块 Server 验证接收，再逐块增加发送端，记录连接成功数、每个 ID 的帧率和序号缺口。
- 确认接收端是否能同时连接多个 Server；若只能连接一个，需要设计轮询重连或更换接收拓扑。
- 测试同时发送时的空口竞争、断链恢复和缓冲队列；当前协议没有应用层 ACK、CRC 或重传。
- 确认 PYNQ 收到的五列数据可正确保存，再接入后续 FPGA/Linux 处理流程。

## 仓库目录

- sender/sle_uart/：本次工程使用的 H3863 SLE UART 样例源码。
- sender/ws63_liteos_app.config：当前 Server 配置快照。
- sender/dataset.csv 和 sender/tools/generate_sle_dataset.py：模拟数据源及头文件生成器。
- pynq/recv_csv.py：CH340 串口接收与逐发送端统计脚本。

E573 的原始手册、WS73 Linux SDK 和 Orange Pi 编译产物只在本机资料目录中列作参考，没有复制到此公开仓库。
