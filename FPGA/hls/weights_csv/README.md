# FPGA/hls/weights_csv —— int8 权重 CSV


`01_Conv1_w.csv` … `07_FC2_b.csv` 共 14 个，由 `model/scripts/make_quant_config.py` 生成，
与 `model/weights_int8_csv/` 内容一致。

csim 读 CSV 转 int8 与 PyTorch 结果比对；上板时用 `FPGA/sw/weights/*.bin`。

## 文件

| 文件 | Last commit message |
|---|---|
| `01_Conv1_b.csv` | 第 1 层 Conv1 的偏置（int8 CSV） |
| `01_Conv1_w.csv` | 第 1 层 Conv1 的权重（int8 CSV） |
| `02_Conv2_b.csv` | 第 2 层 Conv2 的偏置（int8 CSV） |
| `02_Conv2_w.csv` | 第 2 层 Conv2 的权重（int8 CSV） |
| `03_Conv3_b.csv` | 第 3 层 Conv3 的偏置（int8 CSV） |
| `03_Conv3_w.csv` | 第 3 层 Conv3 的权重（int8 CSV） |
| `04_Conv4_b.csv` | 第 4 层 Conv4 的偏置（int8 CSV） |
| `04_Conv4_w.csv` | 第 4 层 Conv4 的权重（int8 CSV） |
| `05_Conv5_b.csv` | 第 5 层 Conv5 的偏置（int8 CSV） |
| `05_Conv5_w.csv` | 第 5 层 Conv5 的权重（int8 CSV） |
| `06_FC1_b.csv` | 第 6 层 FC1 的偏置（int8 CSV） |
| `06_FC1_w.csv` | 第 6 层 FC1 的权重（int8 CSV） |
| `07_FC2_b.csv` | 第 7 层 FC2 的偏置（int8 CSV） |
| `07_FC2_w.csv` | 第 7 层 FC2 的权重（int8 CSV） |
