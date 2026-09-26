import numpy as np
from PIL import Image
from scipy import ndimage

g = np.array(Image.open('src/dt61-raw.png').convert('L')) < 160
lab, n = ndimage.label(g, structure=np.ones((3, 3)))
c1 = lab == 1
H, W = g.shape
CX, CY = 112.5, 85.5
bnd = np.load('bnd61.npy')
th = np.deg2rad(np.arange(360))
rad = np.hypot(bnd[:, 0] - CX, bnd[:, 1] - CY)
ang = np.arctan2(bnd[:, 1] - CY, bnd[:, 0] - CX)
print('deg where radius < median-6:')
med = ndimage.median_filter(np.r_[rad, rad, rad], 31)[360:720]
bad = np.nonzero(rad < med - 6)[0]
print(bad)
# rebuild smoothed boundary
rad2 = np.where(rad < med - 6, med, rad)
bnd2 = np.c_[CX + rad2 * np.cos(th), CY + rad2 * np.sin(th)]
mask = np.zeros((H, W), bool)
for a in range(360):
    x0, y0 = bnd2[a]; x1, y1 = bnd2[(a + 1) % 360]
    for t in np.arange(0, 1, 0.02):
        mask[int(round(y0 + (y1 - y0) * t)), int(round(x0 + (x1 - x0) * t))] = True
cov = ndimage.binary_dilation(mask, np.ones((7, 7)))
mark = c1 & ~cov
print('mark px', mark.sum(), 'of', c1.sum())
ys, xs = np.nonzero(mark)
print('mark box x', xs.min(), xs.max(), 'y', ys.min(), ys.max())
# skeleton-ish: print ascii
for y in range(ys.min(), ys.max() + 1):
    print('%3d ' % y + ''.join('#' if mark[y, x] else '.' for x in range(xs.min(), xs.max() + 1)))
np.save('bnd61b.npy', bnd2)
