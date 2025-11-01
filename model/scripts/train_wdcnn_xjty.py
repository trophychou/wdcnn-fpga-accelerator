import json
import os
import random

import numpy as np
import pandas as pd
import torch
import torch.nn as nn
from torch.utils.data import DataLoader, TensorDataset

from WDCNN_ReLU import WDCNN_ReLU


ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DATA_DIR = os.path.join(ROOT, "data")
OUTPUT_DIR = os.path.join(ROOT, "output")

TRAIN_CSV = os.path.join(DATA_DIR, "XJTY_train_amp.csv")
TEST_CSV = os.path.join(DATA_DIR, "XJTY_test_amp.csv")

MODEL_PATH = os.path.join(OUTPUT_DIR, "wdcnn_relu.pth")
REPORT_PATH = os.path.join(OUTPUT_DIR, "wdcnn_relu_train_report.json")

SEED = 2026
NUM_CLASSES = 4
FEATURE_LENGTH = 5120
BATCH_SIZE = 32
EPOCHS = 20
LEARNING_RATE = 1e-3

DEVICE = torch.device("cuda" if torch.cuda.is_available() else "cpu")


def set_seed(seed):
    random.seed(seed)
    np.random.seed(seed)
    torch.manual_seed(seed)

    if torch.cuda.is_available():
        torch.cuda.manual_seed_all(seed)

    torch.backends.cudnn.deterministic = True
    torch.backends.cudnn.benchmark = False


def load_csv_dataset(path):
    if not os.path.exists(path):
        raise FileNotFoundError(path)

    array = pd.read_csv(path, header=None).values.astype(np.float32)

    if array.ndim != 2 or array.shape[1] != FEATURE_LENGTH + 1:
        raise RuntimeError(
            f"Expected [N, {FEATURE_LENGTH + 1}] CSV, got {array.shape}: {path}"
        )

    x = array[:, :-1]
    y = array[:, -1].astype(np.int64)

    if np.any(y < 0) or np.any(y >= NUM_CLASSES):
        raise RuntimeError(f"Invalid labels in {path}: {np.unique(y)}")

    x = torch.from_numpy(x).unsqueeze(1)
    y = torch.from_numpy(y)

    return TensorDataset(x, y), y.numpy()


def evaluate(model, loader, criterion):
    model.eval()

    total_loss = 0.0
    correct = 0
    total = 0
    confusion = np.zeros((NUM_CLASSES, NUM_CLASSES), dtype=np.int64)

    with torch.no_grad():
        for x, y in loader:
            x = x.to(DEVICE)
            y = y.to(DEVICE)

            logits = model(x)
            loss = criterion(logits, y)

            total_loss += float(loss.item()) * y.size(0)

            pred = torch.argmax(logits, dim=1)
            correct += int(torch.sum(pred == y).item())
            total += y.size(0)

            y_cpu = y.cpu().numpy()
            pred_cpu = pred.cpu().numpy()

            for true_label, pred_label in zip(y_cpu, pred_cpu):
                confusion[int(true_label), int(pred_label)] += 1

    return total_loss / total, correct / total, correct, total, confusion


def print_class_counts(name, labels):
    print(f"{name} class counts:")
    for class_id in range(NUM_CLASSES):
        print(f"  class {class_id}: {int(np.sum(labels == class_id))}")


def main():
    os.makedirs(OUTPUT_DIR, exist_ok=True)
    set_seed(SEED)

    train_dataset, train_labels = load_csv_dataset(TRAIN_CSV)
    test_dataset, test_labels = load_csv_dataset(TEST_CSV)

    print("Device:", DEVICE)
    print("Train:", len(train_dataset), "samples")
    print("Test :", len(test_dataset), "samples")

    print_class_counts("train", train_labels)
    print_class_counts("test", test_labels)

    generator = torch.Generator()
    generator.manual_seed(SEED)

    train_loader = DataLoader(
        train_dataset,
        batch_size=BATCH_SIZE,
        shuffle=True,
        num_workers=0,
        generator=generator,
    )

    test_loader = DataLoader(
        test_dataset,
        batch_size=BATCH_SIZE,
        shuffle=False,
        num_workers=0,
    )

    model = WDCNN_ReLU(n_classes=NUM_CLASSES).to(DEVICE)

    with torch.no_grad():
        probe = torch.zeros(2, 1, FEATURE_LENGTH).to(DEVICE)
        out = model(probe)
        if tuple(out.shape) != (2, NUM_CLASSES):
            raise RuntimeError(f"Unexpected model output shape: {tuple(out.shape)}")

    print(f"Model shape check: [N, 1, {FEATURE_LENGTH}] -> [N, {NUM_CLASSES}]")

    criterion = nn.CrossEntropyLoss()
    optimizer = torch.optim.Adam(model.parameters(), lr=LEARNING_RATE)

    print("\nTraining begins. The independent test set is not used for optimization.")

    epoch_rows = []

    for epoch in range(1, EPOCHS + 1):
        model.train()

        total_loss = 0.0
        correct = 0
        total = 0

        for x, y in train_loader:
            x = x.to(DEVICE)
            y = y.to(DEVICE)

            optimizer.zero_grad()

            logits = model(x)
            loss = criterion(logits, y)

            loss.backward()
            optimizer.step()

            total_loss += float(loss.item()) * y.size(0)
            pred = torch.argmax(logits, dim=1)
            correct += int(torch.sum(pred == y).item())
            total += y.size(0)

        train_loss = total_loss / total
        train_acc = correct / total

        epoch_rows.append({
            "epoch": epoch,
            "train_loss": train_loss,
            "train_accuracy": train_acc,
        })

        print(
            f"Epoch {epoch:03d}/{EPOCHS} | "
            f"train_loss={train_loss:.6f} | "
            f"train_acc={100.0 * train_acc:.2f}%"
        )

    test_loss, test_acc, test_correct, test_total, confusion = evaluate(
        model,
        test_loader,
        criterion,
    )

    torch.save(model.state_dict(), MODEL_PATH)

    report = {
        "model": "WDCNN_ReLU",
        "dataset": "XJTY",
        "train_csv": TRAIN_CSV,
        "test_csv": TEST_CSV,
        "model_path": MODEL_PATH,
        "seed": SEED,
        "num_classes": NUM_CLASSES,
        "feature_length": FEATURE_LENGTH,
        "epochs": EPOCHS,
        "batch_size": BATCH_SIZE,
        "learning_rate": LEARNING_RATE,
        "train_samples": int(len(train_dataset)),
        "test_samples": int(len(test_dataset)),
        "test_loss": float(test_loss),
        "test_accuracy": float(test_acc),
        "test_correct": int(test_correct),
        "test_total": int(test_total),
        "confusion_rows_true_cols_pred": confusion.tolist(),
        "epoch_log": epoch_rows,
    }

    with open(REPORT_PATH, "w", encoding="utf-8") as file:
        json.dump(report, file, indent=2)

    print("\n========== FINAL TEST REPORT ==========")
    print(
        "Accuracy: %.2f%% (%d/%d)"
        % (100.0 * test_acc, test_correct, test_total)
    )
    print("Loss: %.6f" % test_loss)
    print("Confusion matrix, rows=true, cols=pred:")
    print(confusion)
    print("\nSaved model :", MODEL_PATH)
    print("Saved report:", REPORT_PATH)


if __name__ == "__main__":
    main()