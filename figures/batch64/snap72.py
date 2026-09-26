import numpy as np
from PIL import Image
from scipy import ndimage

NAME = 'dt72'
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


def chain(mask, axis, lo, hi, step, pick, band=None, r=5.0, need=1):
    """walk columns (axis=0 -> x) or rows, take run #pick, snap to mask ink"""
    pts = mkpts(mask)
    out = []
    for k in range(lo, hi + 1, step):
        v = mask[:, k] if axis == 0 else mask[k, :]
        idx = np.nonzero(v)[0]
        if band is not None:
            idx = idx[(idx >= band[0]) & (idx <= band[1])]
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

def chain_near(mask, axis, lo, hi, step, seed, r=5.0):
    """walk columns/rows picking the run nearest the previous point (continuity)"""
    pts = mkpts(mask)
    out, prev = [], np.array(seed, float)
    for k in range(lo, hi + (1 if hi > lo else -1), step):
        v = mask[:, k] if axis == 0 else mask[k, :]
        idx = np.nonzero(v)[0]
        if not len(idx):
            continue
        s0 = p0 = idx[0]
        rr = []
        for i in idx[1:]:
            if i > p0 + 1:
                rr.append((s0 + p0) / 2)
                s0 = i
            p0 = i
        rr.append((s0 + p0) / 2)
        c = rr[int(np.argmin(np.abs(np.array(rr) - prev[1 - axis])))]
        q = snap(pts, (k, c) if axis == 0 else (c, k), r=r)
        out.append(q)
        prev = q
    return np.array(out)


def blob(cid, x0, x1, y0, y1, capw=14):
    m = comps[cid]
    up = chain(m, 0, x0, x1, 6, 0, need=2)
    lo = chain(m, 0, x0, x1, 6, -1, need=2)[::-1]
    rgt = chain(m & (np.arange(a.shape[1]) >= x1 - capw)[None, :], 1, y0, y1, 5, -1)
    lft = chain(m & (np.arange(a.shape[1]) <= x0 + capw)[None, :], 1, y0, y1, 5, 0)[::-1]
    return np.vstack([up, rgt, lo, lft])


# --- blob X: continuity-chained top/bottom + row caps
upX = chain(comps[1], 0, 27, 419, 4, 0, need=2)
loX = chain(comps[1], 0, 27, 419, 4, -1, need=2)[::-1]
Xc = np.vstack([upX, loX])
print('X n', len(Xc))

# --- blob Z main outline: columns 845..1055 + left cap through the peanut
upZa = chain(comps[2], 0, 845, 989, 4, 0, need=2)
upZb = chain_near(comps[2], 0, 991, 1055, 2, (989, 56))
loZ = chain(comps[2], 0, 845, 1055, 4, -1, need=2)[::-1]
rgtZ = chain(comps[2] & (np.arange(a.shape[1]) >= 1041)[None, :], 1, 175, 212, 5, -1)
cap = np.array([(843, 232), (839, 218), (836, 198), (836, 178), (838, 158), (843, 138)])
cap = np.array([snap(mkpts(comps[2]), p, r=4.0) for p in cap])
Zc = np.vstack([upZa, upZb, loZ, cap])

# --- peanut V_i: columns 793..881 within y band 138..196
upP = chain(comps[2], 0, 795, 879, 4, 0, band=(138, 196))
loP = chain(comps[2], 0, 795, 879, 4, -1, band=(138, 196))[::-1]
Pc = np.vstack([upP, loP])

# --- arrow f: columns 253..757, single run each
ar = np.vstack([chain(comps[4], 0, 253, 757, 8, 0, need=1), [(776, 141), (790, 148)]]
               )

