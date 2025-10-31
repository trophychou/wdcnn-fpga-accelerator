# model/reports —— 训练与量化报告


| 文件 | Last commit message |
|---|---|
| `wdcnn_relu_quant_report.json` | 量化报告：逐层误差与总精度 |
| `wdcnn_relu_train_report.json` | 训练报告：准确率、混淆矩阵、超参 |

量化后精度与浮点一致（240/240），因此板上结果与离线复算可以逐窗对上。