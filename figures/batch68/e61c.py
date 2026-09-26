import numpy as np
from PIL import Image
from scipy import ndimage

g = np.array(Image.open('src/dt61-raw.png').convert('L')) < 160
lab, n = ndimage.label(g, structure=np.ones((3, 3)))
c1 = lab == 1
ys, xs = np.nonzero(c1)

# algebraic circle fit on the part away from the left mark
sel = xs > 50
X, Y = xs[sel].astype(float), ys[sel].astype(float)
A = np.c_[2 * X, 2 * Y, np.ones(len(X))]
b = X**2 + Y**2
sol, *_ = np.linalg.lstsq(A, b, rcond=None)
cx, cy, cc = sol
r = np.sqrt(cc + cx**2 + cy**2)
print('centre %.2f %.2f  r %.2f' % (cx, cy, r))
d = np.abs(np.hypot(xs - cx, ys - cy) - r)
print('on-circle frac', (d < 4).mean(), 'off', (d >= 4).sum())

# residual mask = comp1 ink farther than 4 px from the fitted circle
res = c1 & (np.abs(np.hypot(np.arange(g.shape[0])[:, None] - cy,
                            np.arange(g.shape[1])[None, :] - cx) - r) >= 4)
rl, rn = ndimage.label(res, structure=np.ones((3, 3)))
print('residual comps')
for i in range(1, rn + 1):
    yy, xx = np.nonzero(rl == i)
    if len(yy) < 15:
        continue
    print(' ', i, len(yy), 'x', xx.min(), xx.max(), 'y', yy.min(), yy.max())
# circle extremes for sanity
sel2 = d < 4
print('circle ink box x', xs[sel2].min(), xs[sel2].max(), 'y', ys[sel2].min(), ys[sel2].max())

# wavy line centreline
c2 = lab == 2


def runs(a, off=0):
    out, i = [], 0
    while i < len(a):
        if a[i]:
            j = i
            while j < len(a) and a[j]:
                j += 1
            out.append((i + off, j - 1 + off))
            i = j
        else:
            i += 1
    return out


pts = []
for x in range(438, 780):
    rr = runs(c2[:, x])
    if len(rr) == 1 and rr[0][1] - rr[0][0] <= 8:
        pts.append((x, (rr[0][0] + rr[0][1]) / 2))
print('line pts', len(pts))
for k in range(0, len(pts), 20):
    print(pts[k])
print(pts[-1])
