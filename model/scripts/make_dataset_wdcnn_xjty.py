import os
import pandas as pd
import numpy as np

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

INPUT_CSV = os.path.join(ROOT, "data", "XJTY_classifier.csv")
TRAIN_CSV = os.path.join(ROOT, "data", "XJTY_train_amp.csv")
TEST_CSV = os.path.join(ROOT, "data", "XJTY_test_amp.csv")

# 每 5 个样本中取 1 个作为测试集，即 20% 测试集
GROUP_SIZE = 5

# 为了避免总是取每组同一个位置，可以固定随机种子在组内选测试样本
SEED = 42
rng = np.random.default_rng(SEED)

# 读取原始 CSV，无表头
df = pd.read_csv(INPUT_CSV, header=None)

feature_cols = df.columns[:-1]
label_col = df.columns[-1]

train_parts = []
test_parts = []

print("原始数据总数:", len(df))
print("原始类别分布:")
print(df[label_col].value_counts().sort_index())
print()

for label, group in df.groupby(label_col):
    group = group.copy()

    # 计算每条样本的最大绝对幅值 max_abs
    features = group[feature_cols].values.astype(np.float32)
    group["_max_abs"] = np.max(np.abs(features), axis=1)

    # 按幅值从小到大排序
    group = group.sort_values("_max_abs").reset_index(drop=True)

    train_indices = []
    test_indices = []

    # 每 GROUP_SIZE 个样本为一个幅值小区间
    for start in range(0, len(group), GROUP_SIZE):
        block = list(range(start, min(start + GROUP_SIZE, len(group))))

        if len(block) == 1:
            # 极端情况：只剩 1 个样本，放训练集
            train_indices.extend(block)
            continue

        # 每组随机选 1 个进测试集，其余进训练集
        test_local = rng.choice(block, size=1, replace=False)[0]

        for idx in block:
            if idx == test_local:
                test_indices.append(idx)
            else:
                train_indices.append(idx)

    train_g = group.loc[train_indices].drop(columns=["_max_abs"])
    test_g = group.loc[test_indices].drop(columns=["_max_abs"])

    train_parts.append(train_g)
    test_parts.append(test_g)

    print(f"类别 {int(label)}:")
    print(f"  总数: {len(group)}")
    print(f"  训练: {len(train_g)}")
    print(f"  测试: {len(test_g)}")
    print(f"  原始 max_abs 范围: {group['_max_abs'].min():.6f} ~ {group['_max_abs'].max():.6f}")

    train_max = np.max(np.abs(train_g[feature_cols].values.astype(np.float32)))
    test_max = np.max(np.abs(test_g[feature_cols].values.astype(np.float32)))
    print(f"  训练 max_abs: {train_max:.6f}")
    print(f"  测试 max_abs: {test_max:.6f}")
    print()

# 合并各类别
train_df = pd.concat(train_parts, axis=0)
test_df = pd.concat(test_parts, axis=0)

# 打乱最终顺序，避免按类别排列
train_df = train_df.sample(frac=1, random_state=SEED).reset_index(drop=True)
test_df = test_df.sample(frac=1, random_state=SEED).reset_index(drop=True)

# 保存
train_df.to_csv(TRAIN_CSV, index=False, header=False)
test_df.to_csv(TEST_CSV, index=False, header=False)

print("=" * 60)
print("划分完成！")
print(f"训练集保存至: {TRAIN_CSV}")
print(f"测试集保存至: {TEST_CSV}")
print()

print("训练集类别分布:")
print(train_df.iloc[:, -1].value_counts().sort_index())
print()

print("测试集类别分布:")
print(test_df.iloc[:, -1].value_counts().sort_index())
print()

# 额外检查：整体幅值范围
train_features = train_df.iloc[:, :-1].values.astype(np.float32)
test_features = test_df.iloc[:, :-1].values.astype(np.float32)

print("整体幅值范围检查:")
print(f"训练集 max_abs: {np.max(np.abs(train_features)):.6f}")
print(f"测试集 max_abs: {np.max(np.abs(test_features)):.6f}")

print()
print("建议下一步:")
print("1. 用 XJTY_train_amp.csv 重新训练模型")
print("2. 用 XJTY_train_amp.csv 重新量化校准")
print("3. 用 XJTY_test_amp.csv 跑 HLS/FPGA 测试")