import numpy as np, json
from PIL import Image
from scipy import ndimage

a = np.array(Image.open('src/dt15-raw.png').convert('L')) < 160
a[:, 480:] = False
lab, n = ndimage.label(a, structure=np.ones((3, 3)))
a = lab == 1
ys, xs = np.nonzero(a)
pts = np.stack([xs, ys], 1).astype(float)

MODELS = {'outer': ((243.25, 177.6), (224.75, 157.4), 22.0),
          'inner': ((241.5, 165.75), (161.9, 104.75), 22.0),
          'hole': ((242.9, 158.0), (47.0, 30.0), 13.0)}


def ray_hits(C, rmin=0., rmax=300., w=3.0):
    C = np.array(C, float)
    q = pts - C
    r = np.hypot(q[:, 0], q[:, 1])
    th = np.arctan2(q[:, 1], q[:, 0])
    sel = (r > rmin) & (r < rmax)
    return th[sel], r[sel], q[sel]


def extract(C0, ab0, step=4.0, tol=22.0):
    C = np.array(C0, float); a0, b0 = ab0
    ang = np.arange(0, 360, step)
    out = []
    for d in ang:
        t = np.deg2rad(d)
        u = np.array([np.cos(t), np.sin(t)]); v = np.array([-u[1], u[0]])
        q = pts - C
        r = q @ u; p = np.abs(q @ v)
        m = (p < 3.0) & (r > 8)
        if not m.any():
            out.append(None); continue
        rr = r[m]; cc = (q[m] + C)
        o = np.argsort(rr)
        rr, cc = rr[o], cc[o]
        groups = [[0]]
        for i in range(1, len(rr)):
            if rr[i] - rr[i - 1] > 4: groups.append([])
            groups[-1].append(i)
        hp = [(float(rr[g].mean()), cc[g].mean(0)) for g in groups]
        pred = 1.0 / np.sqrt((np.cos(t) / a0) ** 2 + (np.sin(t) / b0) ** 2)
        cand = [h for h in hp if abs(h[0] - pred) < tol]
        if not cand:
            out.append(None); continue
        out.append(min(cand, key=lambda h: abs(h[0] - pred))[1])
    # close gaps: interpolate None runs
    idx = [i for i, o in enumerate(out) if o is not None]
    full = []
    for i, o in enumerate(out):
        if o is not None:
            full.append(o)
        else:
            lo = max(j for j in idx if j < i) if any(j < i for j in idx) else idx[-1]
            hi = min(j for j in idx if j > i) if any(j > i for j in idx) else idx[0]
            full.append((out[lo] + out[hi]) / 2)
    return np.array(full)


polys = {}
for k in ('outer', 'inner', 'hole'):
    C0, ab0, tl = MODELS[k]
    P = extract(C0, ab0, tol=tl)
    polys[k] = P
    print(k, 'n', len(P))

# ---- Z circle: ink in box, minus points near inner ellipse
box = (pts[:, 0] > 243) & (pts[:, 0] < 318) & (pts[:, 1] > 12) & (pts[:, 1] < 128)
cand = pts[box]
keep = []
for p in cand:
    if np.hypot(*(p - polys['inner']).T).min() < 9: continue
    if np.hypot(*(p - polys['hole']).T).min() < 9: continue
    keep.append(p)
keep = np.array(keep)
print('Z pts', len(keep), 'x', keep[:, 0].min(), keep[:, 0].max(), 'y', keep[:, 1].min(), keep[:, 1].max())
_zmod = pts; pts = keep
polys['zz'] = extract((280.5, 70.0), (36.5, 51.0), step=5.0, tol=18.0)
pts = _zmod
print('Z n', len(polys['zz']))

ARROW = {}
for nm, bx in (('al', (165, 184, 140, 172)), ('ar', (302, 320, 143, 168))):
    sel = (pts[:, 0] >= bx[0]) & (pts[:, 0] <= bx[1]) & (pts[:, 1] >= bx[2]) & (pts[:, 1] <= bx[3])
    P = pts[sel]
    d2 = ((P[:, None, :] - P[None, :, :]) ** 2).sum(-1)
    i, j = np.unravel_index(np.argmax(d2), d2.shape)
    u0, u1 = P[i], P[j]
    e = np.hypot(*(u1 - u0))
    perp = np.abs((P - u0) @ np.array([-((u1 - u0)[1]) / e, (u1 - u0)[0] / e]))
    k = int(np.argmax(perp))
    ARROW[nm] = [u0.tolist(), P[k].tolist(), u1.tolist()]
    print(nm, 'n', len(P), 'ends', np.round(u0, 1), np.round(u1, 1), 'vertex', np.round(P[k], 1))
polys.update({k2: np.array(v) for k2, v in ARROW.items()})

# Z outline: angular binning of the residual Z ink around its centroid
cen = keep.mean(0)
th = np.arctan2(keep[:, 1] - cen[1], keep[:, 0] - cen[0])
rr = np.hypot(keep[:, 0] - cen[0], keep[:, 1] - cen[1])
zb = []
for k2 in range(72):
    lo, hi = 2 * np.pi * k2 / 72 - np.pi, 2 * np.pi * k2 / 72 + np.pi
    t2 = ((th - lo) % (2 * np.pi)) - np.pi
    m = np.abs(t2) <= np.pi / 72
    if not m.any(): continue
    zb.append(cen + np.array([np.cos(th[m]).mean(), np.sin(th[m]).mean()]) * rr[m].mean())
polys['zz'] = np.array(zb)
print('Z n', len(zb), 'cen', np.round(cen, 1))

json.dump({k: [[round(float(p[0]), 1), round(float(p[1]), 1)] for p in v] for k, v in polys.items()},
          open('segs15.json', 'w'))

# residual
m = np.zeros(a.shape, bool)
for k, P in polys.items():
    for i in range(len(P)):
        u2, v2 = P[i], P[(i + 1) % len(P)]
        L = int(np.hypot(*(v2 - u2))) + 1
        for t2 in range(L + 1):
            x, y = u2 + (v2 - u2) * t2 / L
            m[max(0, int(y) - 3):int(y) + 4, max(0, int(x) - 3):int(x) + 4] = True
bad = a & ~ndimage.binary_dilation(m, np.ones((9, 9)))
lb, nn = ndimage.label(bad, np.ones((3, 3)))
print('ink %d uncovered %d (%.1f%%)' % (a.sum(), bad.sum(), 100 * bad.sum() / a.sum()))
for i in range(1, nn + 1):
    yy, xx = np.nonzero(lb == i)
    if len(xx) < 20: continue
    print('  gap px %d x %d..%d y %d..%d' % (len(xx), xx.min(), xx.max(), yy.min(), yy.max()))
