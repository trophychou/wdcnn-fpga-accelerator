import json
import os
import sys
import numpy as np
import torch
import torch.nn.functional as F

from WDCNN_ReLU import WDCNN_ReLU


ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
MODEL_JSON = os.path.join(ROOT, "model.json")

CALIB_PER_CLASS = 100
CALIB_MARGIN = 1.0
INT8_MIN = -128
INT8_MAX = 127
INC_MIN = 1
INC_MAX = 32767
SHIFT_MIN = 10
SHIFT_MAX = 17


def abs_path(path):
    if os.path.isabs(path):
        return path
    return os.path.join(ROOT, path)


def load_csv(path):
    arr = np.loadtxt(path, delimiter=",", dtype=np.float32)
    x = arr[:, :-1].astype(np.float32)
    y = arr[:, -1].astype(np.int64)
    return x, y


def confusion_matrix(y_true, y_pred, num_classes):
    mat = np.zeros((num_classes, num_classes), dtype=np.int64)
    for t, p in zip(y_true, y_pred):
        mat[int(t), int(p)] += 1
    return mat


def choose_balanced_calib(x, y, per_class, num_classes):
    xs = []
    ys = []
    for c in range(num_classes):
        idx = np.where(y == c)[0]
        if len(idx) < per_class:
            raise RuntimeError(
                "class %d has only %d train samples, need %d"
                % (c, len(idx), per_class)
            )
        idx = idx[:per_class]
        xs.append(x[idx])
        ys.append(y[idx])
    return np.concatenate(xs, axis=0), np.concatenate(ys, axis=0)


def fuse_conv_bn(conv, bn):
    w = conv.weight.detach().cpu().float()
    b = conv.bias.detach().cpu().float()
    gamma = bn.weight.detach().cpu().float()
    beta = bn.bias.detach().cpu().float()
    mean = bn.running_mean.detach().cpu().float()
    var = bn.running_var.detach().cpu().float()
    eps = bn.eps

    scale = gamma / torch.sqrt(var + eps)
    w_fused = w * scale.reshape(-1, 1, 1)
    b_fused = (b - mean) * scale + beta
    return w_fused, b_fused


def choose_inc_shift(multiplier):
    best = None
    for shift in range(SHIFT_MIN, SHIFT_MAX + 1):
        inc = int(round(multiplier * (1 << shift)))
        if INC_MIN <= inc <= INC_MAX:
            err = abs(multiplier - inc / float(1 << shift))
            cand = (err, shift, inc)
            if best is None or cand < best:
                best = cand

    if best is None:
        raise RuntimeError(
            "cannot represent multiplier %.12e with inc in [%d,%d]"
            % (multiplier, INC_MIN, INC_MAX)
        )

    _, shift, inc = best
    return inc, shift


def qclip(x):
    return torch.clamp(torch.round(x), INT8_MIN, INT8_MAX)


def conv1d_int(x_int, w_q, b_q, stride, padding, inc, shift):
    acc = F.conv1d(
        x_int.float(),
        w_q.float(),
        bias=None,
        stride=stride,
        padding=padding,
    )
    y = acc * (float(inc) / float(1 << shift))
    y = y + b_q.reshape(1, -1, 1).float()
    return qclip(y)


def linear_int(x_int, w_q, b_q, inc, shift):
    acc = F.linear(x_int.float(), w_q.float(), bias=None)
    y = acc * (float(inc) / float(1 << shift))
    y = y + b_q.reshape(1, -1).float()
    return qclip(y)


def eval_fp32(model, x_np, y_np, num_classes):
    model.eval()
    x = torch.from_numpy(x_np).float().reshape(-1, 1, x_np.shape[1])
    with torch.no_grad():
        logits = model(x)
        pred = torch.argmax(logits, dim=1).cpu().numpy()

    correct = int(np.sum(pred == y_np))
    mat = confusion_matrix(y_np, pred, num_classes)
    return correct, pred, mat


