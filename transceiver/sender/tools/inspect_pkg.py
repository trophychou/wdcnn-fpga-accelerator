import os
import re
import struct
import sys

PATHS = [
    r'D:\FPGAProject\firmware\out\dev1.fwpkg',
    r'D:\AMDDesignTools\BEARPI\ws63-liteos-app_all.fwpkg',
]


def dump(p):
    d = open(p, 'rb').read()
    print('== %s  %d bytes' % (os.path.basename(p), len(d)))
    print('   head: %s' % d[:32].hex())
    names = [m.group().decode() for m in re.finditer(rb'[ -~]{5,40}\.bin', d[:400000])]
    print('   names(%d): %s' % (len(names), names[:14]))
    return d


def main():
    for p in PATHS:
        if not os.path.exists(p):
            print('missing: %s' % p)
            continue
        dump(p)
        print()
    # compare the app payload sizes by scanning for the largest contiguous block
    for p in PATHS:
        if not os.path.exists(p):
            continue
        d = open(p, 'rb').read()
        print('%s  size=0x%X (%d)' % (os.path.basename(p), len(d), len(d)))
    return 0


if __name__ == '__main__':
    sys.exit(main())
