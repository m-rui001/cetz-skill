"""Generate typ/dt62-spiral.typ from ink walks, and report label/arrow geometry."""
import numpy as np
from PIL import Image

a = (np.array(Image.open('src/dt62-raw.png').convert('L')) < 100)
H, W = a.shape
ys, xs = np.nonzero(a)
PTS = np.stack([xs, ys], 1).astype(float)


def walk(p0, d0, n, step=9.0, rad=13.0, perp=4.5):
    p = np.array(p0, float)
    d = np.array(d0, float)
    d /= np.hypot(*d)
    out = [p.copy()]
    for _ in range(n):
        tgt = out[-1] + d * step
        rel = PTS - tgt
        sel = (rel ** 2).sum(1) < rad * rad
        if not sel.any():
            break
        q = PTS[sel]
        v = q - out[-1]
        ok = (v @ d > step * 0.5) & (np.abs(v @ np.array([-d[1], d[0]])) < perp)
        if not ok.any():
            break
        c = q[ok]
        nd = c.mean(0) - out[-1]
        L = np.hypot(*nd)
        if L < 2:
            break
        nd /= L
        if nd @ d < 0:
            break
        d = 0.55 * d + 0.45 * nd
        d /= np.hypot(*d)
        out.append(c.mean(0))
    return out, d


def runs(v, off=0):
    idx = np.nonzero(v)[0]
    out = []
    if len(idx) == 0:
        return out
    s = p = idx[0]
    for i in idx[1:]:
        if i > p + 1:
            out.append((int((s + p) / 2 + off), int(p - s + 1)))
            s = i
        p = i
    out.append((int((s + p) / 2 + off), int(p - s + 1)))
    return out


def bb(y0, y1, x0, x1):
    m = a[y0:y1, x0:x1]
    p = np.argwhere(m)
    if len(p) == 0:
        return None
    return (int(p[:, 1].min() + x0), int(p[:, 1].max() + x0),
            int(p[:, 0].min() + y0), int(p[:, 0].max() + y0), int(m.sum()))


L, _ = walk((300, 622), (-1, 0), 460)
R, _ = walk((300, 622), (1, 0), 260)
sp = L[::-1] + R[1:]
sp = [(round(p[0]), round(p[1])) for p in sp]
print('spiral verts left/right/total', len(L), len(R), len(sp))
print('left end', sp[0], 'right end', sp[-1])

print('arrow cols', [(x, runs(a[360:500, x], 360)) for x in (700, 760, 820, 870, 900)])
print('labels  X', bb(430, 510, 0, 45), ' z0', bb(215, 265, 385, 445),
      ' z1', bb(340, 395, 545, 605), ' r', bb(430, 480, 875, 925))
print('formula', bb(270, 345, 750, 1300))

with open('sp62.txt', 'w') as fh:
    fh.write(','.join('(%d,%d)' % p for p in sp))
