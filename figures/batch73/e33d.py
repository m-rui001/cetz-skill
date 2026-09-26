import numpy as np
from scipy import ndimage
import tr, e33b

tr.load('src/it33-raw.png')
M = tr.M
lab, n = ndimage.label(M, structure=np.ones((3, 3)))


def comp(ids):
    return np.isin(lab, list(ids))


def hull(P):
    P = np.unique(P.round(1), axis=0)
    P = P[np.lexsort((P[:, 1], P[:, 0]))]

    def half(P):
        out = []
        for p in P:
            while len(out) >= 2 and np.cross(out[-1] - out[-2], p - out[-2]) <= 0:
                out.pop()
            out.append(p)
        return out
    return np.array(half(P)[:-1] + half(P[::-1])[:-1])


# ---- 1. filled wedge of the sum arrow
G = np.load('sec_sum.npy')
c, u, t0, t1, keep, P, t, d = e33b.fit(G)
if (c + u * t1)[0] < (c + u * t0)[0]:      # orient so t1 end is the tip (rightmost)
    u = -u
    t = -t
    t0, t1 = t1, t0
tip = c + u * t1
print('sum tip', np.round(tip, 1), 'other end', np.round(c + u * t0, 1))
H = P[P[:, 0] > 378]
hp = hull(H)
print('head hull', len(hp), np.round(hp, 1).tolist())

# ---- 2. dashes
h_d = list(range(12, 22))
s_d = [22, 23, 24, 27, 28, 29, 32, 33]


def dash_ends(ids):
    for i in ids:
        G = comp([i])
        ys, xs = np.nonzero(G)
        a = (xs.min(), ys[xs == xs.min()].mean())
        b = (xs.max(), ys[xs == xs.max()].mean())
        print(f'  c{i} ({a[0]},{a[1]:.1f})-({b[0]},{b[1]:.1f}) px{int(G.sum())}')


print('horizontal dashes:'); dash_ends(h_d)
print('slanted dashes:'); dash_ends(s_d)

# ---- 3. free arrows
for name, ids in (('c9 x', [9]), ('c10 -x', [10]), ('c69 2.5x', [69]),
                  ('c71 2x', [71]), ('c74 x', [74])):
    G = comp(ids)
    c, u, t0, t1, keep, P, t, d = e33b.fit(G)
    band = ndimage.binary_dilation(e33b.raster(P[keep], G.shape), np.ones((9, 9)))
    R = G & ~band
    print(f'== {name}: A=({c[0]+u[0]*t0:.1f},{c[1]+u[1]*t0:.1f}) B=({c[0]+u[0]*t1:.1f},{c[1]+u[1]*t1:.1f}) '
          f'ang={np.rad2deg(np.arctan2(-u[1],u[0])):.2f} inl={keep.sum()}/{len(P)}')
    for b in sorted(e33b.blobs_of(R), key=lambda z: -z[0])[:8]:
        print('    ', b)

# ---- 4. zero dot
G = comp([76])
ys, xs = np.nonzero(G)
print('dot c76 center', round(xs.mean(), 1), round(ys.mean(), 1), 'w', xs.max()-xs.min()+1,
      'h', ys.max()-ys.min()+1, 'px', int(G.sum()))

# ---- 5. text rows
skip = set([11, 9, 10, 69, 71, 74, 76] + h_d + s_d)
rows = {}
for i in range(1, n + 1):
    if i in skip:
        continue
    G = comp([i])
    ys, xs = np.nonzero(G)
    rows.setdefault(round(ys.mean() / 14), []).append((xs.min(), xs.max(), ys.min(), ys.max(), i))
for k in sorted(rows):
    v = rows[k]
    print(f'textrow y({min(c for _,_,c,_,_ in v)}-{max(dd for _,_,_,dd,_ in v)}) '
          f'x({min(a for a,_,_,_,_ in v)}-{max(b for _,b,_,_,_ in v)}) n{len(v)} '
          f'ids{[i for *_, i in v]}')
