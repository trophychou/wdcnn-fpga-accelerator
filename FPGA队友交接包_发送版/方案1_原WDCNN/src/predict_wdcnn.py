"""Saved original four-class WDCNN inference. No training or calibration."""
import argparse
import hashlib
import json
from pathlib import Path
import numpy as np
import torch
from WDCNN_ReLU import WDCNN_ReLU
ROOT = Path(__file__).resolve().parents[1]
MODEL_SHA256 = '362e592f3ab72e1367f1afeec402920de2917442ce08930e7d9cfd9a8b86580b'

def predict(samples, device='cpu', batch_size=32):
    samples = np.asarray(samples, dtype=np.float32)
    if samples.ndim == 1:
        samples = samples[None, None, :]
    elif samples.ndim == 2:
        samples = samples[:, None, :]
    if samples.ndim != 3 or samples.shape[1:] != (1, 5120) or not len(samples):
        raise ValueError('Expected [5120], [N,5120] or [N,1,5120].')
    if not np.isfinite(samples).all():
        raise ValueError('Input must be finite.')
    if device not in ('cpu','cuda','auto') or batch_size < 1:
        raise ValueError('Invalid device or batch size.')
    if device == 'auto':
        device = 'cuda' if torch.cuda.is_available() else 'cpu'
    if device == 'cuda' and not torch.cuda.is_available():
        raise RuntimeError('CUDA not available; use CPU or install CUDA-enabled PyTorch.')
    torch.set_num_threads(min(4, torch.get_num_threads()))
    if device == 'cuda':
        torch.backends.cuda.matmul.allow_tf32 = False
        torch.backends.cudnn.allow_tf32 = False
        torch.backends.cudnn.benchmark = False
        torch.backends.cudnn.deterministic = True
    model_path = ROOT/'models/wdcnn_relu.pth'
    with model_path.open('rb') as f:
        if hashlib.file_digest(f, 'sha256').hexdigest() != MODEL_SHA256:
            raise ValueError('Original model hash mismatch.')
    model = WDCNN_ReLU(n_classes=4)
    model.load_state_dict(torch.load(model_path, map_location='cpu', weights_only=True))
    model.to(device).eval()
    outputs = []
    with torch.inference_mode():
        for start in range(0, len(samples), batch_size):
            outputs.append(model(torch.from_numpy(np.ascontiguousarray(samples[start:start+batch_size])).to(device)).cpu())
    logits = torch.cat(outputs)
    probabilities = torch.softmax(logits,dim=1)
    return {'class_order':[0,1,2,3], 'label_meaning':'Original numeric classes; severity semantics not verified.',
            'predictions':logits.argmax(1).tolist(), 'logits':logits.tolist(),
            'softmax_scores':probabilities.tolist(), 'device':device,
            'model_sha256':MODEL_SHA256, 'torch_version':torch.__version__,
            'scope':'FP32 software inference. Softmax scores are not calibrated reliability.'}

def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--input', type=Path, required=True)
    parser.add_argument('--device', choices=('cpu','cuda','auto'), default='cpu')
    parser.add_argument('--batch-size', type=int, default=32)
    parser.add_argument('--output', type=Path)
    args = parser.parse_args()
    path = args.input
    labels = None
    if path.suffix.lower() == '.csv':
        data = np.loadtxt(path,delimiter=',',dtype=np.float32,ndmin=2)
        if data.shape[1] not in (5120,5121):
            raise ValueError('CSV must have 5120 features, optionally one final label column.')
        samples = data[:,:5120]
        if data.shape[1] == 5121: labels = data[:,-1]
    elif path.suffix.lower() == '.npy':
        samples = np.load(path,allow_pickle=False)
    elif path.suffix.lower() == '.npz':
        with np.load(path,allow_pickle=False) as data:
            samples = data['samples'].copy()
            if 'labels' in data.files: labels = data['labels'].copy()
    else: raise ValueError('Use CSV, NPY or NPZ.')
    result = predict(samples,args.device,args.batch_size)
    if labels is not None:
        labels = np.asarray(labels)
        predictions = np.asarray(result['predictions'])
        if labels.shape != predictions.shape or not np.isfinite(labels).all() or np.any(labels != np.floor(labels)) or np.any((labels < 0) | (labels > 3)):
            raise ValueError('Labels must be [N] integers 0..3.')
        confusion = np.zeros((4,4),dtype=int)
        np.add.at(confusion,(labels.astype(int),predictions),1)
        result['evaluation'] = {'samples':len(labels),'correct':int((labels == predictions).sum()),
                                'accuracy':float((labels == predictions).mean()),
                                'confusion_rows_true_columns_predicted':confusion.tolist(),
                                'scope':'Only the supplied labeled samples; no independence claim.'}
    value = json.dumps(result,ensure_ascii=False,indent=2)
    if args.output:
        args.output.parent.mkdir(parents=True,exist_ok=True)
        args.output.write_text(value,encoding='utf-8')
    print(value)

if __name__ == '__main__':
    main()
