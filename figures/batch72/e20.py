import tr, numpy as np, json
from PIL import Image, ImageDraw
from scipy import ndimage
m = tr.load('src/dt20-raw.png')
lab = tr.comps(12)[0][6]
work = (lab == 1)
print('start px', work.sum())
def wipe(P, r=2):
    global work
    yy, xx = np.mgrid[-r:r+1, -r:r+1]
    off = np.c_[yy.ravel(), xx.ravel()]
    for a, b in zip(P[:-1], P[1:]):
        for t in np.linspace(0, 1, max(2, int(np.hypot(*(b - a)) / 2))):
            p = a + (b - a) * t
            yi, xi = int(round(p[1])), int(round(p[0]))
            for dy, dx in off:
                y2, x2 = yi + dy, xi + dx
                if 0 <= y2 < work.shape[0] and 0 <= x2 < work.shape[1]:
                    work[y2, x2] = False
traces = []
for it in range(10):
    ys, xs = np.nonzero(work)
    if len(ys) < 40: break
    lx = int(xs.min())
    tr.mask_of(work)
    cand = [(float(x), float(y)) for y, x in zip(ys[xs <= lx + 2], xs[xs <= lx + 2])]
    seen, starts = set(), []
    for p in cand:
        k = (int(p[0]), round(p[1] / 3))
        if k not in seen:
            seen.add(k); starts.append(p)
    pts, tag, st = None, None, None
    for sp in starts:
        for hd in (-90.0, 90.0):
            q, tg = tr.trace(sp, hd, nsteps=40, jump=3)
            if len(q) >= 12:
                pts, tag = tr.trace(sp, hd, jump=3); st = sp
                break
        if pts: break
    if pts is None:
        pts, tag, st = [], 'FAIL', starts[0]
    if len(pts) < 10:
        l2, n2 = ndimage.label(work, structure=np.ones((3, 3)))
        cid = l2[int(round(st[1])), int(round(st[0]))] if st and work[int(round(st[1])), int(round(st[0]))] else 0
        yy, xx = np.nonzero(l2 == cid)
        print(it, 'drop comp', cid, len(yy), 'x', xx.min(), xx.max(), 'y', yy.min(), yy.max())
        work = work & (l2 != cid) if cid else work
        continue
    P = np.array(pts)
    print(it, tag, len(pts), 'bbox x', round(P[:,0].min(),1), round(P[:,0].max(),1), 'y', round(P[:,1].min(),1), round(P[:,1].max(),1))
    traces.append([list(map(float, p)) for p in pts])
    wipe(P, 3)
l2, n2 = ndimage.label(work, structure=np.ones((3, 3)))
left = []
for i in range(1, n2 + 1):
    yy, xx = np.nonzero(l2 == i)
    if len(yy) < 6: continue
    left.append([float(xx.min()), float(yy.min()), float(xx.max()), float(yy.max()), len(yy)])
print('leftover comps', len(left))
for q in left: print('  ', [round(v, 1) for v in q])
json.dump({'traces': traces, 'left': left}, open('dec20.json', 'w'))
d = Image.fromarray(np.array(Image.open('src/dt20-raw.png').convert('L'))).convert('RGB')
dd = ImageDraw.Draw(d)
cols = [(255,0,0),(0,0,255),(0,160,0),(255,0,255),(0,160,160),(160,80,0)]
for k, T in enumerate(traces): dd.line(T, fill=cols[k % 6], width=1)
d.save('dbg20.png')
