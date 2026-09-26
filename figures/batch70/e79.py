import tr, numpy as np
from PIL import Image, ImageDraw
from scipy import ndimage
m = tr.load('src/dt79-raw.png').copy()
lab = tr.comps(12)[1][6]
work = (lab == 2)
out = []
for it in range(8):
    ys, xs = np.nonzero(work)
    if len(ys) < 60:
        print('leftover', len(ys)); break
    lx = int(xs.min())
    st = (float(lx), float(ys[xs <= lx + 1].mean()))
    tr.mask_of(work)
    pts, tag = tr.trace(st, -90.0)
    n = len(pts)
    P = np.array(pts)
    print(it, tag, n, 'start', st, 'end', tuple(round(v, 1) for v in P[-1]),
          'bbox x', round(P[:,0].min(),1), round(P[:,0].max(),1), 'y', round(P[:,1].min(),1), round(P[:,1].max(),1))
    if n < 8:
        # isolated remnant: drop its connected piece
        l2, n2 = ndimage.label(work, np.ones((3, 3)))
        cid = l2[int(st[1]), int(st[0])]
        work = work & (l2 != cid)
        continue
    out.append(pts)
    for a, b in zip(P[:-1], P[1:]):
        for t in np.linspace(0, 1, 8):
            p = a + (b - a) * t
            yy, xx = int(round(p[1])), int(round(p[0]))
            for dy in range(-4, 5):
                for dx in range(-4, 5):
                    y2, x2 = yy + dy, xx + dx
                    if 0 <= y2 < work.shape[0] and 0 <= x2 < work.shape[1]:
                        work[y2, x2] = False
d = Image.fromarray(np.array(Image.open('src/dt79-raw.png').convert('L'))).convert('RGB')
dd = ImageDraw.Draw(d)
cols = [(255,0,0),(0,0,255),(0,160,0),(255,0,255),(0,160,160),(160,80,0)]
for k, P in enumerate(out):
    dd.line(P, fill=cols[k % 6], width=1)
d.save('dbg79.png')
np.save('traces79.npy', np.array([len(p) for p in out]))
import json; json.dump([[list(map(float, p)) for p in P] for P in out], open('traces79.json', 'w'))
print('traces', [len(p) for p in out])
