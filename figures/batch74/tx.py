import numpy as np
from PIL import Image
from scipy import ndimage

G = np.asarray(Image.open(sys.argv[1]).convert('L'))
M = G < 160
lab, n = ndimage.label(M, np.ones((3, 3)))
items = []
for i in range(1, n + 1):
    P = np.argwhere(lab == i)
    if len(P) < 200:
        y0, x0 = P.min(0); y1, x1 = P.max(0)
        items.append([i, len(P), x0, y0, x1, y1])
items.sort(key=lambda r: (r[3] // 14, r[2]))
clusters = []
for it in items:
    hit = None
    for c in clusters:
        if not (it[4] < c[2] - 7 or it[2] > c[4] + 7) and not (it[5] < c[3] - 9 or it[3] > c[5] + 9):
            hit = c
    if hit:
        hit[2] = min(hit[2], it[2]); hit[3] = min(hit[3], it[3])
        hit[4] = max(hit[4], it[4]); hit[5] = max(hit[5], it[5])
        hit[1] += it[1]; hit.append(it[0])
    else:
        clusters.append(list(it[:6]) + [it[0]])
clusters.sort(key=lambda c: (c[2] // 350, c[3], c[2]))
for c in clusters:
    print('T x=%3d..%3d y=%3d..%3d w=%2d h=%2d px=%3d ids=%s' %
          (c[2], c[4], c[3], c[5], c[4] - c[2] + 1, c[5] - c[3] + 1, c[1], c[6:]))
