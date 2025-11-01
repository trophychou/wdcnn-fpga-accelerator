#!/usr/bin/env python3
# 从已保存的接收端日志里回放：解析 SLE 包 -> 拼 5120 点窗 -> 跑 FPGA 推理
import re
import sys
import time
import numpy as np

from wd_bench import Accel, IN_LEN

HEX_RE = re.compile(r'^[0-9a-fA-F]{1,2}(?: [0-9a-fA-F]{1,2})+\s*$')


def parse_pkt(txt):
    parts = txt.split()
    b = [int(x, 16) for x in parts]
    if len(b) < 9 or b[0] != 0xA5:
        return None
    dev = b[1]
    win = b[2] | (b[3] << 8)
    pkt = b[4] | (b[5] << 8)
    n = b[6] | (b[7] << 8)
    if pkt >= 32 or n > 160:
        return None
    if len(b) != 8 + n + 1:
        return None
    if (sum(b[:8 + n]) & 0xFF) != b[8 + n]:
        return None
    data = b[8:8 + n]
    return dev, win, pkt, data


def main():
    log = sys.argv[1] if len(sys.argv) > 1 else '/home/ubuntu/sw/sle_r10.log'
    limit = int(sys.argv[2]) if len(sys.argv) > 2 else 0
    acc = Accel()
    print('[OK] accel ready')

    bufs = {}      # (dev, win) -> {pkt: data}
    order = []
    total = 0
    bad = 0
    done = 0
    t_all = 0.0
    with open(log, 'r', errors='ignore') as f:
        for line in f:
            line = line.strip()
            if not HEX_RE.match(line):
                continue
            r = parse_pkt(line)
            if r is None:
                bad += 1
                continue
            total += 1
            dev, win, pkt, data = r
            key = (dev, win)
            if key not in bufs:
                bufs[key] = {}
                order.append(key)
            bufs[key][pkt] = data
            if len(bufs[key]) == 32:
                x = np.zeros(IN_LEN, dtype=np.int8)
                ok = True
                for i in range(32):
                    d = bufs[key].get(i)
                    if d is None:
                        ok = False
                        break
                    seg = np.array(d, dtype=np.int8)
                    x[i * 160:i * 160 + len(seg)] = seg
                if not ok:
                    continue
                out, dt = acc.run(x.reshape(1, -1))
                pred = int(np.argmax(out[0]))
                t_all += dt
                done += 1
                print('[WIN] dev=%d win=%d pred=%d dt=%.3f ms  n=%d bad=%d'
                      % (dev, win, pred, dt, total, bad), flush=True)
                del bufs[key]
                if limit and done >= limit:
                    print('[LIMIT] stop at %d windows' % done)
                    return

    avg = (t_all / done) if done else 0.0
    print('[SUM] windows=%d pkts=%d badpkt=%d avg=%.3f ms' % (done, total, bad, avg))


if __name__ == '__main__':
    main()
