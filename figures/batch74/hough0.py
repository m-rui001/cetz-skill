import sys, numpy as np
from PIL import Image
from scipy import ndimage

G = np.asarray(Image.open(sys.argv[1]).convert('L'))
M = G < 160
P = np.argwhere(M).astype(float)
X, Y = P[:, 1], P[:, 0]
minlen = int(sys.argv[2]) if len(sys.argv) > 2 else 60
print('size', G.shape[::-1], 'ink', len(P), 'minlen', minlen)

th = np.radians(np.arange(0, 180, 0.5))
cu, su = np.cos(th), np.sin(th)
R = X[:, None] * cu[None, :] + Y[:, None] * su[None, :]
rb = np.round(R).astype(int)
rb -= rb.min()
H = np.zeros((rb.max() + 1, th.size), dtype=np.int32)
np.add.at(H, (rb.ravel(), np.repeat(np.arange(th.size), rb.shape[0])), 1)
base = rb.min()
# lines are 2-3 px wide and drift a bin or two, so peak-find on a rho-smoothed map
Hs = ndimage.uniform_filter1d(H.astype(float), 5, axis=0, mode='constant') * 5.0

peaks, taken = [], np.zeros_like(H, dtype=bool)
for idx in np.argsort(-Hs, axis=None)[:60000]:
    i, j = np.unravel_index(idx, Hs.shape)
    if Hs[i, j] < minlen: break
    if taken[max(0, i - 2):i + 3, max(0, j - 3):j + 4].any(): continue
    taken[max(0, i - 2):i + 3, max(0, j - 3):j + 4] = True
    peaks.append((i + base, j))

cover = np.zeros_like(M)
segs = []
for rho, j in peaks:
    nx, ny = cu[j], su[j]          # line normal
    ux, uy = -su[j], cu[j]         # line direction
    d = X * nx + Y * ny - rho
    sel = np.abs(d) <= 2.0
    if sel.sum() < minlen: continue
    ts = X[sel] * ux + Y[sel] * uy
    ti = np.sort(np.round(ts).astype(int))
    best = (0, 0); st = ti[0]; pr = ti[0]
    for v in list(ti[1:]) + [None]:
        if v is None or v > pr + 4:
            if pr - st > best[1] - best[0]: best = (st, pr)
            if v is not None: st = v
        if v is not None: pr = v
    t0, t1 = best
    n = int(((ts >= t0) & (ts <= t1)).sum())
    if n < minlen or t1 - t0 < 25: continue
    a0 = (rho * nx + t0 * ux, rho * ny + t0 * uy)
    a1 = (rho * nx + t1 * ux, rho * ny + t1 * uy)
    L = float(np.hypot(a1[0] - a0[0], a1[1] - a0[1]))
    segs.append((L, a0, a1, n, float(np.degrees(np.arctan2(uy, ux))) % 180))
    for m in np.arange(-3, 3.1):
        for i in range(int(L) + 1):
            fx = int(round(a0[0] + (a1[0] - a0[0]) * i / max(L, 1) + m * nx))
            fy = int(round(a0[1] + (a1[1] - a0[1]) * i / max(L, 1) + m * ny))
            if 0 <= fx < G.shape[1] and 0 <= fy < G.shape[0]: cover[fy, fx] = True

segs.sort(key=lambda s: -s[0])
for L, a0, a1, n, ang in segs:
    print('SEG len %5.1f  (%6.1f,%6.1f)-(%6.1f,%6.1f)  ink %4d  ang %5.1f'
          % (L, a0[0], a0[1], a1[0], a1[1], n, ang))
Rm = M & ~ndimage.binary_dilation(cover, np.ones((3, 3)))
print('residual ink', int(Rm.sum()))
lab, k = ndimage.label(Rm, np.ones((3, 3)))
sz = ndimage.sum(Rm, lab, range(1, k + 1))
for i in np.argsort(-sz)[:14]:
    i = int(i) + 1
    Pp = np.argwhere(lab == i); y0, x0 = Pp.min(0); y1, x1 = Pp.max(0)
    print('  RES px %5d  x %3d..%3d  y %3d..%3d' % (int(sz[i - 1]), x0, x1, y0, y1))
