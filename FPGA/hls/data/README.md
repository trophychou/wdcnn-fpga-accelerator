# FPGA/hls/data —— 数据集


3 个 CSV，均 **5121 列**（5120 个特征 + 1 列整数标签 0–3），共 240 行：

| 文件 | Last commit message |
|---|---|
| `XJTY_classifier.csv` | 全量数据 240 行 ×（5120 特征 + 标签），47 MB |
| `XJTY_test_amp.csv` | 测试集：按幅值分组切分的 20% |
| `XJTY_train_amp.csv` | 训练集：按幅值分组切分的 80% |

csim 的 `testbench` 会从工程目录往上找 `data/` 与 `weights_csv/`，所以 HLS 工程要建在 `hls/hls_k26`。

若仓库体积受限，本目录可以换成外部下载链接（csim 会失败，但不影响上板）。