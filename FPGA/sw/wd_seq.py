import sys
import numpy as np
import wd_bench as B

N_DEFAULT = 240


def main():
    n = int(sys.argv[1]) if len(sys.argv) > 1 else N_DEFAULT
    acc = B.Accel()
    print('[OK] wdmem phys=0x%X' % acc.phys)

    x = B.load('wd_input.bin', np.int8, B.N_TOTAL * B.IN_LEN).reshape(B.N_TOTAL, B.IN_LEN)
    labels = B.load('wd_label.bin', np.uint8, B.N_TOTAL)

    t0 = None
    ok = 0
    tsum = 0.0
    for i in range(n):
        out, dt = acc.run(x[i].reshape(-1))
        tsum += dt
        p = int(np.argmax(out[0]))
        if p == labels[i]:
            ok += 1
        if i < 8 or (i % 60 == 59):
            print('  #%3d pred=%d label=%d  %.2f ms' % (i, p, labels[i], dt * 1e3))
    print('[SEQ] %d windows  correct %d/%d  total %.1f ms  avg %.2f ms/window' %
          (n, ok, n, tsum * 1e3, tsum * 1e3 / n))
    return 0


N_DEFAULT = 240

if __name__ == '__main__':
    sys.exit(main())
