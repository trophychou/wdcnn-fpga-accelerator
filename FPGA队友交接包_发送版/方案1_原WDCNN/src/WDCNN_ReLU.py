import torch
import torch.nn as nn

class WDCNN_ReLU(nn.Module):
    def __init__(self, n_classes=4):
        super(WDCNN_ReLU, self).__init__()
        self.feature = nn.Sequential(
            # L1
            nn.Conv1d(1, 16, 64, stride=7, padding=1),
            nn.BatchNorm1d(16),
            nn.ReLU(inplace=True), # 关键修改
            nn.MaxPool1d(2, 2),
            # L2
            nn.Conv1d(16, 32, 3, stride=1, padding=1),
            nn.BatchNorm1d(32),
            nn.ReLU(inplace=True),
            nn.MaxPool1d(2, 2),
            # L3
            nn.Conv1d(32, 64, 3, stride=1, padding=1),
            nn.BatchNorm1d(64),
            nn.ReLU(inplace=True),
            nn.MaxPool1d(2, 2),
            # L4
            nn.Conv1d(64, 64, 3, stride=1, padding=1),
            nn.BatchNorm1d(64),
            nn.ReLU(inplace=True),
            nn.MaxPool1d(2, 2),
            # L5
            nn.Conv1d(64, 64, 3, stride=1, padding=0),
            nn.BatchNorm1d(64),
            nn.ReLU(inplace=True),
            nn.MaxPool1d(2, 2),
            
            nn.Flatten()
        )
        self.fc = nn.Sequential(
            nn.Linear(1344, 100),
            nn.ReLU(inplace=True),
            nn.Linear(100, n_classes)
        )

    def forward(self, x):
        return self.fc(self.feature(x))