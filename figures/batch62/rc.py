import sys, numpy as np
from PIL import Image
# usage: python rc.py NAME col|row x0 x1 y0 y1 step   (col: iterate x, report y centers; row: iterate y, report x centers)
n, axis = sys.argv[1], sys.argv[2]
x0, x1, y0, y1, st = map(int, sys.argv[3:8])
a = np.array(Image.open('src/%s-raw.png' % n).convert('L')) < 128
def runs(v):
    idx = np.nonzero(v)[0]; out = []
    if len(idx) == 0: return out
    s = p = idx[0]
    for i in idx[1:]:
        if i > p + 1: out.append((s, p)); s = i
        p = i
    out.append((s, p)); return out
for k in range(x0 if axis == 'col' else y0, (x1 if axis == 'col' else y1) + 1, st):
    line = a[k, x0:x1 + 1] if axis == 'row' else a[y0:y1 + 1, k]
    r = runs(line)
    off = x0 if axis == 'row' else y0
    print(k, [((s + p) / 2 + off, p - s + 1) for s, p in r])
