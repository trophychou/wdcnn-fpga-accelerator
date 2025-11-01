#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""把 wave_spec_ref.bin（新合成器的整数输出）喂进 HLS 模型，验证每类被判成对应类别。"""
import sys

import numpy as np

sys.path.insert(0, '/home/ubuntu/sw')
from wd_bench import Accel, IN_LEN  # noqa: E402

path = sys.argv[1] if len(sys.argv) > 1 else '/home/ubuntu/sw/wave_spec_ref.bin'
x = np.fromfile(path, dtype=np.int8)
print('bytes=%d windows=%d' % (x.size, x.size // IN_LEN))
acc = Accel()
ok = 0
tot = 0
for k in range(x.size // IN_LEN):
    w = x[k * IN_LEN:(k + 1) * IN_LEN]
    expect = k // 4
    out, dt = acc.run(w)
    code = int(np.argmax(out[0]))
    ok += (code == expect)
    tot += 1
    print('#%02d expect=%d got=%d raw=[%s] dt=%.2fms' %
          (k, expect, code, ','.join(str(int(v)) for v in out[0]), dt * 1000))
print('RESULT %d/%d' % (ok, tot))
