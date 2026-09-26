import numpy as np
from PIL import Image
from scipy import ndimage

g = np.array(Image.open('src/dt61-raw.png').convert('L')) < 160
lab, n = ndimage.label(g, structure=np.ones((3, 3)))
c1 = lab == 1
ys, xs = np.nonzero(c1)
for (cx, cy, R) in [(22, 87, 15), (22, 87, 11)]:
    d = np.hypot(xs - cx, ys - cy)
    sel = d < R
    a = (np.rad2deg(np.arctan2(ys[sel] - cy, xs[sel] - cx))) % 180
    h, edges = np.histogram(a, bins=18, range=(0, 180))
    print('R', R, 'n', sel.sum())
    for k in range(18):
        print('  %3d-%3d %s %d' % (edges[k], edges[k+1], '#' * (h[k]//4), h[k]))
