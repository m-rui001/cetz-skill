"""Check polyline coverage of source ink and emit typ/dt62-spiral.typ."""
import numpy as np
from PIL import Image
from scipy import ndimage

a = (np.array(Image.open('src/dt62-raw.png').convert('L')) < 100)
import re
sp = [(int(x), int(y)) for x, y in re.findall(r'\((-?\d+),(-?\d+)\)', open('sp62.txt').read())]
P = np.array(sp, float)

# rasterise the polyline, then see how much source ink sits >3px away from it
m = np.zeros_like(a)
for i in range(len(P) - 1):
    p, q = P[i], P[i + 1]
    L = np.hypot(*(q - p))
    n = max(int(L), 1)
    t = np.linspace(0, 1, n + 1)[:, None]
    pts = p + t * (q - p)
    m[np.clip(pts[:, 1].round().astype(int), 0, a.shape[0] - 1),
      np.clip(pts[:, 0].round().astype(int), 0, a.shape[1] - 1)] = True
md = ndimage.distance_transform_edt(~m)
gap = a & (ndimage.binary_dilation(m, np.ones((3, 3))) == False)
bad = a & (md > 3)
print('ink %d  uncovered>3px %d  (%.1f%%)' % (a.sum(), bad.sum(), 100 * bad.sum() / a.sum()))
lab, n = ndimage.label(bad, np.ones((3, 3)))
for i in np.argsort([-int((lab == k).sum()) for k in range(1, n + 1)])[:8]:
    k = i + 1
    p = np.argwhere(lab == k)
    if len(p) < 30:
        continue
    print('  gap comp %d px %d  x %d..%d y %d..%d' % (k, len(p), p[:, 1].min(), p[:, 1].max(), p[:, 0].min(), p[:, 0].max()))

def fmt(pts, per=8):
    return '\n           '.join(','.join('(%d,%d)' % p for p in pts[i:i + per])
                               for i in range(0, len(pts), per))

T = '''#set page(width: auto, height: auto, margin: 2pt)
#set text(size: 5.9pt)
#import "@preview/cetz:0.4.2": canvas, draw

#canvas({
  import draw: *
  let S = 148.0
  let px = (x, y) => (x / S, (628.0 - y) / S)
  let P = (pts) => pts.map(p => px(p.at(0), p.at(1)))
  let t = (thickness: 1.0pt)
  let hd = (symbol: ">", fill: black, length: 9pt, width: 4pt)

  let sp = (%s)

  line(path: true, ..P(sp), stroke: t)
  line(px(400, 276), px(878, 446), stroke: (thickness: 1.5pt), mark: (end: hd))
  circle(px(400, 276), radius: 11.0 / S, fill: black, stroke: none)
  circle(px(565, 336), radius: 11.0 / S, fill: black, stroke: none)

  content(px(19, 472), anchor: "center", [$X$])
  content(px(413, 251), anchor: "center", [$z_0$])
  content(px(575, 366), anchor: "center", [$z_1$])
  content(px(903, 452), anchor: "center", [$r$])
  content(px(795, 296), anchor: "north-west", [$W_2 (X, z_0) = W_2 (X, z_1) + 3 " " mod " " 2$])
})
''' % fmt(sp)
open('typ/dt62-spiral.typ', 'w', encoding='utf-8', newline='\n').write(T)
print('wrote typ/dt62-spiral.typ with', len(sp), 'verts')
