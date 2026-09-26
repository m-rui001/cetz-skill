import numpy as np
from PIL import Image
from scipy import ndimage

NAME = 'dt11'
a = np.array(Image.open('src/%s-raw.png' % NAME).convert('L')) < 160
lab, n = ndimage.label(a, structure=np.ones((3, 3)))
comps = {i: (lab == i) for i in range(1, n + 1)}


def mkpts(mask):
    ys, xs = np.nonzero(mask)
    return np.stack([xs, ys], 1).astype(float)


def snap(pts, p, r=6.0, it=4):
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


P1 = mkpts(comps[1])
P23 = mkpts(comps[2] | comps[3])

# --- left curve: top tail -> crossing -> loop bottom -> left tip -> loop top -> crossing -> bottom tail
top = [(258, 16), (248, 38), (238, 60), (228, 82), (218, 104), (208, 126), (198, 146), (188, 160)]
lbot = [(168, 176), (145, 192), (120, 205), (95, 213), (70, 214), (48, 206), (30, 192), (20, 175)]
ltip = [(16, 165)]
ltop = [(24, 148), (40, 133), (62, 123), (88, 118), (112, 120), (136, 128), (158, 141), (178, 155), (188, 160)]
btm = [(200, 176), (212, 195), (224, 214), (237, 233), (250, 252), (262, 269), (271, 281)]
Lc = np.array([snap(P1, p) for p in top + lbot + ltip + ltop + btm])

# --- right curve: top tail -> bridge -> loop top -> left tip -> loop bottom -> hook -> bottom tail
rtop = [(922, 15), (912, 35), (900, 58), (888, 80), (876, 100), (864, 118), (856, 130)]
rbrg = [(846, 138), (834, 143)]
rltop = [(812, 137), (788, 127), (762, 114), (735, 107), (708, 110), (685, 122), (668, 140), (659, 158)]
rlbot = [(665, 178), (678, 193), (700, 204), (728, 209), (757, 205), (785, 193), (810, 178), (830, 164), (841, 155)]
rhook = [(846, 163), (851, 173)]
rbtm = [(868, 188), (892, 203), (920, 215), (952, 226), (985, 235), (1015, 242), (1022, 245)]
Rc = np.array([snap(P23, p, r=8.0) for p in rtop + rbrg + rltop + rlbot + rhook + rbtm])


def cover(poly, mask, dil=7):
    m = np.zeros(a.shape, bool)
    q = np.array(poly)
    for u, v in zip(q[:-1], q[1:]):
        L = int(np.hypot(*(v - u))) + 1
        for t in range(L + 1):
            x, y = u + (v - u) * t / L
            m[max(0, int(y) - 3):int(y) + 4, max(0, int(x) - 3):int(x) + 4] = True
    m = ndimage.binary_dilation(m, np.ones((dil, dil)))
    bad = mask & ~m
    ys, xs = np.nonzero(bad)
    return int(mask.sum()), int(bad.sum()), (xs.min(), xs.max(), ys.min(), ys.max()) if len(xs) else None


for tag, pl, mk in (('L', Lc, comps[1]), ('R', Rc, comps[2] | comps[3])):
    t, b, w = cover(pl, mk)
    print('%s ink %d uncovered %d (%.1f%%) where %s' % (tag, t, b, 100. * b / t, w))

S, Y0 = 148.0, 330.0


def fmt(poly):
    return '  line(path: true, %s, stroke: t)' % ', '.join('px(%.0f,%.0f)' % (p[0], p[1]) for p in poly)


body = ['#set page(width: auto, height: auto, margin: 2pt)',
        '#set text(size: 6.2pt)',
        '#import "@preview/cetz:0.4.2": canvas, draw',
        '',
        '#canvas({',
        '  import draw: *',
        '  let S = %.1f' % S,
        '  let px = (x, y) => (x / S, (%.1f - y) / S)' % Y0,
        '  let t = (thickness: 1.05pt)',
        '  let hd = (symbol: ">", fill: black, length: 6.1pt, width: 2.7pt)',
        '  let dk = (thickness: 1.05pt, dash: (5.7pt, 1.3pt))',
        '',
        fmt(Lc),
        fmt(Rc),
        '  line(px(293,161), px(497,161), stroke: dk, mark: (end: hd))',
        '  content(px(116, 305), anchor: "west", [#text(size: 6.4pt)[$"in " bold(R)^2$]])',
        '  content(px(835, 256), anchor: "center", [#text(size: 6.6pt)[Small deformation]])',
        '  content(px(806, 302), anchor: "west", [#text(size: 6.4pt)[$"in " bold(R)^3$]])',
        '})',
        '']
open('typ/%s-deform.typ' % NAME, 'w').write('\n'.join(body))
print('written typ/%s-deform.typ' % NAME)
