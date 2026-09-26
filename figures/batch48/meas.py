from PIL import Image
import numpy as np
import sys

a = np.asarray(Image.open(sys.argv[1]).convert('L'))
ink = a < 160
H, W = ink.shape

def vruns(x, y0=0, y1=None):
    y1 = y1 or H
    col = ink[y0:y1, x]
    out, s = [], None
    for i, v in enumerate(col):
        if v and s is None: s = i
        if not v and s is not None: out.append((y0 + s, y0 + i - 1)); s = None
    if s is not None: out.append((y0 + s, y0 + y1 - 1))
    return out

def hruns(y, x0=0, x1=None):
    x1 = x1 or W
    row = ink[y, x0:x1]
    out, s = [], None
    for i, v in enumerate(row):
        if v and s is None: s = i
        if not v and s is not None: out.append((x0 + s, x0 + i - 1)); s = None
    if s is not None: out.append((x0 + s, x0 + x1 - 1))
    return out

mode = sys.argv[2]
if mode == 'v':
    for x in [int(v) for v in sys.argv[3:]]:
        print('x=%d' % x, vruns(x))
elif mode == 'h':
    for y in [int(v) for v in sys.argv[3:]]:
        print('y=%d' % y, hruns(y))
elif mode == 'cols':
    # column ink profile: report x ranges where a column has >=k ink px
    k = int(sys.argv[3])
    c = ink.sum(0)
    s = None
    for x in range(W):
        if c[x] >= k and s is None: s = x
        if c[x] < k and s is not None: print(s, x - 1); s = None
    if s is not None: print(s, W - 1)
elif mode == 'rows':
    k = int(sys.argv[3])
    r = ink.sum(1)
    s = None
    for y in range(H):
        if r[y] >= k and s is None: s = y
        if r[y] < k and s is not None: print(s, y - 1); s = None
    if s is not None: print(s, H - 1)
