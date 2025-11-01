#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Single channel live receiver: parse sle_client hex log -> assemble windows -> infer."""
import os
import re
import sys
import time
import numpy as np

from wd_bench import Accel, IN_LEN

LOG = sys.argv[1] if len(sys.argv) > 1 else os.path.expanduser('~/sw/sle10.log')
DEV_WANT = int(sys.argv[2]) if len(sys.argv) > 2 else 0   # 0 = all devs

HEX_RE = re.compile(r'^[0-9a-fA-F]{1,2}(?: [0-9a-fA-F]{1,2})+\s*$')
PKTS_PER_WIN = 32
PTS_PER_PKT = 160


def parse_pkt(txt):
    b = bytes(int(x, 16) for x in txt.split())
    if len(b) < 9 or b[0] != 0xA5:
        return None
    dev, win, pkt, n = b[1], b[2] | (b[3] << 8), b[4] | (b[5] << 8), b[6] | (b[7] << 8)
    if len(b) != 8 + n + 1:
        return None
    if (sum(b[:8 + n]) & 0xFF) != b[8 + n]:
        return None
    if pkt >= PKTS_PER_WIN or n > PTS_PER_PKT:
        return None
    return dev, win, pkt, b[8:8 + n]


def main():
    acc = Accel()
    print('[OK] accel phys=0x%X dev=%s' % (acc.phys, DEV_WANT or 'all'), flush=True)

    f = open(LOG, 'r', errors='ignore')
    f.seek(0, os.SEEK_END)

    bufs = {}      # dev -> {'win': int, 'got': {pkt: data}, 'n': int}
    stats = {'pkt': 0, 'bad': 0, 'win': 0, 'ms': [], 'hit': 0, 'tot': 0}
    t_start = time.time()

    while True:
        line = f.readline()
        if not line:
            time.sleep(0.02)
            continue
        line = line.strip()
        if not HEX_RE.match(line):
            continue
        p = parse_pkt(line)
        if p is None:
            stats['bad'] += 1
            continue
        dev, win, pkt, data = p
        if DEV_WANT and dev != DEV_WANT:
            continue
        stats['pkt'] += 1

        s = bufs.get(dev)
        if s is None or win != s['win']:
            s = {'win': win, 'got': {}, 'n': 0}
            bufs[dev] = s
        if pkt in s['got']:
            continue
        s['got'][pkt] = data
        s['n'] += len(data)

        if len(s['got']) == PKTS_PER_WIN:
            win_arr = b''.join(s['got'][k] for k in range(PKTS_PER_WIN))
            if len(win_arr) != IN_LEN:
                stats['bad'] += 1
                bufs[dev] = None
                bufs.pop(dev)
                continue
            x = np.frombuffer(win_arr, dtype=np.int8).copy()
            out, dt = acc.run(x)
            pred = int(np.argmax(out[0]))
            stats['win'] += 1
            stats['ms'].append(dt * 1000.0)
            el = time.time() - t_start
            avg = sum(stats['ms']) / len(stats['ms'])
            print('[WIN] dev=%d win=%d pred=%d dt=%.2fms avg=%.2fms n=%d bad=%d rate=%.1f win/min'
                  % (dev, win, pred, dt * 1000.0, avg, stats['win'], stats['bad'],
                     stats['win'] * 60.0 / max(el, 1e-6)), flush=True)
            bufs[dev] = {'win': win + 1, 'got': {}, 'n': 0}


if __name__ == '__main__':
    main()
