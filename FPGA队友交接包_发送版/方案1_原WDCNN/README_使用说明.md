# 原四分类 WDCNN：推理与 FPGA 源码交接

这是最初工程的已训练模型交接，不含训练代码、训练CSV、原始合并数据CSV、虚拟环境、软件安装包和缓存。模型未重新训练，原文件保持不变。

## 包含内容

- models/wdcnn_relu.pth：原FP32模型权重，与原工程SHA-256完全一致。
- src/WDCNN_ReLU.py：原网络结构源码，按原样复制。
- src/predict_wdcnn.py：新增的轻量推理入口，仅预测和对给定标签统计准确率，不训练、不校准。
- models/quant_config.json：原量化配置，保留现有整数参数。
- models/original_model_config.json：原完整结构与工程配置的来源存档。里面的训练/输出路径来自原工程，不是本包启动入口，不要据此寻找训练CSV。
- hls/：原归档的HLS顶层、testbench、配置、tcl、硬件库和7层整数权重/偏置CSV，按原样复制。
- data/XJTY_test_amp.csv：仅保留原240条测试向量，供软件复测和HLS testbench读取；这是小型测试输入，不是训练集或缓存。
- examples/four_classes.npz：从原测试集每类取1条，共4条演示输入；fields为samples、labels。
- examples/four_classes_expected.json：4条示例的CPU预期输出。
- reports/历史软件复测结果.json：原软件复测记录，不包含训练权重迭代或训练数据。
- reports/本次交接验证.json：本次240条CPU复核结果。
- 来源校验.json：30个原样复制文件与原项目的SHA-256对应关系。

## 运行

从“原WDCNN”目录打开PowerShell。Python 3.13已验证，CPU即可。自行安装运行依赖，本包不附带环境：

```powershell
python -m pip install -r requirements.txt
python src/predict_wdcnn.py --input examples/four_classes.npz --device cpu --output demo_result.json
python src/predict_wdcnn.py --input data/XJTY_test_amp.csv --device cpu --output test_result.json
```

原复测使用torch 2.11.0+cu128、numpy 2.5.4；本包依赖清单固定torch 2.11.0和numpy 2.5.4，CPU运行不要求CUDA。若已有兼容的CUDA版PyTorch，可以用--device cuda或--device auto。CUDA版依赖需队友按自身显卡和驱动单独配置，本包没有GPU环境安装脚本。

建议WDCNN与外层RF方案分别安装依赖：两者保存时NumPy版本不同（WDCNN 2.5.4；RF 2.5.1），本包没有验证把两者混装在同一环境。无需安装训练用的pandas或绘图库。

## 输入与输出

输入为单通道振动，每个样本5120个连续数值：

- CSV无表头：每行5120列信号，可选最后一列标签0/1/2/3，共5121列。
- NPY：[5120]、[N,5120]或[N,1,5120]。
- NPZ：samples为上述信号数组，labels可选且形状为[N]。

推理代码内部转为float32，不自动归一化、不自动乘127、不切窗、不重采样。应输入与原XJTY CSV一致的预处理和幅值数值体系。原数据的原始传感器单位、采样率以及从原始采集到CSV的完整预处理说明尚未确认，不能把任意新振动波形直接输入后声称可靠。

输出predictions为0/1/2/3类别编号，logits为四类原始网络得分，softmax_scores为四类归一化分数，不是经校准的正确概率。输入有标签时额外输出evaluation、准确率与混淆矩阵。

**原0/1/2/3代表何种损伤程度，仍缺少确认依据。不要把它们直接解释为轻/中/重或与新模型三类逐一对应。** 两套模型使用不同数据、任务和输入格式，不能把新方案的同步三通道窗口直接传入WDCNN。

## 已验证结果

本次CPU重新读取原权重，在原240条测试向量上240/240正确，且交接入口的全部FP32 logits与直接调用原网络/原权重逐元素完全一致。4条示例预测为[0,1,2,3]。

240条是原有固定测试集；划分源自按类及幅值区间的样本划分，不构成已证明的整轴承隔离测试。100%不能与新方案的30轮跨轴承84.25%直接比较，也不能理解为任意未见轴承有100%正确率。

## FPGA 同学怎么接

hls/保留原文件相对结构；testbench读取weights_csv/参数，向上查找data/XJTY_test_amp.csv，本包已在父级data/提供240条原测试向量。不要移走其中的权重CSV、config.hpp或测试文件。

具备相应Vitis HLS工具时，可进入hls/运行原run_hls.tcl。该脚本会reset其自身hls_project，然后依次做C仿真、综合、RTL协同仿真；建议先复制到个人工作目录再运行。本次没有执行这些硬件工具，源码齐全不等于HLS仿真或上板已通过。

原浮点模型和整数HLS计算规则不是同一个数值接口，不应直接逐位比较浮点logits与INT8输出。原testbench包含输入缩放、取整和截断逻辑；原config/参数为量化推理依据。本包未重新量化或重新导出权重。