def collect_quant_params(model, calib_x, train_x):
    model.eval()

    x = torch.from_numpy(calib_x).float().reshape(-1, 1, calib_x.shape[1])
    train_absmax = float(np.max(np.abs(train_x)))
    if train_absmax <= 0:
        train_absmax = 1.0

    s_in_global = 127.0 / (train_absmax * CALIB_MARGIN)

    layers = []

    conv_defs = [
        ("L1", "Conv1", model.feature[0], model.feature[1]),
        ("L2", "Conv2", model.feature[4], model.feature[5]),
        ("L3", "Conv3", model.feature[8], model.feature[9]),
        ("L4", "Conv4", model.feature[12], model.feature[13]),
        ("L5", "Conv5", model.feature[16], model.feature[17]),
    ]

    cur = x
    cur_scale = s_in_global

    with torch.no_grad():
        for lid, lname, conv, bn in conv_defs:
            w_f, b_f = fuse_conv_bn(conv, bn)

            out = F.conv1d(
                cur,
                w_f,
                b_f,
                stride=conv.stride[0],
                padding=conv.padding[0],
            )
            out = F.relu(out)
            out = F.max_pool1d(out, kernel_size=2, stride=2)

            w_absmax = float(torch.max(torch.abs(w_f)).item())
            out_absmax = float(torch.max(torch.abs(out)).item())

            if w_absmax <= 0:
                w_absmax = 1.0
            if out_absmax <= 0:
                out_absmax = 1.0

            s_w = 127.0 / w_absmax
            s_out = 127.0 / (out_absmax * CALIB_MARGIN)

            multiplier = s_out / (cur_scale * s_w)
            inc, shift = choose_inc_shift(multiplier)

            layers.append({
                "id": lid,
                "name": lname,
                "type": "conv",
                "inc": inc,
                "shift": shift,
                "w_bit": 8,
                "s_in": cur_scale,
                "s_w": s_w,
                "s_out": s_out,
                "stride": int(conv.stride[0]),
                "padding": int(conv.padding[0]),
                "weight": w_f,
                "bias": b_f,
            })

            cur = out
            cur_scale = s_out

        cur = torch.flatten(cur, 1)

        fc_defs = [
            ("L6", "FC1", model.fc[0], True),
            ("L7", "FC2", model.fc[2], False),
        ]

        for lid, lname, fc, has_relu in fc_defs:
            w = fc.weight.detach().cpu().float()
            b = fc.bias.detach().cpu().float()

            out = F.linear(cur, w, b)
            if has_relu:
                out = F.relu(out)

            w_absmax = float(torch.max(torch.abs(w)).item())
            out_absmax = float(torch.max(torch.abs(out)).item())

            if w_absmax <= 0:
                w_absmax = 1.0
            if out_absmax <= 0:
                out_absmax = 1.0

            s_w = 127.0 / w_absmax
            s_out = 127.0 / (out_absmax * CALIB_MARGIN)

            multiplier = s_out / (cur_scale * s_w)
            inc, shift = choose_inc_shift(multiplier)

            layers.append({
                "id": lid,
                "name": lname,
                "type": "fc",
                "inc": inc,
                "shift": shift,
                "w_bit": 8,
                "s_in": cur_scale,
                "s_w": s_w,
                "s_out": s_out,
                "has_relu": has_relu,
                "weight": w,
                "bias": b,
            })

            cur = out
            cur_scale = s_out

    return s_in_global, layers


def eval_int8(x_np, y_np, layers, s_in_global, num_classes):
    x = torch.from_numpy(x_np).float().reshape(-1, 1, x_np.shape[1])
    cur = qclip(x * s_in_global)

    with torch.no_grad():
        for layer in layers:
            w_q = qclip(layer["weight"] * layer["s_w"])
            b_q = torch.round(layer["bias"] * layer["s_out"]).to(torch.int32)

            if layer["type"] == "conv":
                cur = conv1d_int(
                    cur,
                    w_q,
                    b_q,
                    stride=layer["stride"],
                    padding=layer["padding"],
                    inc=layer["inc"],
                    shift=layer["shift"],
                )
                cur = torch.clamp(cur, 0, INT8_MAX)
                cur = F.max_pool1d(cur, kernel_size=2, stride=2)

            elif layer["type"] == "fc":
                if len(cur.shape) > 2:
                    cur = torch.flatten(cur, 1)

                cur = linear_int(
                    cur,
                    w_q,
                    b_q,
                    inc=layer["inc"],
                    shift=layer["shift"],
                )

                if layer["has_relu"]:
                    cur = torch.clamp(cur, 0, INT8_MAX)

            else:
                raise RuntimeError("unknown layer type: %s" % layer["type"])

        pred = torch.argmax(cur, dim=1).cpu().numpy()

    correct = int(np.sum(pred == y_np))
    mat = confusion_matrix(y_np, pred, num_classes)
    return correct, pred, mat


