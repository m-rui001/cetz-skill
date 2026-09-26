import numpy as np
from PIL import Image
from scipy import ndimage

NAME = 'dt40'
a = np.array(Image.open('src/%s-raw.png' % NAME).convert('L')) < 160
lab, n = ndimage.label(a, structure=np.ones((3, 3)))
comps = {i: (lab == i) for i in range(1, n + 1)}


def mkpts(mask):
    ys, xs = np.nonzero(mask)
    return np.stack([xs, ys], 1).astype(float)


def snap(pts, p, r=5.0, it=4):
    q = np.array(p, float)
    for _ in range(it):
        sel = ((pts - q) ** 2).sum(1) < r * r
        if not sel.any():
            return q
        nq = pts[sel].mean(0)
        if np.hypot(*(nq - q)) < 0.4:
            return nq
        q = nq
    return q


def chain(mask, axis, lo, hi, step, pick, r=5.0, need=1):
    pts = mkpts(mask)
    out = []
    for k in range(lo, hi + (1 if step > 0 else -1), step):
        v = mask[:, k] if axis == 0 else mask[k, :]
        idx = np.nonzero(v)[0]
        if not len(idx):
            continue
        s = p = idx[0]
        runs = []
        for i in idx[1:]:
            if i > p + 1:
                runs.append((s, p))
                s = i
            p = i
        runs.append((s, p))
        if len(runs) < need:
            continue
        s, p = runs[pick if pick >= 0 else len(runs) + pick]
        out.append(snap(pts, (k, (s + p) / 2) if axis == 0 else ((s + p) / 2, k), r=r))
    return np.array(out)


PX = mkpts(comps[3])
Xv = [(63.5, 28), (66, 44), (68, 52), (70, 60), (72.5, 68), (75.5, 76), (78, 84),
      (81.5, 92), (85.5, 100), (89.5, 108), (94.5, 116), (99, 124), (104.5, 132),
      (109.5, 140), (115.5, 148), (124, 158), (133, 167), (142, 177), (154, 189),
      (166, 197), (178, 209), (190, 218), (202, 225), (214, 233), (226, 241),
      (238, 247), (250, 253), (262, 259), (274, 264), (286, 269), (292, 271)]
Zv = [(20, 289), (22, 285), (34, 268), (46, 251), (58, 237), (70, 224), (82, 211),
      (94, 200), (106, 189), (118, 179), (126, 172), (136, 163), (142, 160),
      (154, 152), (166, 145), (178, 138), (190, 132), (202, 127), (214, 122),
      (226, 118), (238, 114), (250, 111), (262, 108), (274, 106), (286, 105),
      (298, 104), (310, 103), (317, 102)]
LX = np.array([snap(PX, p, r=6.0) for p in Xv])
LZ = np.array([snap(PX, p, r=6.0) for p in Zv])

# two small angle-marker arcs: point-symmetric about the crossing
A1 = np.array([snap(PX, p, r=4.0) for p in
               [(109, 162), (110, 156), (113, 151), (118, 147), (124, 144), (130, 142), (132, 143)]])
C = np.array([139.0, 172.0])
A2 = 2 * C - A1[::-1]

RX = chain(comps[2], 1, 20, 302, 6, -1)
RZu = chain(comps[6], 0, 782, 938, 6, 0)
RZl = chain(comps[18], 0, 687, 774, 6, 0)


def cover(polys, mask, dil=7):
    m = np.zeros(a.shape, bool)
    for q in polys:
        q = np.array(q)
        for u, v in zip(q[:-1], q[1:]):
            L = int(np.hypot(*(v - u)) * 1.5) + 1
            for t in range(L + 1):
                x, y = u + (v - u) * t / L
                m[max(0, int(y) - 3):int(y) + 4, max(0, int(x) - 3):int(x) + 4] = True
    m = ndimage.binary_dilation(m, np.ones((dil, dil)))
    bad = mask & ~m
    return int(mask.sum()), int(bad.sum())


print('left  ', cover([LX, LZ, A1, A2], comps[3]))
print('rightX', cover([RX], comps[2]))
print('rightZ', cover([RZu, RZl], comps[6] | comps[18]))

S, Y0 = 148.0, 321.0


def fmt(poly, st='t'):
    return '  line(path: true, %s, stroke: %s)' % (
        ', '.join('px(%.0f,%.0f)' % (p[0], p[1]) for p in poly), st)


body = ['#set page(width: auto, height: auto, margin: 2pt)',
        '#set text(size: 6.2pt)',
        '#import "@preview/cetz:0.4.2": canvas, draw',
        '',
        '#canvas({',
        '  import draw: *',
        '  let S = %.1f' % S,
        '  let px = (x, y) => (x / S, (%.1f - y) / S)' % Y0,
        '  let t = (thickness: 1.05pt)',
        '  let hd = (symbol: ">", fill: black, length: 9.7pt, width: 3.1pt)',
        '  let dk = (thickness: 1.05pt, dash: (4.2pt, 1.3pt))',
        '',
        fmt(LX),
        fmt(LZ),
        fmt(A1),
        fmt(A2),
        fmt(RX),
        fmt(RZu),
        fmt(RZl),
        '  line(px(323,176), px(583,176), stroke: dk, mark: (end: hd))',
        '  content(px(37, 35), anchor: "center", [#text(size: 6.4pt)[$X$]])',
        '  content(px(303.5, 122.5), anchor: "center", [#text(size: 6.4pt)[$Z$]])',
        '  content(px(128.5, 198), anchor: "center", [#text(size: 6.4pt)[$U$]])',
        '  content(px(640, 31), anchor: "center", [#text(size: 6.4pt)[$X_i$]])',
        '  content(px(925.5, 111), anchor: "center", [#text(size: 6.4pt)[$Z$]])',
        '})',
        '']
open('typ/%s-cross.typ' % NAME, 'w').write('\n'.join(body))
print('written typ/%s-cross.typ' % NAME)
