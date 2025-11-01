import time
import numpy as np
import wd_bench as B

N = 20


def main():
    acc = B.Accel()
    x = B.load('wd_input.bin', np.int8, B.N_TOTAL * B.IN_LEN).reshape(B.N_TOTAL, B.IN_LEN)
    ctrl, ptr, d = acc.ctrl, acc.ptr, acc.dma

    t_copy = t_reset = t_ptr = t_wait = 0.0
    for i in range(N):
        t0 = time.time()
        acc.buf[B.IN_OFF:B.IN_OFF + B.IN_LEN] = x[i].tobytes()
        t1 = time.time()
        acc.reset_dma()
        t2 = time.time()
        for k in range(7):
            for off, addr in ((B.REG_W[k], acc.aw[k]), (B.REG_I[k], acc.ai[k]),
                              (B.REG_B[k], acc.ab[k])):
                ptr.wr(off, addr & 0xFFFFFFFF)
                ptr.wr(off + 4, (addr >> 32) & 0xFFFFFFFF)
        t3 = time.time()
        ctrl.wr(B.R_NUM, 1)
        ctrl.wr(B.R_RELOAD, 1)
        ctrl.wr(B.R_AP_CTRL, 0x1)
        d.wr(0x48, acc.phys + B.OUT_OFF)
        d.wr(0x58, 4)
        d.wr(0x18, acc.phys + B.IN_OFF)
        d.wr(0x28, B.IN_LEN)
        while not (d.rd(B.S2MM_SR) & 0x1000):
            pass
        t4 = time.time()
        t_copy += t1 - t0
        t_reset += t2 - t1
        t_ptr += t3 - t2
        t_wait += t4 - t3
    n = float(N)
    print('[PROF] per window: copy %.2f ms  reset %.2f ms  ptr %.2f ms  hw %.2f ms  total %.2f ms' %
          (t_copy * 1e3 / n, t_reset * 1e3 / n, t_ptr * 1e3 / n, t_wait * 1e3 / n,
           (t_copy + t_reset + t_ptr + t_wait) * 1e3 / n))
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
