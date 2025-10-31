# model/scripts —— 训练与量化


| 文件 | Last commit message |
|---|---|
| `make_dataset_wdcnn_xjty.py` | 切分数据集：按幅值分组、80/20、seed 42 |
| `make_quant_config.py` | 量化：生成 quant_config.json 与 int8 CSV |
| `train_wdcnn_xjty.py` | 训练：5120 点、4 类、20 epoch、batch 32 |
| `WDCNN_ReLU.py` | 网络定义：5 层卷积 + 2 层全连接，全 ReLU |

数据 CSV 不随仓库提供（`XJTY_classifier.csv` 47 MB 等），需要放回 `data/` 才能重跑训练。