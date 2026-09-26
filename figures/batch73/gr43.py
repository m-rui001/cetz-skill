import numpy as np
from PIL import Image

A = np.asarray(Image.open('src/it43-raw.png').convert('L'))
g = (A > 160) & (A < 246)
print('grey px', g.sum())
for x0, x1, tag in [(0, 350, 'L'), (350, 700, 'R')]:
    sub = g[:, x0:x1]
    cols = np.flatnonzero(sub.any(0))
    print(tag, 'cols', cols.min() + x0, cols.max() + x0)
    for x in range(cols.min() + x0, cols.max() + x0 + 1, 10):
        r = np.flatnonzero(g[:, x])
        print('   x=%3d y %3d..%3d' % (x, r.min(), r.max()) if len(r) else '   x=%3d none' % x)
    rows = np.flatnonzero(sub.any(1))
    print(tag, 'rows', rows.min(), rows.max())

Image.fromarray(A[40:210, 190:345]).resize((155 * 4, 170 * 4), Image.NEAREST).save('zL.png')
Image.fromarray(A[100:345, 520:700]).resize((180 * 3, 245 * 3), Image.NEAREST).save('zR.png')
