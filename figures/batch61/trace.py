"""Walk along an ink curve and emit polyline vertices.

usage: python trace.py NAME x0 y0 dx dy [maxSteps]
Prints one "x,y" vertex every ~step px of travel. Stops when the walker finds no
ink ahead. Crossings are crossed by extrapolating the current direction.
"""
import sys
import numpy as np
from PIL import Image

n = sys.argv[1]
p = np.array([float(sys.argv[2]), float(sys.argv[3])])  # x, y
d = np.array([float(sys.argv[4]), float(sys.argv[5])], dtype=float)
d /= np.hypot(*d)
mx = int(sys.argv[6]) if len(sys.argv) > 6 else 120

a = np.array(Image.open('src/%s-raw.png' % n).convert('L')) < 100
H, W = a.shape
ys, xs = np.nonzero(a)
pts = np.stack([xs, ys], 1).astype(float)

STEP, RAD, PERP = 9.0, 13.0, 4.5
out = [p.copy()]
for _ in range(mx):
    tgt = out[-1] + d * STEP
    rel = pts - tgt
    r2 = (rel ** 2).sum(1)
    sel = r2 < RAD * RAD
    if not sel.any():
        break
    q = pts[sel]
    v = q - out[-1]
    fwd = v @ d
    perp = np.abs(v @ np.array([-d[1], d[0]]))
    ok = (fwd > STEP * 0.5) & (perp < PERP)
    if not ok.any():
        break
    cand = q[ok]
    nd = cand.mean(0) - out[-1]
    L = np.hypot(*nd)
    if L < 2:
        break
    nd /= L
    if nd @ d < 0:
        break
    d = 0.55 * d + 0.45 * nd
    d /= np.hypot(*d)
    out.append(cand.mean(0))

print('/* %s from %s dir %s, %d verts */' % (n, sys.argv[2:4], sys.argv[4:6], len(out)))
res = []
for i, v in enumerate(out):
    if i and i < len(out) - 1:
        pv, nx = out[i - 1], out[i + 1]
        if abs(((nx - v) @ d)) < 1e9:
            pass
    res.append('(%d,%d)' % (round(v[0]), round(v[1])))
print(','.join(res))
