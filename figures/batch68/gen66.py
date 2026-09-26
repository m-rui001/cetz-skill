import numpy as np
from PIL import Image
from scipy import ndimage

g = np.array(Image.open('src/dt66-raw.png').convert('L')) < 160
H, W = g.shape
lab, n = ndimage.label(g, structure=np.ones((3, 3)))
S, Y0 = 148.0, H


def P(x, y):
    return 'px(%.1f,%.1f)' % (x, y)


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


def hull(pts):
    pts = sorted({tuple(p) for p in np.round(np.asarray(pts, float)).astype(int)})
    def cr(o, a, b):
        return (a[0]-o[0])*(b[1]-o[1]) - (a[1]-o[1])*(b[0]-o[0])
    lo, up = list(pts), list(reversed(pts))
    lower, upper = [], []
    for p in lo:
        while len(lower) >= 2 and cr(lower[-2], lower[-1], p) <= 0:
            lower.pop()
        lower.append(p)
    for p in up:
        while len(upper) >= 2 and cr(upper[-2], upper[-1], p) <= 0:
            upper.pop()
        upper.append(p)
    return lower[:-1] + upper[:-1]


def blob_hull(cid, x0, x1, y0, y1):
    ys, xs = np.nonzero(lab == cid)
    sel = (xs >= x0) & (xs <= x1) & (ys >= y0) & (ys <= y1)
    return hull(np.c_[xs[sel], ys[sel]])


# ---- 1: R^1 double arrow (open V barbs)
ln = []
for x in range(24, 292):
    rr = runs((lab == 7)[:, x])
    if len(rr) == 1 and rr[0][1] - rr[0][0] <= 8:
        ln.append((x, (rr[0][0] + rr[0][1]) / 2))
ln = [ln[i] for i in range(0, len(ln), 10)] + [ln[-1]]
vheads = [((24, 106), (53, 98.5), (56, 112.5)),
          ((291, 107), (257, 100.5), (256, 114))]

# ---- 2: wrap arc
arc = []
for x in range(410, 601):
    rr = runs((lab == 6)[:, x])
    if len(rr) == 1 and rr[0][1] - rr[0][0] <= 12:
        arc.append((x, (rr[0][0] + rr[0][1]) / 2))
arc = [arc[i] for i in range(0, len(arc), 6)] + [arc[-1], (636, 114)]
wrap_h = blob_hull(6, 600, 640, 85, 120)

# ---- 3: figure eight via first-hit polar binning on each lobe
C = (852.0, 114.5)
m1 = lab == 1
lobs = []
for cy in (58.0, 165.0):
    cx = 847.0
    pd = {}
    for deg in range(360):
        t = np.deg2rad(deg)
        dx, dy = np.cos(t), np.sin(t)
        for k in np.arange(4.0, 200.0, 0.5):
            x, y = cx + dx * k, cy + dy * k
            if not (0 <= x < W and 0 <= y < H):
                break
            if m1[int(round(y)), int(round(x))]:
                if (cy - 60) < y < (cy + 60) or True:
                    pd[deg] = (x, y)
                break
    for d in range(360):
        if d not in pd:
            for b in range(1, 40):
                if (d - b) % 360 in pd and (d + b) % 360 in pd:
                    p0, p1 = pd[(d - b) % 360], pd[(d + b) % 360]
                    pd[d] = ((p0[0]+p1[0])/2, (p0[1]+p1[1])/2)
                    break
    pts = [pd[d] for d in range(360)]
    r = np.array([np.hypot(p[0]-cx, p[1]-cy) for p in pts])
    med = ndimage.median_filter(np.r_[r, r, r], 25)[360:720]
    r2 = np.where(np.abs(r-med) > 9, med, r)
    pts = [(cx + np.cos(np.deg2rad(d))*v, cy + np.sin(np.deg2rad(d))*v)
           for d, v in zip(range(360), r2)]
    keep = [p for p in pts if (p[1] < 116 if cy < 100 else p[1] > 112)]
    k = int(np.argmin([np.hypot(p[0]-C[0], p[1]-C[1]) for p in keep]))
    keep[k] = C
    lobs.append(keep)
    print('lobe cy', cy, 'n', len(keep))

eight_h = [blob_hull(1, 855, 895, 82, 112), blob_hull(1, 798, 842, 118, 145)]

polys = []
for pts in lobs:
    polys.append('  line(path: true, stroke: (thickness: 1.15pt, cap: "round"), %s)'
                 % ', '.join(P(*p) for p in pts[::3] + [pts[0]]))
fills = []
for h in [wrap_h] + eight_h:
    fills.append('  line(close: true, fill: black, stroke: none, %s)'
                 % ', '.join(P(*p) for p in h))
vs = []
for tip, b1, b2 in vheads:
    vs.append('  line(path: true, stroke: (thickness: 0.95pt, cap: "round"), %s)'
              % ', '.join(P(*p) for p in [b1, tip, b2]))

typ = f'''#set page(width: auto, height: auto, margin: 2pt)
#set text(size: 6.8pt)
#import "@preview/cetz:0.4.2": canvas, draw

#canvas({{
  import draw: *
  let S = {S}
  let px = (x, y) => (x / S, ({Y0}.0 - y) / S)

  line(path: true, stroke: (thickness: 1.1pt, cap: "round"), {', '.join(P(*p) for p in ln)})
  line(path: true, stroke: (thickness: 1.15pt, cap: "round"), {', '.join(P(*p) for p in arc)})
{chr(10).join(polys)}
{chr(10).join(vs)}
{chr(10).join(fills)}

  content(px(157.5,134), anchor: "center", [#text(size: 6.2pt)[$bold(R)^1$]])
  content(px(524.5,49), anchor: "center", [#text(size: 6.2pt)[Wrap]])
  content(px(527,110), anchor: "center", [#text(size: 6.5pt)[around]])
}})
'''
open('typ/dt66-wrap.typ', 'w', newline='').write(typ)
print('written', len(wrap_h), len(eight_h[0]), len(eight_h[1]))
