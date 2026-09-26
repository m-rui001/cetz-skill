import numpy as np
from PIL import Image

im = np.array(Image.open('src/dt19-raw.png').convert('L'))
g = im < 160
H, W = g.shape


def runs(v, off=0):
    out, i = [], 0
    while i < len(v):
        if v[i]:
            j = i
            while j + 1 < len(v) and v[j + 1]:
                j += 1
            out.append((off + i, off + j, j - i + 1))
            i = j + 1
        else:
            i += 1
    return out


# ---------- S-curve ----------
X0, X1, YA, YB = 66, 897, 18, 264
curve = []
for x in range(X0, X1):
    rr = [r for r in runs(g[YA:YB, x], YA) if r[2] <= 14]
    if not rr:
        continue
    if not curve:
        c = min(rr, key=lambda r: abs((r[0] + r[1]) / 2 - 205))
    else:
        pr = curve[-1][1]
        c = min(rr, key=lambda r: abs((r[0] + r[1]) / 2 - pr))
        if abs((c[0] + c[1]) / 2 - pr) > 12:
            continue
    curve.append((x, (c[0] + c[1]) / 2))

# decimate: keep every 6th column but always the ends
cv = [curve[0]] + [p for i, p in enumerate(curve[1:-1], 1) if i % 6 == 0] + [curve[-1]]


# ---------- braces ----------
def brace(xlo, xhi, ylo, yhi, step=2):
    out = []
    for y in range(ylo, yhi + 1):
        rr = runs(g[y, xlo:xhi], xlo)
        if not rr:
            continue
        out.append(((rr[0][0] + rr[-1][1]) / 2.0, y))
    return [out[0]] + [p for i, p in enumerate(out[1:-1], 1) if i % step == 0] + [out[-1]]


RB = brace(904, 930, 8, 137)
LB = brace(36, 60, 135, 266)


def poly(pts):
    return ', '.join('px(%g,%g)' % p for p in pts)


typ = r'''#set page(width: auto, height: auto, margin: 2pt)
#set text(size: 6.3pt)
#import "@preview/cetz:0.4.2": canvas, draw

#canvas({
  import draw: *
  let S = 148.0
  let px = (x, y) => (x / S, (%d - y) / S)
  let t = (thickness: 1.05pt)

  // frame
  line(px(61.5,13.0), px(900.5,11.0), stroke: t)
  line(px(61.5,139.0), px(900.5,138.5), stroke: t)
  line(px(61.5,269.5), px(900.5,269.5), stroke: t)
  line(px(61.5,13.0), px(61.5,269.5), stroke: t)
  line(px(900.5,11.0), px(900.5,269.5), stroke: t)

  // S-curve X' -> X
  line(path: true, %s, stroke: t)

  // right brace
  line(path: true, %s, stroke: t)
  // left brace
  line(path: true, %s, stroke: t)

  content(px(145.5,116), anchor: "center", [#text(size: 6.3pt)[$X$]])
  content(px(287,229), anchor: "center", [#text(size: 6.3pt)[$X^'$]])
  content(px(944,75), anchor: "center", [#text(size: 6.3pt)[$d$]])
  content(px(19.5,204), anchor: "center", [#text(size: 6.3pt)[$d$]])
})
''' % (H, poly(cv), poly(RB), poly(LB))

open('typ/dt19-bend.typ', 'w').write(typ)
print('curve pts', len(cv), 'RB', len(RB), 'LB', len(LB))
print('curve ends', cv[0], cv[-1])
print('RB ends', RB[0], RB[-1], 'LB ends', LB[0], LB[-1])
