# model —— 当前在用的 4 分类 WDCNN


一维卷积网络 `WDCNN_ReLU`：输入 1×5120 点 int8 振动窗，输出 4 类分数。

| 文件 | Last commit message |
|---|---|
| `binary/` | 板上用的扁平二进制（21 个 + 输入/标签） |
| `reports/` | 训练与量化报告 |
| `scripts/` | 训练、量化、数据集切分脚本 |
| `weights_int8_csv/` | 7 层 int8 权重/偏置 CSV |
| `model.json` | 网络结构：层序、通道、卷积核、stride |
| `quant_config.json` | 量化参数：s_int=5.08732560604007、移位、范围 |
| `wdcnn_relu.pth` | 训练好的 PyTorch 权重（672 KB，240/240） |

## 量化口径

`int8 = round(float × 5.08732560604007)`；推理时 int8 累加后按层缩放，偏移与移位见 `quant_config.json`。
**不能直接把 int8 当浮点喂回 PyTorch**（准确率会掉到 0.5）；要对齐时必须除回 5.0873。

## 类别

`0` 正常、`1` 外圈、`2` 内圈、`3` 滚动体（仓库里只有整数标签，没有官方类别名）。