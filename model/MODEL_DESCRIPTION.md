# WDCNN 模型交接说明

本目录是本次模型交接的唯一入口。只包含模型权重、推理所需配置和本说明；不附带训练数据、训练代码、环境、缓存、实验日志或旧折模型。

## 1. 先看这两套模型的区别

| 项目 | 方案一 `original_wdcnn/` | 方案二 `dual_sensor_wdcnn/` |
|---|---|---|
| 用途 | 保留最初工程的四分类 WDCNN | 用振动为主、电机电流辅助，判断损伤位置 |
| 是否重新训练 | 没有，原权重原样保留 | 已完成全量部署重训，两条支路各使用全部 25 只普通轴承、2000 条记录 |
| 物理输入 | 原工程单通道振动输入 | 同步的 1 路振动 + 2 路电机相电流 |
| 原始采样率 | 原工程未找到可确认的说明；不能称为 8 kHz 模型 | **每一个物理通道均为 8000 Hz** |
| 网络输入 | `[batch,1,5120]`，数值必须符合原 XJTY CSV 的处理约定 | 振动特征 `[batch,5,5120]`；电流特征 `[batch,4,5120]` |
| 输出 | 4 类分数，类别编号 0/1/2/3 | 每条支路 3 类分数，融合后输出健康/外圈损伤/内圈损伤 |
| 浮点参数 | `wdcnn_relu.pth` | 两个 `model_fp32.pth` |
| 整数参数 | 原工程 INT8 权重/偏置 CSV 与 `quant_config.json` | 两套新导出的 W8A8 参数，提供 NPZ 和 FPGA 二进制两种等价存储 |

**方案一不是“把原数据改成 8 kHz 后重训”的模型。** 方案二是基于 Paderborn 数据另行训练的双支路三分类模型。两者虽然都属于 WDCNN，数据、预处理、输入通道数、输出任务及量化规则不同，不能互换参数。

原四类的物理含义尚缺少可靠标签说明。项目曾暂按损伤程度讨论，但交接时不能把 0/1/2/3 写成已经证实的轻/中/重损伤。方案二明确识别损伤位置，不识别程度。当前也没有验证两个模型对同一个现场输入同时输出“程度+位置”的完整系统。

## 2. 目录与文件用途

```text
model/
  MODEL_DESCRIPTION.md
  original_wdcnn/
    wdcnn_relu.pth
    model_config.json
    quant_config.json
    weights_int8_csv/                # 原工程 7 层的 14 个权重/偏置 CSV
  dual_sensor_wdcnn/
    pipeline_config.json            # 原始信号处理、类别、门控、温度、来源及文件哈希
    vibration/
      model_fp32.pth
      model_config.json             # 输入形状、固定归一化参数、全量训练范围
      graph.json                    # BN 折叠后的整数网络结构、各层尺度和运算规则
      parameters_int8.npz           # 全部整数参数与逐通道权重尺度
      fpga_binary/
        manifest.json               # 二进制文件、层偏移、长度、形状和 SHA-256
        weights_int8.bin
        biases_int32_le.bin
        multipliers_int32_le.bin
        shifts_int32_le.bin
    current/                        # 与 vibration/ 文件结构相同
```

目录共 36 个模型及配置文件，加本说明 1 份。`model_config.json`、`graph.json`、`pipeline_config.json` 和二进制清单是模型运行参数，不是训练数据。NPZ 与 BIN 是同一套参数的两种表示，选择其中一种读取即可，不是额外模型。

本次交付的是**一对全量部署模型**，不是第 1 折、不是从测试成绩中挑选的最佳折，也不要求 FPGA 同时装入 25 对交叉验证模型。历史交叉验证权重和完整训练证据保留在项目本地，未混入本目录。

## 3. 方案二的电流是什么，8 kHz 怎么计算

数据来自 Paderborn Bearing DataCenter 的轴承试验台。电流是**驱动电机的两相实测相电流**，对应 `phase_current_1`、`phase_current_2`；不是电流通过轴承，也不是额外测量的轴承电流。电机驱动转轴和轴承，机械异常可能通过负载变化、调制等方式影响电机电流。本模型学习这些信号中的统计差异；不能据此声称所有电流变化都由轴承损伤造成。

三个物理通道必须取同一段时间的数据：

- 振动：8000 个采样点/秒。
- 相电流 A：8000 个采样点/秒。
- 相电流 B：8000 个采样点/秒。

因此不是三个通道合计 8 kHz。三路合计每秒 24000 个标量采样点，每路仍独立为 8 kHz。当前每条记录取 3.68 秒，即**每路 29440 点**；可表示为 `[3,29440]`，前 1 行振动、后 2 行电流。

