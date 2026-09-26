import sys, numpy as np
from PIL import Image
from scipy import ndimage

G = np.asarray(Image.open(sys.argv[1]).convert('L'))
M = G < 160
lab, n = ndimage.label(M, np.ones((3, 3)))
print('shape', M.shape, 'ink', M.sum(), 'comps', n)
geo, txt = [], []
for i in range(1, n + 1):
    P = np.argwhere(lab == i)
    y0, x0 = P.min(0); y1, x1 = P.max(0)
    rec = (i, len(P), (x0, y0), (x1, y1))
    (geo if len(P) >= 200 else txt).append(rec)
for r in sorted(geo, key=lambda r: -r[1]):
    print('GEO', r)
print('--- small comps (text/dash), grouped by row bands')
txt.sort(key=lambda r: r[2][1])
for r in txt:
    print('S ', r[0], 'px', r[1], 'xy', r[2], r[3], 'w', r[3][0]-r[2][0]+1, 'h', r[3][1]-r[2][1]+1)
