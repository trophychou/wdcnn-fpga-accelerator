#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""wd_bin.py —— 实时跟随 /home/ubuntu/sw/wd_rx.bin，按设备拼窗并跑 HLS 推理，结果直接打印到终端。

用法：sudo python3 wd_bin.py [N_DEV] [BINPATH]
      N_DEV 默认 7（只打印 dev<=N 的结果）
"""
import os
import sys
import time
from collections import defaultdict

import numpy as np

sys.path.insert(0, '/home/ubuntu/sw')
from wd_bench import Accel, IN_LEN  # noqa: E402

CLASSES = ['class0', 'class1', 'class2', 'class3']
NDEV = int(sys.argv[1]) if len(sys.argv) > 1 else 7
PATH = sys.argv[2] if len(sys.argv) > 2 else '/home/ubuntu/sw/wd_rx.bin'

PKTS_PER_WIN = 32
PTS_PER_PKT = 160


def parse_frames(buf, start):
    """从 buf[start:] 解帧，返回 (frames, next_pos)。帧不完整时停在帧头。"""
    frames = []
    i = start
    n = len(buf)
    while i + 8 <= n:
        if buf[i] != 0xA5:
            i += 1
            continue
        dev = buf[i + 1]
        win = buf[i + 2] | (buf[i + 3] << 8)
        pkt = buf[i + 4] | (buf[i + 5] << 8)
        ln = buf[i + 6] | (buf[i + 7] << 8)
        if ln == 0 or ln > 240:
            i += 1
            continue
        end = i + 8 + ln
        if end + 1 > n:
            break
        csum = sum(buf[i:end]) & 0xFF
        if csum != buf[end]:
            i += 1
            continue
        frames.append((dev, win, pkt, bytes(buf[i + 8:end]), end))
        i = end + 1
    return frames, i


def main():
    acc = Accel()
    print('[OK] accel ready, devs=1..%d, bin=%s' % (NDEV, PATH), flush=True)

    wins = defaultdict(dict)      # dev -> win -> {pkt: data}
    stamp = defaultdict(dict)     # dev -> win -> first_seen
    stat = {'pkts': 0, 'wins': defaultdict(int), 't0': time.time()}
    pos = 0
    buf = bytearray()
    f = None
    last_stat = time.time()

    while True:
        try:
            if f is None:
                f = open(PATH, 'rb')
                f.seek(0, os.SEEK_END)
                pos = f.tell()
                buf.clear()
            size = os.path.getsize(PATH)
            if size < pos:                      # 文件被重建
                f.close()
                f = None
                wins.clear()
                stamp.clear()
                continue
            if size == pos:
                time.sleep(0.05)
                continue
            f.seek(pos)
            chunk = f.read(size - pos)
            pos = size
            buf.extend(chunk)
            frames, used = parse_frames(buf, 0)
            if used:
                del buf[:used]

            for dev, win, pkt, data, _ in frames:
                stat['pkts'] += 1
                if dev > NDEV or len(data) != PTS_PER_PKT:
                    continue
                d = wins[dev]
                w = d.get(win)
                if w is None:
                    if len(d) > 2:              # 只留最近几个未完成的窗
                        oldest = min(d)
                        d.pop(oldest, None)
                        stamp[dev].pop(oldest, None)
                    w = d[win] = {}
                    stamp[dev][win] = time.time()
                if pkt in w:
                    continue
                w[pkt] = data
                if len(w) == PKTS_PER_WIN:
                    x = np.frombuffer(b''.join(w[k] for k in range(PKTS_PER_WIN)),
                                      dtype=np.int8).copy()
                    d.pop(win, None)
                    stamp[dev].pop(win, None)
                    out, dt = acc.run(x)
                    vec = out[0]
                    code = int(np.argmax(vec))
                    stat['wins'][dev] += 1
                    print('[DEV%d] win=%d code=%d raw=[%s] dt=%.2fms wins=%d'
                          % (dev, win, code,
                             ','.join(str(int(v)) for v in vec), dt * 1000.0,
                             stat['wins'][dev]), flush=True)

            # 清理 4 秒还没凑齐的窗
            now = time.time()
            for dev in list(stamp):
                for win, ts in list(stamp[dev].items()):
                    if now - ts > 4.0:
                        stamp[dev].pop(win, None)
                        wins[dev].pop(win, None)

            if now - last_stat > 10.0:
                last_stat = now
                el = now - stat['t0']
                parts = ' '.join('D%d:%d' % (k, stat['wins'][k])
                                 for k in sorted(stat['wins']))
                print('[STAT] %.1fs pkts=%d %s rate=%.1f/min'
                      % (el, stat['pkts'], parts,
                         sum(stat['wins'].values()) * 60.0 / max(el, 1e-9)),
                      flush=True)
        except KeyboardInterrupt:
            break
        except Exception as e:                  # 单窗失败不影响整体
            print('[WARN] %s: %s' % (type(e).__name__, e), flush=True)
            acc.reset_dma()
            time.sleep(0.2)

    print('[DONE]', flush=True)


if __name__ == '__main__':
    main()