数据准备时由原 64 kHz 同步波形经过抗混叠低通和 8 倍抽取得到现用 8 kHz 波形，随后特征完全由 8 kHz 波形计算。本次重训直接使用这些现用 8 kHz 特征。FPGA 原生采集 8 kHz 时仍需采集链满足相应抗混叠要求。

**5120 是插值后的频谱网格长度，不是 5120 个原始时间采样点。** 振动的 5 通道、电流的 4 通道都是从上述三路信号派生的特征通道，不代表 9 个传感器。

数据源页面：<https://mb.uni-paderborn.de/kat/forschung/bearing-datacenter>。

## 4. 方案二的输入、处理与输出

### 4.1 振动支路：五频带包络阶次谱 WDCNN

依次执行：

1. 一条 29440 点振动记录去均值。
2. 分别进入 5 个固定带通：200–1000、500–1500、1000–2000、1500–2500、2000–3500 Hz。使用设计阶数 4 的 Butterworth SOS，整记录 `sosfiltfilt` 零相位处理。
3. 每个频带取 Hilbert 包络，再用 `resample_poly(1,4)` 抽取到 2000 Hz；每路包络长度 7360。
4. 计算 Hann 窗、去常数均值、`scaling='spectrum'` 的单边周期图。频率除以轴转频得到机械阶次。
5. 每个频带的功率用本记录在 0.5–32.5 阶内的功率和归一化，取 `log10`，在 0.5–32.5 阶等间隔插值 5120 点。
6. 转 float32，每个特征通道再减去自身 5120 点均值，除以 `vibration/model_config.json` 的固定 `channel_rms`。这些尺度只由 2000 条训练记录计算，推理时不得重新拟合。

形成 `[batch,5,5120]`。五频带的 SOS 系数及截断、插值细节均在 `pipeline_config.json`，不需要重新选择频带。

### 4.2 电流支路：局部白化阶次谱 WDCNN

本次训练侧比较四种已冻结的输入，最终选择 `order_whitened`，不是历史某折使用的另外一种输入。两路相电流各去均值，乘对称 Hann 窗后做整记录 FFT。

设两相功率谱为 `Pa`、`Pb`，公共参考功率 `D=(sum(Pa)+sum(Pb))/2`。构造 4 个特征通道：

| 特征通道 | 内容 |
|---|---|
| 0 | 相电流 A 相对公共功率的 dB 谱 |
| 1 | 相电流 B 相对公共功率的 dB 谱 |
| 2 | 两相平均 dB 功率谱减去高斯平滑背景，截断在 ±40 dB，突出局部谱峰 |
| 3 | Clarke 电流矢量幅值去均值后的功率谱，相对公共相电流功率取 dB |

Clarke 变换为 `alpha=ia`，`beta=(ia+2*ib)/sqrt(3)`，幅值为 `sqrt(alpha²+beta²)`；这一构造隐含三相电流和近似为零的假设。**该支路不对电流做 Hilbert 包络。**

4 个通道在 0.25–40 机械阶等间隔插值 5120 点，转 float32，再用 `current/model_config.json` 中固定的训练均值和标准差逐通道归一化。电流网络实际输入 `[batch,4,5120]`。

两条支路均需轴转速作为工况上下文：当前数据 N09=15 Hz、N15=25 Hz。它用于频率到阶次的换算，不是损伤标签。新场景需提供对应轴转速；目前未验证任意变速过程。所有细节以 `pipeline_config.json` 为准。

### 4.3 网络结构与输出类别

两条支路都是 5 个卷积块、2 个全连接层：

```text
Conv(C,16,k64,s7,p1) -> BN -> ReLU -> MaxPool(2)
Conv(16,32,k3,s1,p1) -> BN -> ReLU -> MaxPool(2)
Conv(32,64,k3,s1,p1) -> BN -> ReLU -> MaxPool(2)
Conv(64,64,k3,s1,p1) -> BN -> ReLU -> MaxPool(2)
Conv(64,64,k3,s1,p0) -> BN -> ReLU -> MaxPool(2)
Flatten(64*21=1344) -> Linear(1344,100) -> ReLU -> Linear(100,3)
```

振动 `C=5`，电流 `C=4`。电流训练时全连接前使用 dropout=0.5，推理时必须 `eval()` 关闭。池化向下取整；卷积遵循 PyTorch 互相关定义；展平顺序是通道在前、长度在后。FP32 保留 BN；INT8 导出已折叠 BN，不能再叠加一次 BN。

每条支路输出 `[batch,3]` logits，按以下顺序：

| 下标 | 含义 |
|---|---|
| 0 | healthy，健康 |
| 1 | outer_ring，外圈损伤 |
| 2 | inner_ring，内圈损伤 |

融合输出同样为三类分数和 `argmax` 类别。softmax 分数与门控置信阈值是模型决策量，不是对任意未知轴承都成立的正确概率。

### 4.4 本次部署权重使用的融合规则