def main():
    with open(MODEL_JSON, "r", encoding="utf-8") as f:
        cfg = json.load(f)

    model_path = abs_path(cfg["model_path"])

    ds_cfg = cfg["dataset_config"]
    train_path = abs_path(ds_cfg["train_path"])
    test_path = abs_path(ds_cfg["test_path"])
    num_classes = int(ds_cfg["num_classes"])

    qcfg_path = abs_path(
        cfg.get("quantization_config", {}).get(
            "output_path",
            "quant_config.json",
        )
    )

    report_path = os.path.join(
        ROOT,
        "output",
        "wdcnn_relu_quant_report.json",
    )

    print("========== CONFIG ==========")
    print("Model JSON :", MODEL_JSON)
    print("Model PTH  :", model_path)
    print("Train CSV  :", train_path)
    print("Test CSV   : deferred until quant config is fixed")
    print("Output QCFG:", qcfg_path)

    train_x, train_y = load_csv(train_path)

    print()
    print("========== TRAIN DATA ==========")
    print("Train shape      :", train_x.shape)
    calib_x, calib_y = choose_balanced_calib(
        train_x,
        train_y,
        CALIB_PER_CLASS,
        num_classes,
    )
    print("Calibration shape:", calib_x.shape)
    for c in range(num_classes):
        print("Calibration class %d: %d" % (c, int(np.sum(calib_y == c))))

    model = WDCNN_ReLU(n_classes=num_classes)
    state = torch.load(model_path, map_location="cpu")
    model.load_state_dict(state)
    model.eval()

    print()
    print("========== TRAIN-ONLY CALIBRATION ==========")
    s_in_global, layers = collect_quant_params(model, calib_x, train_x)

    print("Input absmax train: %.8f" % float(np.max(np.abs(train_x))))
    print("S_IN_SCALE        : %.10f" % s_in_global)

    qcfg = {
        "S_IN_SCALE": s_in_global,
    }

    for layer in layers:
        qcfg[layer["id"]] = {
            "name": layer["name"],
            "inc": int(layer["inc"]),
            "shift": int(layer["shift"]),
            "w_bit": int(layer["w_bit"]),
        }
        print(
            "%s %s: inc=%d shift=%d s_in=%.8f s_w=%.8f s_out=%.8f"
            % (
                layer["id"],
                layer["name"],
                layer["inc"],
                layer["shift"],
                layer["s_in"],
                layer["s_w"],
                layer["s_out"],
            )
        )

    os.makedirs(os.path.dirname(qcfg_path), exist_ok=True)
    with open(qcfg_path, "w", encoding="utf-8") as f:
        json.dump(qcfg, f, indent=2)

    print()
    print("Quant config fixed and saved.")
    print("No test sample has been loaded before this point.")

    test_x, test_y = load_csv(test_path)

    fp32_correct, fp32_pred, fp32_mat = eval_fp32(
        model,
        test_x,
        test_y,
        num_classes,
    )

    int8_correct, int8_pred, int8_mat = eval_int8(
        test_x,
        test_y,
        layers,
        s_in_global,
        num_classes,
    )

    print()
    print("========== FINAL TEST ONLY ==========")
    print(
        "FP32 accuracy: %d/%d = %.4f"
        % (fp32_correct, len(test_y), fp32_correct / len(test_y))
    )
    print("FP32 confusion matrix rows=true cols=pred:")
    print(fp32_mat)

    print(
        "INT8 accuracy: %d/%d = %.4f"
        % (int8_correct, len(test_y), int8_correct / len(test_y))
    )
    print("INT8 confusion matrix rows=true cols=pred:")
    print(int8_mat)

    report = {
        "model_json": MODEL_JSON,
        "model_path": model_path,
        "train_path": train_path,
        "test_path": test_path,
        "num_classes": num_classes,
        "calibration_policy": "train_only_balanced",
        "calib_per_class": CALIB_PER_CLASS,
        "s_in_scale": s_in_global,
        "fp32_correct": fp32_correct,
        "fp32_total": int(len(test_y)),
        "fp32_accuracy": fp32_correct / len(test_y),
        "int8_correct": int8_correct,
        "int8_total": int(len(test_y)),
        "int8_accuracy": int8_correct / len(test_y),
        "fp32_confusion": fp32_mat.tolist(),
        "int8_confusion": int8_mat.tolist(),
        "layers": {
            k: v for k, v in qcfg.items()
            if k.startswith("L")
        },
    }

    os.makedirs(os.path.dirname(report_path), exist_ok=True)
    with open(report_path, "w", encoding="utf-8") as f:
        json.dump(report, f, indent=2)

    print("Saved quant config:", qcfg_path)
    print("Saved quant report:", report_path)


if __name__ == "__main__":
    main()