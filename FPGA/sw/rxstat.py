#!/usr/bin/env python3
"""解析 wd_rx.bin（连续二进制帧），统计每台设备的包数/窗完整度。"""
import sys, os
from collections import defaultdict

PATH = sys.argv[1] if len(sys.argv) > 1 else '/home/ubuntu/sw/wd_rx.bin'
data = open(PATH, 'rb').read()
N = len(data)
i = 0
pkts = []          # (dev, win, pkt, n)
bad = 0
while i + 9 <= N:
    if data[i] != 0xA5:
        i += 1
        bad += 1 if bad == 0 else 0
        continue
    dev = data[i + 1]
    win = data[i + 2] | (data[i + 3] << 8)
    pkt = data[i + 4] | (data[i + 5] << 8)
    n = data[i + 6] | (data[i + 7] << 8)
    if n == 0 or n > 240 or i + 8 + n + 1 > N:
        i += 1
        continue
    s = sum(data[i:i + 8 + n]) & 0xFF
    if s != data[i + 8 + n]:
        i += 1
        continue
    pkts.append((dev, win, pkt, n))
    i += 8 + n + 1

print(f"file={PATH} bytes={N} frames={len(pkts)} hit_rate={len(pkts)*169/max(N,1):.2f}")
per = defaultdict(lambda: {'p': 0, 'w': defaultdict(int)})
for dev, win, pkt, n in pkts:
    d = per[dev]
    d['p'] += 1
    d['w'][win] += 1

for dev in sorted(per):
    d = per[dev]
    wins = d['w']
    full = sum(1 for v in wins.values() if v >= 32)
    part = sum(1 for v in wins.values() if 0 < v < 32)
    tot = sum(wins.values())
    print(f"dev{dev}: pkts={d['p']:5d} win={len(wins):3d} full={full:3d} part={part:3d} "
          f"pkts/win={tot/max(len(wins),1):5.1f}")
