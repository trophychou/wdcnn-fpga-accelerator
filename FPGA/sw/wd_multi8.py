#!/usr/bin/env python3
# 8-channel real-time receiver: tail SLE client log, demux by packet dev byte,
# assemble 5120-point windows, run FPGA inference.
#   sudo python3 wd_multi8.py /home/ubuntu/sw/sle_r13.log
#   sudo python3 wd_multi8.py /home/ubuntu/sw/sle_r10.log --sim 8
import os
import re
import sys
import time
import numpy as np

from wd_bench import Accel

N_DEV = 8
PKT_PTS = 160
PKTS = 32
WIN_PTS = PKT_PTS * PKTS
HEX_RE = re.compile(r'^[0-9a-fA-F]{1,2}(?: [0-9a-fA-F]{1,2})+\s*$')
CLASS_NAME = ['NORMAL', 'OUTER', 'INNER', 'BALL']


def parse_pkt(txt):
    b = [int(x, 16) for x in txt.split()]
    if len(b) < 9:
        return None
    n = b[6] | (b[7] << 8)
    if b[0] != 0xA5 or len(b) != 8 + n + 1 or n > PKT_PTS:
        return None
    if (sum(b[:8 + n]) & 0xFF) != b[8 + n]:
        return None
    return b[1], (b[2] | (b[3] << 8)), (b[4] | (b[5] << 8)), b[8:8 + n]


class Win:
    __slots__ = ('buf', 'got')

    def __init__(self):
        self.buf = bytearray(WIN_PTS)
        self.got = 0


class Dev:
    def __init__(self, dev_id):
        self.id = dev_id
        self.wins = {}
        self.done = 0
        self.pred_cnt = [0, 0, 0, 0]
        self.pkts = 0
        self.t_hw = 0.0
        self.last = -1

    def feed(self, win, pkt, data):
        self.pkts += 1
        w = self.wins.get(win)
        if w is None:
            w = Win()
            self.wins[win] = w
            if len(self.wins) > 64:
                for k in sorted(self.wins)[:-48]:
                    self.wins.pop(k, None)
        w.buf[pkt * PKT_PTS:pkt * PKT_PTS + len(data)] = bytes(data)
        w.got += 1
        if w.got >= PKTS:
            del self.wins[win]
            return win, np.frombuffer(bytes(w.buf), dtype=np.int8).reshape(1, WIN_PTS)
        return None


def run_safe(acc, x):
    for _ in range(3):
        try:
            return acc.run(x)
        except SystemExit as e:
            print('[WARN] %s -> reset dma' % e, flush=True)
            try:
                acc.reset_dma()
            except Exception:
                pass
            time.sleep(0.05)
    raise SystemExit('[ERR] accel dead')


def main():
    log = sys.argv[1] if len(sys.argv) > 1 else '/home/ubuntu/sw/sle_r13.log'
    sim = 0
    for i, a in enumerate(sys.argv):
        if a == '--sim' and i + 1 < len(sys.argv):
            sim = int(sys.argv[i + 1])

    acc = Accel()
    print('[OK] accel ready log=%s sim=%d' % (log, sim), flush=True)

    devs = [Dev(i + 1) for i in range(N_DEV)]
    t0 = time.time()
    npk = 0
    last_report = t0
    tail = b''
    f = open(log, 'rb')
    f.seek(0, os.SEEK_END)

    def handle(line):
        nonlocal npk
        s = line.decode('ascii', 'ignore').strip()
        if len(s) < 40 or not HEX_RE.match(s):
            return
        r = parse_pkt(s)
        if r is None:
            return
        d, win, pkt, data = r
        if sim:
            d = (win % sim) + 1
        if not (1 <= d <= N_DEV):
            return
        npk += 1
        dv = devs[d - 1]
        res = dv.feed(win, pkt, data)
        if res is None:
            return
        w, x = res
        out, dt = run_safe(acc, x)
        p = int(np.argmax(out[0]))
        dv.done += 1
        dv.pred_cnt[p] += 1
        dv.t_hw += dt
        dv.last = p
        print('[DEV%d] win=%-5d pred=%d(%s) dt=%.2fms wins=%d rate=%.1f/min'
              % (d, w, p, CLASS_NAME[p], dt * 1000, dv.done,
                 dv.done * 60.0 / max(1e-3, time.time() - t0)), flush=True)

    try:
        while True:
            chunk = f.read()
            if chunk:
                tail += chunk
                if b'\n' in tail:
                    parts = tail.split(b'\n')
                    tail = parts.pop()
                    for ln in parts:
                        handle(ln)
            now = time.time()
            if now - last_report >= 10:
                last_report = now
                el = now - t0
                parts = []
                for dv in devs:
                    if dv.done or dv.pkts:
                        best = CLASS_NAME[dv.pred_cnt.index(max(dv.pred_cnt))] if dv.done else '-'
                        parts.append('D%d:%dw/%dp/%s' % (dv.id, dv.done, dv.pkts, best))
                print('[STAT] %5.1fs pkts=%d %s' % (el, npk, ' '.join(parts)), flush=True)
            time.sleep(0.005 if sim else 0.02)
    except KeyboardInterrupt:
        pass


if __name__ == '__main__':
    main()
