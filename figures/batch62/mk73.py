import numpy as np, sys, json
from PIL import Image
from scipy import ndimage

full = np.array(Image.open('src/dt73-raw.png').convert('L')) < 160
labl, _n = ndimage.label(full, structure=np.ones((3, 3)))
a = labl == 1
ys, xs = np.nonzero(a)
pts = np.stack([xs, ys], 1).astype(float)

def walk(p0, d0, n=400, step=9., rad=13., perp=4.5, stops=(), sr=26.):
    p = np.array(p0, float); d = np.array(d0, float); d /= np.hypot(*d)
    out = [p.copy()]
    for _ in range(n):
        tgt = out[-1] + d * step
        sel = ((pts - tgt) ** 2).sum(1) < rad * rad
        if not sel.any(): break
        q = pts[sel]; v = q - out[-1]
        ok = (v @ d > step * 0.5) & (np.abs(v @ np.array([-d[1], d[0]])) < perp)
        if not ok.any(): break
        cand = q[ok]; nd = cand.mean(0) - out[-1]; L = np.hypot(*nd)
        if L < 2: break
        nd /= L
        if nd @ d < 0: break
        d = 0.55 * d + 0.45 * nd; d /= np.hypot(*d)
        nxt = cand.mean(0)
        for s in stops:
            if np.hypot(*(nxt - np.array(s, float))) < sr:
                nxt = nxt + (np.array(s, float) - nxt) * (sr / max(1e-9, float(np.hypot(*(np.array(s, float) - nxt)))))
                out.append(nxt); return out
        out.append(nxt)
    return out

def thin(segs):
    m = np.zeros_like(a)
    for s in segs:
        p = np.array(s, float)
        for i in range(len(p) - 1):
            u, v = p[i], p[i + 1]
            L = int(np.hypot(*(v - u))) + 1
            for t in range(L + 1):
                x, y = u + (v - u) * t / L
                xi, yi = int(round(x)), int(round(y))
                m[max(0, yi - 3):yi + 4, max(0, xi - 3):xi + 4] = True
    return m

def report(segs):
    m = thin(segs)
    bad = a & ~ndimage.binary_dilation(m, np.ones((7, 7)))
    lb, n = ndimage.label(bad, np.ones((3, 3)))
    comps = []
    for i in range(1, n + 1):
        yy, xx = np.nonzero(lb == i)
        if len(xx) < 15: continue
        comps.append((len(xx), int(xx.min()), int(xx.max()), int(yy.min()), int(yy.max())))
    comps.sort(reverse=True)
    print('main-ink %d  uncovered %d (%.1f%%)' % (a.sum(), bad.sum(), 100 * bad.sum() / a.sum()))
    for c in comps[:14]:
        print('   gap px %d  x %d..%d  y %d..%d' % c)

if __name__ == '__main__':
    jobs = json.load(open(sys.argv[1]))
    segs = []
    for j in jobs:
        s = walk(j['p'], j['d'], j.get('n', 400), j.get('step', 9.), j.get('rad', 13.),
                 j.get('perp', 4.5), [tuple(t) for t in j.get('stops', [])], j.get('sr', 26.))
        p = np.array(s, float)
        print('seed', j['p'], j['d'], '->', len(s), 'verts end', tuple(round(float(c)) for c in p[-1]),
              'len %.0f' % float(np.hypot(*(p[1:] - p[:-1]).T).sum()))
        segs.append([[round(float(v[0]), 1), round(float(v[1]), 1)] for v in s])
    json.dump(segs, open('segs73.json', 'w'))
    report(segs)
