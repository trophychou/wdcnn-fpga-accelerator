import mmap, os, struct, sys, time
import numpy as np

CTRL = 0xA0010000
PTR  = 0xA0020000
DMA  = 0xA0000000

WD_SIZE = 4 * 1024 * 1024
W_OFF, I_OFF, B_OFF = 0x000000, 0x030000, 0x040000
IN_OFF, OUT_OFF = 0x100000, 0x200000

counts = [1024, 1536, 6144, 12288, 12288, 134400, 400]
incs   = [16, 32, 64, 64, 64, 100, 4]

REG_W = [0x010, 0x034, 0x058, 0x07C, 0x0A0, 0x0C4, 0x0E8]
REG_I = [0x01C, 0x040, 0x064, 0x088, 0x0AC, 0x0D0, 0x0F4]
REG_B = [0x028, 0x04C, 0x070, 0x094, 0x0B8, 0x0DC, 0x100]

R_AP_CTRL, R_GIE, R_IER, R_NUM, R_RELOAD = 0x00, 0x04, 0x08, 0x10, 0x18

IN_LEN, OUT_LEN = 5120, 4
N_TOTAL = 240

MM2S_CR, MM2S_SR = 0x00, 0x04
S2MM_CR, S2MM_SR = 0x30, 0x34


class IO:
    def __init__(self, base, size=0x1000):
        self.fd = os.open('/dev/mem', os.O_RDWR | os.O_SYNC)
        self.m = mmap.mmap(self.fd, size, offset=base)

    def rd(self, o):
        return struct.unpack('<I', self.m[o:o + 4])[0]

    def wr(self, o, v):
        self.m[o:o + 4] = struct.pack('<I', v)


HERE = os.path.dirname(os.path.abspath(__file__))
W = os.path.join(HERE, 'weights')


def load(name, dtype, count):
    a = np.fromfile(os.path.join(W, name), dtype=dtype)
    if a.size != count:
        raise SystemExit('[ERR] %s size %d != %d' % (name, a.size, count))
    return a


class Accel:
    def __init__(self):
        self.fd = os.open('/dev/wdmem', os.O_RDWR)
        self.buf = mmap.mmap(self.fd, WD_SIZE)
        self.phys = int(open('/sys/class/wdmem/wdmem/phys').read().strip(), 16)
        self.ctrl, self.ptr, self.dma = IO(CTRL), IO(PTR), IO(DMA)
        self.load_weights()

    def load_weights(self):
        b = self.buf
        base = W_OFF
        self.aw, self.ai, self.ab = [], [], []
        for k in range(7):
            d = load('w%d.bin' % (k + 1), np.int8, counts[k])
            b[base:base + d.size] = d.tobytes()
            self.aw.append(self.phys + base)
            base += (d.size + 63) & ~63
        base = I_OFF
        for k in range(7):
            d = load('i%d.bin' % (k + 1), np.int16, incs[k])
            b[base:base + d.nbytes] = d.tobytes()
            self.ai.append(self.phys + base)
            base += (d.nbytes + 63) & ~63
        base = B_OFF
        for k in range(7):
            d = load('b%d.bin' % (k + 1), np.int32, incs[k])
            b[base:base + d.nbytes] = d.tobytes()
            self.ab.append(self.phys + base)
            base += (d.nbytes + 63) & ~63

    def reset_dma(self):
        d = self.dma
        d.wr(MM2S_CR, 0x4)
        d.wr(S2MM_CR, 0x4)
        t0 = time.time()
        while (d.rd(MM2S_CR) & 0x4) or (d.rd(S2MM_CR) & 0x4):
            if time.time() - t0 > 2.0:
                break
            time.sleep(0.001)
        d.wr(MM2S_SR, 0x7000)
        d.wr(S2MM_SR, 0x7000)
        d.wr(MM2S_CR, 0x1)
        d.wr(S2MM_CR, 0x1)

    def run(self, x):
        n = x.size // IN_LEN
        self.buf[IN_OFF:IN_OFF + x.nbytes] = x.tobytes()
        for j in range(n * OUT_LEN):
            self.buf[OUT_OFF + j] = 0

        for k in range(7):
            for off, addr in ((REG_W[k], self.aw[k]), (REG_I[k], self.ai[k]),
                              (REG_B[k], self.ab[k])):
                self.ptr.wr(off, addr & 0xFFFFFFFF)
                self.ptr.wr(off + 4, (addr >> 32) & 0xFFFFFFFF)

        self.ctrl.wr(R_GIE, 0)
        self.ctrl.wr(R_IER, 0)
        self.ctrl.wr(R_NUM, n)
        self.ctrl.wr(R_RELOAD, 1 if getattr(self, 'cold', True) else 0)
        self.cold = False

        self.reset_dma()
        self.ctrl.wr(R_AP_CTRL, 0x1)

        d = self.dma
        d.wr(0x48, self.phys + OUT_OFF)
        d.wr(0x58, n * OUT_LEN)
        d.wr(0x18, self.phys + IN_OFF)
        d.wr(0x28, n * IN_LEN)

        t0 = time.time()
        while True:
            sr = d.rd(S2MM_SR)
            if (sr & 0x1000) and (sr & 0x2):
                break
            if sr & 0x1:
                raise SystemExit('[ERR] s2mm halted sr=0x%08X' % sr)
            if sr & 0x4000:
                raise SystemExit('[ERR] s2mm int_err sr=0x%08X' % sr)
            if time.time() - t0 > 5.0:
                raise SystemExit('[ERR] s2mm timeout sr=0x%08X mm2s=0x%08X ctrl=0x%08X' %
                                 (sr, d.rd(MM2S_SR), self.ctrl.rd(R_AP_CTRL)))
        dt = time.time() - t0

        out = np.frombuffer(bytes(self.buf[OUT_OFF:OUT_OFF + n * OUT_LEN]),
                            dtype=np.int8).reshape(n, OUT_LEN)
        return out, dt


def main():
    n = int(sys.argv[1]) if len(sys.argv) > 1 else 1
    rep = int(sys.argv[2]) if len(sys.argv) > 2 else 1

    acc = Accel()
    print('[OK] wdmem phys=0x%X' % acc.phys)

    x = load('wd_input.bin', np.int8, N_TOTAL * IN_LEN).reshape(N_TOTAL, IN_LEN)
    labels = load('wd_label.bin', np.uint8, N_TOTAL)

    for r in range(rep):
        out, dt = acc.run(x[:n].reshape(-1))
        pred = np.argmax(out, axis=1)
        ok = int((pred == labels[:n]).sum())
        print('[RUN %d] %d samples  %.3f ms total  %.1f us/sample  acc %d/%d' %
              (r, n, dt * 1e3, dt * 1e6 / n, ok, n))
        for i in range(min(n, 8)):
            print('   #%d scores=%5d %5d %5d %5d pred=%d label=%d' %
                  (i, out[i][0], out[i][1], out[i][2], out[i][3],
                   pred[i], labels[i]))
        if n > 8:
            bad = np.where(pred != labels[:n])[0]
            print('   mismatch idx:', bad[:20].tolist(), 'count', len(bad))
    print('AP_CTRL=0x%08X S2MM_SR=0x%08X MM2S_SR=0x%08X' %
          (acc.ctrl.rd(R_AP_CTRL), acc.dma.rd(S2MM_SR), acc.dma.rd(MM2S_SR)))
    return 0


if __name__ == '__main__':
    sys.exit(main())
