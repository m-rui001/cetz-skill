import json
import numpy as np
from scipy import ndimage
from PIL import Image

tr = json.load(open('trace21.json'))
S = 148.0
Y0 = 316.0
m = np.load('m21.npy')

# dots: thick blobs that survive a 7x7 erosion, snapped onto curve X
er = ndimage.binary_erosion(m, np.ones((7, 7)))
lab, n = ndimage.label(er, structure=np.ones((3, 3)))
Xp = np.array(tr['X'])
dots = []
for i in range(1, n + 1):
    yy, xx = np.nonzero(lab == i)
    if len(yy) < 3: continue
    cx, cy = xx.mean(), yy.mean()
    if not (40 < cx < 600 and 15 < cy < 300): continue
    d = np.hypot(Xp[:, 0] - cx, Xp[:, 1] - cy)
    j = int(d.argmin())
    if d[j] > 14: continue
    dots.append((round(Xp[j, 0], 1), round(Xp[j, 1], 1)))
print('dots', dots)

# stroke width: median run length across a few columns
def runs(v):
    out, i = [], 0
    while i < len(v):
        if v[i]:
            j = i
            while j + 1 < len(v) and v[j + 1]: j += 1
            out.append(j - i + 1); i = j + 1
        else: i += 1
    return out
ws = [w for x in range(60, 560, 7) for w in runs(m[:, x]) if w <= 9]
print('stroke width median', int(np.median(ws)), len(ws))

def poly(pts):
    return ', '.join('px(%s,%s)' % (round(float(a), 1), round(float(b), 1)) for a, b in pts)

L = []
L.append('#set page(width: auto, height: auto, margin: 2pt)')
L.append('#set text(size: 6.3pt)')
L.append('#import "@preview/cetz:0.4.2": canvas, draw')
L.append('')
L.append('#canvas({')
L.append('  import draw: *')
L.append('  let S = %s' % S)
L.append('  let px = (x, y) => (x / S, (%s - y) / S)' % Y0)
L.append('')
for k, name in enumerate(('X', 'Z')):
    pts = [p for p in tr[name] if isinstance(p, list) or isinstance(p, tuple)]
    pts = pts + [pts[0]]
    L.append('  line(path: true, stroke: (thickness: 1.05pt, cap: "round"), %s)' % poly(pts))
    L.append('')
for x, y in dots:
    L.append('  circle(px(%s,%s), radius: 6.5 / S, fill: black, stroke: none)' % (x, y))
L.append('')

for cx, cy, txt in [(24,157,'$X$'), (591.5,154,'$Z$'),
                    (753.5,152.5,r'\#'), (772.0,156.0,'('), (795.5,152.5,'$X$'),
                    (824.5,152.5,r'\u{2229}'), (853.5,152.5,'$Z$'), (873.0,155.0,')'),
                    (908.5,150.5,'='), (942.5,153.0,'4')]:
    L.append('  content(px(%s,%s), anchor: "center", [#text(size: 6.0pt)[%s]])' % (cx, cy, txt))

L.append('})')
open('typ/dt21-intersect.typ', 'w', newline='\n').write('\n'.join(L) + '\n')
print('wrote typ, X pts', len(tr['X']), 'Z pts', len(tr['Z']))