# --- coverage report
def cover(polys, mask, dil=7):
    m = np.zeros(a.shape, bool)
    for p in polys:
        q = np.vstack([p, p[:1]])
        for u, v in zip(q[:-1], q[1:]):
            L = int(np.hypot(*(v - u))) + 1
            for t in range(L + 1):
                x, y = u + (v - u) * t / L
                m[max(0, int(y) - 3):int(y) + 4, max(0, int(x) - 3):int(x) + 4] = True
    m = ndimage.binary_dilation(m, np.ones((dil, dil)))
    bad = mask & ~m
    return int(mask.sum()), int(bad.sum())


tot = 0
for tag, mk, pl in (('X', comps[1], [Xc]), ('Z', comps[2], [Zc, Pc]), ('f', comps[4], [ar])):
    t, b = cover(pl, mk)
    tot += t
    print('%s ink %d uncovered %d (%.1f%%)' % (tag, t, b, 100. * b / t))

# where are the uncovered pixels?
m = np.zeros(a.shape, bool)
for p in [Xc, Zc, Pc, ar]:
    q = np.vstack([p, p[:1]]) if len(p.shape) == 2 and p.shape[0] > 2 else p
    for u, v in zip(q[:-1], q[1:]):
        L = int(np.hypot(*(v - u))) + 1
        for t in range(L + 1):
            x, y = u + (v - u) * t / L
            m[max(0, int(y) - 3):int(y) + 4, max(0, int(x) - 3):int(x) + 4] = True
m = ndimage.binary_dilation(m, np.ones((7, 7)))
for i in range(1, n + 1):
    t = int(comps[i].sum())
    b = int((comps[i] & ~m).sum())
    ys, xs = np.nonzero(comps[i])
    print(' comp %d ink %d uncov %d  bbox %d-%d %d-%d' % (i, t, b, xs.min(), xs.max(), ys.min(), ys.max()))

np.save('poly72.npy', np.array([np.hstack([Xc, np.zeros((len(Xc), 1))]),
                                np.hstack([Zc, np.ones((len(Zc), 1))]),
                                np.hstack([Pc, np.full((len(Pc), 1), 2)]),
                                np.hstack([ar, np.full((len(ar), 1), 3)])], dtype=object),
        allow_pickle=True)

S = 148.0
Y0 = 326.0


def fmt(poly, cyc):
    s = ', '.join('px(%.0f,%.0f)' % (p[0], p[1]) for p in poly)
    return '  line(path: true%s, %s, stroke: t)' % (', cycle: true' if cyc else '', s)


body = ['#set page(width: auto, height: auto, margin: 2pt)',
        '#set text(size: 6.2pt)',
        '#import "@preview/cetz:0.4.2": canvas, draw',
        '',
        '#canvas({',
        '  import draw: *',
        '  let S = %.1f' % S,
        '  let px = (x, y) => (x / S, (%.1f - y) / S)' % Y0,
        '  let t = (thickness: 1.0pt)',
        '  let hd = (symbol: ">", fill: black, length: 6.9pt, width: 2.7pt)',
        '',
        '  content(px(527, 58), anchor: "center", [#text(size: 7.0pt)[$f$]])',
        '  content(px(252, 137), anchor: "west", [#text(size: 5.9pt)[$U_i$]])',
        '  content(px(892, 160), anchor: "west", [#text(size: 5.9pt)[$V_i$]])',
        '  content(px(107, 260), anchor: "center", [$X$])',
        '  content(px(1069, 228), anchor: "center", [$Z$])',
        fmt(Xc, True),
        fmt(Zc, True),
        fmt(Pc, True),
        '  line(%s, stroke: t, mark: (end: hd))' % ', '.join('px(%.0f,%.0f)' % (p[0], p[1]) for p in ar),
        '  circle(px(206, 141.5), radius: 8.5 / S, fill: black, stroke: none)',
        '  circle(px(838, 165), radius: 9.0 / S, fill: black, stroke: none)',
        '  circle(px(206.5, 139.5), radius: 37.0 / S, stroke: t)',
        '})',
        '']
open('typ/%s-nbhd.typ' % NAME, 'w').write('\n'.join(body))
print('written typ/%s-nbhd.typ' % NAME)
