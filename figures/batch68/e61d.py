import numpy as np
from PIL import Image
from scipy import ndimage

g = np.array(Image.open('src/dt61-raw.png').convert('L')) < 160
lab, n = ndimage.label(g, structure=np.ones((3, 3)))
c1 = lab == 1
H, W = g.shape
CX, CY = 112.5, 85.5

bnd = []
for deg in range(0, 360, 1):
    th = np.deg2rad(deg)
    dx, dy = np.cos(th), np.sin(th)
    run = None
    for k in np.arange(6.0, 200.0, 0.5):
        x, y = CX + dx * k, CY + dy * k
        if x < 0 or y < 0 or x >= W or y >= H:
            break
        if g[int(round(y)), int(round(x))]:
            k0 = k
            while k < 200:
                x2, y2 = CX + dx * k, CY + dy * k
                if not (0 <= x2 < W and 0 <= y2 < H and g[int(round(y2)), int(round(x2))]):
                    break
                k += 0.5
            bnd.append(((x0 + x2) / 2 if False else (CX + dx * (k0 + k) / 2, CY + dy * (k0 + k) / 2)))
            break
    else:
        bnd.append(None)
bnd = [p for p in bnd if p]
print('bnd pts', len(bnd))
xs = np.array([p[0] for p in bnd]); ys = np.array([p[1] for p in bnd])
print('box x', xs.min(), xs.max(), 'y', ys.min(), ys.max())

# rasterise the boundary and dilate to find leftover ink of comp1
mask = np.zeros((H, W), bool)
for a in range(len(bnd)):
    x0, y0 = bnd[a]; x1, y1 = bnd[(a + 1) % len(bnd)]
    for t in np.arange(0, 1, 0.05):
        mask[int(round(y0 + (y1 - y0) * t)), int(round(x0 + (x1 - x0) * t))] = True
cov = ndimage.binary_dilation(mask, np.ones((9, 9)))
res = c1 & ~cov
rl, rn = ndimage.label(res, structure=np.ones((3, 3)))
tot = res.sum()
print('residual px', tot, '/', c1.sum())
for i in range(1, rn + 1):
    yy, xx = np.nonzero(rl == i)
    if len(yy) < 15:
        continue
    print(' comp', i, len(yy), 'x', xx.min(), xx.max(), 'y', yy.min(), yy.max())
np.save('bnd61.npy', np.array(bnd))
