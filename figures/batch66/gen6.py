import numpy as np
from PIL import Image

g = np.array(Image.open('src/dt6-raw.png').convert('L')) < 160
H, W = g.shape


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


def ly(x):
    return 257.5 + (252.5 - 257.5) * (x - 5) / 692.0


X0, X1 = 24, 647
curve = {}
for x in range(X0, X1 + 1):
    rr = runs(g[:, x])
    cand = [t for t in rr if abs((t[0] + t[1]) / 2 - ly(x)) > 6]
    if len(cand) == 1 and cand[0][1] - cand[0][0] <= 14:
        curve[x] = (cand[0][0] + cand[0][1]) / 2.0
xs = sorted(curve)
print('measured', len(xs), 'ends', xs[0], curve[xs[0]], xs[-1], curve[xs[-1]])
# gap report
gap = [(a, b) for a, b in zip(xs, xs[1:]) if b - a > 1]
print('gaps', gap)
# interpolate
full = [(x, curve[x]) for x in xs]
add = []
for a, b in gap:
    for x in range(a + 1, b):
        add.append((x, curve[a] + (curve[b] - curve[a]) * (x - a) / (b - a)))
full = sorted(full + add)
# force the tangency through the dot centre
DOT = (340.0, 254.5)
full = [(x, y) for x, y in full if abs(x - DOT[0]) > 3] + [DOT]
full.sort()
print('total', len(full), 'min y', min(y for _, y in full))
cv = [full[0]] + [p for i, p in enumerate(full[1:-1], 1) if i % 4 == 0] + [full[-1]]
print('cv', len(cv))

fmt = lambda pts: ', '.join('px(%.1f,%.1f)' % p for p in pts)

typ = f'''#set page(width: auto, height: auto, margin: 2pt)
#set text(size: 6.5pt)
#import "@preview/cetz:0.4.2": canvas, draw

#canvas({{
  import draw: *
  let S = 148.0
  let px = (x, y) => (x / S, ({H}.0 - y) / S)

  line(px(5,257.5), px(697,252.5), stroke: (thickness: 0.8pt))
  line(path: true, stroke: (thickness: 1.2pt, cap: "round"), {fmt(cv)})
  circle(px(DOT[0], DOT[1]), 8.0 / S, fill: black, stroke: none)

  content(px(701,30.5), anchor: "center", [$f(bold(R)^1)$])
  content(px(719.5,253), anchor: "center", [$Z$])
}})
'''
open('typ/dt6-tangent.typ', 'w', newline='').write(typ)
print('written')
