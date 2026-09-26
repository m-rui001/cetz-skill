import numpy as np, json
from PIL import Image
from scipy import ndimage

a = np.array(Image.open('src/dt15-raw.png').convert('L')) < 160
S = json.load(open('segs15.json'))


def near(p, poly):
    return np.hypot(p[:, None, 0] - poly[None, :, 0], p[:, None, 1] - poly[None, :, 1]).min(1)


# Z circle ink = box minus the three torus curves (solid arc + hidden dashes)
box = np.zeros_like(a)
box[10:132, 252:332] = True
pts = np.stack([*np.nonzero(a & box)[::-1]], 1).astype(float)
d = np.minimum.reduce([near(pts, np.array(S[k])) for k in ('outer', 'inner', 'hole')])
keep = pts[d > 7]

km = np.zeros_like(a)
for p in keep:
    km[int(p[1]), int(p[0])] = True
dist = ndimage.distance_transform_edt(~km)


def score(poly, dense=1.0):
    p = np.array(poly, float)
    q = []
    for i in range(len(p)):
        u, v = p[i], p[(i + 1) % len(p)]
        L = int(np.hypot(*(v - u)) / dense) + 1
        for t in range(L + 1):
            x, y = u + (v - u) * t / L
            q.append(dist[int(round(y)), int(round(x))])
    return float(np.mean(q))


def binned(cen, step=5.0, spread=14.0):
    c = np.array(cen, float)
    th = np.arctan2(keep[:, 1] - c[1], keep[:, 0] - c[0])
    rr = np.hypot(keep[:, 0] - c[0], keep[:, 1] - c[1])
    k = int(360 / step)
    rad = np.full(k, np.nan)
    ang = 2 * np.pi * (np.arange(k) + .5) / k - np.pi
    for i in range(k):
        lo = 2 * np.pi * i / k - np.pi
        m = np.abs(((th - lo) % (2 * np.pi)) - np.pi) <= np.pi / k
        if m.any():
            med = np.median(rr[m])
            m2 = m & (np.abs(rr - med) < spread)
            rad[i] = med if not m2.any() else rr[m2].mean()
    # interpolate missing bins over the cyclic index
    idx = np.arange(k)
    good = ~np.isnan(rad)
    r = np.interp(idx, idx[good], rad[good], period=k)
    return np.stack([c[0] + r * np.cos(ang), c[1] + r * np.sin(ang)], 1)


def snap(poly, r=6.0, it=3):
    out = []
    for p in poly:
        q = np.array(p, float)
        for _ in range(it):
            m = np.hypot(keep[:, 0] - q[0], keep[:, 1] - q[1]) < r
            if not m.any():
                break
            nq = keep[m].mean(0)
            if np.hypot(*(nq - q)) < .4:
                q = nq
                break
            q = nq
        out.append(q)
    return np.array(out)


cands = {}
for cx in np.arange(272, 289, 2.0):
    for cy in np.arange(62, 80, 2.0):
        for tag, f in (('r', lambda c: binned(c)), ('s', lambda c: snap(binned(c)))):
            cands['%s%.0f_%.0f' % (tag, cx, cy)] = f((cx, cy))

res = sorted(((score(v), k) for k, v in cands.items()))
for r, k in res[:10]:
    print('%-10s mean-dist-to-Z-ink %.2f' % (k, r))
best = cands[res[0][1]]
S['zz'] = [[round(float(p[0]), 1), round(float(p[1]), 1)] for p in best]
json.dump(S, open('segs15.json', 'w'))
print('chosen', res[0][1], 'n', len(best))

img = Image.fromarray((~(a & box)).astype(np.uint8) * 255).convert('RGB')
for p in keep:
    img.putpixel((int(p[0]), int(p[1])), (0, 200, 0))
b = np.vstack([best, best[:1]])
for u, v in zip(b[:-1], b[1:]):
    n = int(np.hypot(*(v - u))) + 1
    for t in range(n + 1):
        x, y = u + (v - u) * t / n
        img.putpixel((int(round(x)), int(round(y))), (255, 0, 0))
img.crop((235, 0, 340, 140)).resize((420, 560), Image.NEAREST).save('src/_z15d.png')
