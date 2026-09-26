import numpy as np
from PIL import Image
from scipy import ndimage

s = np.array(Image.open('src/dt66-wrap-raw.png').convert('L')).astype(int) < 160
r = np.array(Image.open('png/dt66-wrap.png').convert('L')).astype(int) < 160
ys, xs = np.nonzero(s)
bsw = xs.max() - xs.min() + 1
rys, rxs = np.nonzero(r)
BR = [rxs.min(), rxs.max(), rys.min(), rys.max()]
sc = bsw / (BR[1] - BR[0] + 1)
rc = r[BR[2]:BR[3] + 1, BR[0]:BR[1] + 1]
big = np.array(Image.fromarray((rc * 255).astype('uint8')).resize(
    (int((BR[1] - BR[0] + 1) * sc), int((BR[3] - BR[2] + 1) * sc)), Image.LANCZOS)) > 128
gy, gx = np.nonzero(big)
OX, OY = 23, 10
mx = gx + OX
my = gy + OY
edt = ndimage.distance_transform_edt(~s)
d = edt[np.clip(my, 0, s.shape[0]-1), np.clip(mx, 0, s.shape[1]-1)]
print('overall mean %.3f n=%d' % (d.mean(), len(d)))
def box(a, b, c, e):
    return lambda x, y: (x >= a) & (x <= b) & (y >= c) & (y <= e)


reg = {
    'R1 line': box(10, 300, 90, 120),
    'R1 label': box(135, 185, 112, 155),
    'wrap arc': box(405, 610, 65, 120),
    'wrap arrow': box(600, 645, 85, 125),
    'Wrap txt': box(470, 580, 25, 75),
    'around txt': box(470, 585, 95, 128),
    'eight': box(780, 918, 0, 216),
}
for k, f in reg.items():
    mm = f(mx, my)
    if mm.sum():
        print('%-12s mean %5.2f  n=%5d  max %5.1f' % (k, d[mm].mean(), mm.sum(), d[mm].max()))