先对每条支路 logits 做 softmax 得到原始概率，再计算温度校准：`softmax(log(clip(p,1e-9,1))/T)`。振动温度 **3.0**，电流温度 **1.0**，校准与融合使用 float64。下述条件全部满足才允许电流辅助：

- 两条支路的第一预测类别不同。
- 电流第一预测类别在振动的前两名中。
- 振动第一、第二分数之差不大于 **0.20**。
- 电流第一分数不小于 **0.45**。
- 电流第一、第二分数之差不小于 **0.08**。

满足时：`融合分数=0.75×振动校准分数+0.25×电流校准分数`。不满足时完全使用振动校准分数。最终取最大分数类别；阈值均包含等号。当前不限制特定有向类别对，也没有始终等权平均或固定放大内圈权重。精确门控与温度在 `pipeline_config.json`。

## 5. 训练完成到什么程度，准确率应怎样引用

### 5.1 本次全量部署训练已完成

使用固定范围内全部 25 只普通轴承：健康 5 只、外圈 11 只、内圈 9 只，共 2000 条记录。K002、KI03 按此前要求已排除，不能把这个范围写成未经结果筛选的完整官方数据集；排除曾参考历史测试表现，报告须说明。

先做训练侧三折整轴承 OOF：每次 16 或 17 只训练，另外 9 或 8 只生成 OOF；训练内部另用整轴承验证选择轮数和学习率，再重置重训当折全部允许的训练轴承。同一只轴承的所有工况和记录始终在同一侧。训练并比较 3 个振动及 12 个电流内部模型，按原来冻结的 253 项候选和保护规则选择电流输入、温度与门控。

上述参数全部锁定后，取对应三折所选轮数/学习率的中位数，重新初始化，在全部 2000 条记录上各重训一个部署网络：振动 **4 轮**，电流 **3 轮**。这不是中断训练；轮数按事先约定的训练侧验证规则确定。随后仅用这 2000 条记录校准 INT8。KA01、KI01 两只 EDM 轴承未参与训练、尺度估计、门控、轮数或量化校准。

### 5.2 三种成绩不能混淆

| 结果来源 | 振动 | 电流 | 条件辅助 | 正确解读 |
|---|---:|---:|---:|---|
| 历史五折重复五次 FP32 | 80.63% | 46.52% | 81.04% | 每折 20 只训练、5 只测试；属于历史验证流程成绩 |
| 历史相同 25 折 INT8 | 80.71% | 46.59% | 81.00% | 历史那 50 个折网络量化后的成绩 |
| 本次部署选择用三折 OOF，FP32 | 66.45% | 54.00% | 67.15% | 训练侧选型证据；每折训练轴承更少，且门控在同一 OOF 上选出，不能作为最终独立测试成绩 |

**不能直接把 81.00% 标注为本次这对全量部署权重的独立实测准确率。** 本次 25 只普通轴承全部用于最终重训，没有再保留普通轴承盲测集；需要新轴承才能独立评价这对具体权重。三折 OOF 与历史五折训练规模、划分和用途不同，不能据两行数字认定全量部署权重的准确率下降或上升。

历史 FP32 的融合仅净增 0.41 个百分点，收益集中，配对区间包含零；不能宣称电流带来已经证实的稳定显著提升。

全部权重、量化和门控锁定后，本次另在 KA01、KI01 各 80 条 EDM 记录上做附加复测：FP32 振动 160/160、电流 48/160、融合 160/160；INT8 振动 160/160、电流 52/160、融合 160/160。**只有两只受损轴承、没有健康样本，且这些轴承历史上已被研究过，因此该 100% 不能当成普通三分类总体准确率或外部盲测成绩。** 测后没有据此调整模型。

方案一原权重曾在原有 240 条固定测试向量上复测 240/240；该 100% 的范围是原固定测试集，不构成已证明的跨轴承泛化准确率，不能与新方案的跨轴承成绩直接比较。

## 6. INT8 接口：FPGA 同学优先看这里

### 新方案

两条支路均完成训练后量化 PTQ：signed W8A8，零点 0，范围 **[-127,127]**；权重逐输出通道量化，激活逐张量量化；偏置和累加 INT32，重缩放乘积 INT64。所有参数已经固定。

1. 主机按第 4 节计算并归一化特征，再以 FP64 执行 `q=clip(round_away(x/input_scale),-127,127)`。`round_away` 指恰好半值时远离零；`input_scale` 读取对应 `graph.json`，不要乘旧方案的 `S_IN_SCALE`。
2. 每层 `acc=sum(qx*qw)+bias_int32`，然后 `prod=int64(acc)*multiplier_int32`。对每个输出通道，`mag=(abs(prod)+2^(shift-1))>>shift`，恢复符号，再按激活截断；ReLU 层为 [0,127]，最后一层为 [-127,127]。本方案偏置在重缩放**之前**加入。
3. 卷积权重 C-order `[out_channel,in_channel,kernel]`，全连接 `[out_feature,in_feature]`；输入 `[batch,channel,length]`。BIN 为有符号 INT8 和小端有符号 INT32；每层偏移、元素数见 `fpga_binary/manifest.json`。
4. 每个网络输出 3 个 INT8 分数；用该分支的 `output_scale` 还原 logits，再按第 4.4 节做 softmax、校准和门控。两分支输出尺度不同，不能直接平均 INT8 数字。只比较同一支路类别时，正尺度不改变 `argmax`。

NPZ 参数键为 `conv1_weight`、`conv1_bias`、`conv1_multiplier`、`conv1_shift`、`conv1_weight_scale`，后续为 conv2…conv5、fc1、fc2，命名相同。BIN 与 NPZ 已逐元素读回核对。

两模型各选 4 条训练记录，CPU 与 CUDA 的所有整数中间结果完全一致；独立 NumPy 又核对 8 条记录共 168 个逐层中间数组，均精确一致。归一化尺度重新计算核对通过。软件核验通过不代表 HLS、RTL 或板卡实测通过。

**本次量化的是 WDCNN 网络主体。** FFT、零相位滤波、Hilbert、局部白化、归一化及 softmax/融合目前仍是浮点处理，没有验证端到端整数流式 FPGA。可先在 PS/主机完成前后处理，再将两个 INT8 网络接入 PL；具体接口、资源与时序由 FPGA 同学适配。本目录按要求只提交模型参数及说明，不附带 HLS 工程，也不宣称已经综合或上板。

### 原方案

使用原 `quant_config.json` 与 `weights_int8_csv/`：输入 `round_away(x*S_IN_SCALE)`，截断 [-128,127]；每层先 `sum(qx*qw)*INC` 算术右移 SHIFT，再加 CSV 偏置并激活/饱和。**原方案偏置在重缩放之后加，且下限 -128；与新方案不同。** 不要把旧 INC/SHIFT 内核不加修改就用于新参数。

## 7. FP32 权重读取参考

只有权重文件不会自动执行信号处理；先严格按第 4 节得到归一化频谱。下面给出完整网络定义，方便从本目录构建网络，无需训练源码。读取 `.pth` 需 PyTorch；二进制整数部署不依赖 PyTorch。当前导出使用 Python 3.13、PyTorch 2.11.0，文中参考处理对应 NumPy/SciPy 的上述明确操作，不附带虚拟环境。

```python
from pathlib import Path
import torch
from torch import nn

class WDCNN(nn.Module):
    def __init__(self, channels, classes, current=False):
        super().__init__()
        blocks = []
        for a, b, k, s, p in [(channels,16,64,7,1),
                              (16,32,3,1,1), (32,64,3,1,1),
                              (64,64,3,1,1), (64,64,3,1,0)]:
            blocks += [nn.Conv1d(a,b,k,stride=s,padding=p),
                       nn.BatchNorm1d(b), nn.ReLU(), nn.MaxPool1d(2,2)]
        self.feature = nn.Sequential(*blocks, nn.Flatten())
        if current:
            self.fc = nn.Sequential(nn.Dropout(.5), nn.Linear(1344,100),
                                    nn.ReLU(), nn.Dropout(.5), nn.Linear(100,classes))
        else:
            self.fc = nn.Sequential(nn.Linear(1344,100), nn.ReLU(),
                                    nn.Linear(100,classes))
    def forward(self, x):
        return self.fc(self.feature(x))

root = Path('model')  # 在仓库根目录执行
original = WDCNN(1, 4)
original.load_state_dict(torch.load(root/'original_wdcnn/wdcnn_relu.pth',
                                    map_location='cpu', weights_only=True))
vibration = WDCNN(5, 3)
vibration.load_state_dict(torch.load(root/'dual_sensor_wdcnn/vibration/model_fp32.pth',
                                     map_location='cpu', weights_only=True))
current = WDCNN(4, 3, current=True)
current.load_state_dict(torch.load(root/'dual_sensor_wdcnn/current/model_fp32.pth',
                                   map_location='cpu', weights_only=True))
original.eval(); vibration.eval(); current.eval()
# 用 torch.inference_mode() 执行；新两支路输入为已处理且已归一化的 float32 谱。
# 原模型输入则必须遵循原 XJTY 数值约定，不能套用第4节的新预处理。
```

`pipeline_config.json` 记录方案二所有参数文件的 SHA-256；两个 BIN 清单也记录各二进制哈希。方案一原 FP32 权重 SHA-256 为 `362e592f3ab72e1367f1afeec402920de2917442ce08930e7d9cfd9a8b86580b`，本次复制后保持一致。
