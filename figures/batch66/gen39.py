import numpy as np
from PIL import Image
from scipy import ndimage

g = np.array(Image.open('src/dt39-raw.png').convert('L')) < 160
H, W = g.shape
lab, n = ndimage.label(g, structure=np.ones((3, 3)))


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


# ---- curve: component 1, runs above the axis
m = lab == 1
AXY = lambda x: 325.2 + (322.5 - 325.2) * (x - 54) / (994 - 54)
pts = {}
for x in range(380, 752):
    rr = runs(m[:, x])
    cand = [t for t in rr if (t[0] + t[1]) / 2 < 316]
    if len(cand) == 1:
        a, b = cand[0]
        pts[x] = (a + b) / 2.0
xs = sorted(pts)
print('curve cols', len(xs), xs[0], xs[-1])
gap = [(a, b) for a, b in zip(xs, xs[1:]) if b - a > 1]
print('gaps', gap)
full = [(x, pts[x]) for x in xs]
for a, b in gap:
    for x in range(a + 1, b):
        full.append((x, pts[a] + (pts[b] - pts[a]) * (x - a) / (b - a)))
full.sort()
D1, D2 = (376.0, 322.0), (734.0, 321.0)
full = [p for p in full if abs(p[0] - D1[0]) > 4 and abs(p[0] - D2[0]) > 4]
full = [D1] + full + [D2]
full.sort()
cv = [full[0]] + [p for i, p in enumerate(full[1:-1], 1) if i % 3 == 0] + [full[-1]]
print('cv', len(cv), 'ymin', min(y for _, y in cv))

# ---- dashes
dash = []
for i in range(2, n + 1):
    ys, xsl = np.nonzero(lab == i)
    if len(ys) < 15 or ys.min() > 200:
        continue
    if xsl.min() < 50:      # the t_i label
        continue
    x0, x1 = xsl.min(), xsl.max()
    ya = ys[xsl <= x0 + 2].mean()
    yb = ys[xsl >= x1 - 2].mean()
    dash.append((x0, ya, x1, yb))
dash.sort()
print('dashes', len(dash))
for d in dash:
    print('  %.1f %.1f -> %.1f %.1f' % d)

fmt = lambda p: 'px(%.1f,%.1f)' % p
cur = ', '.join(fmt(p) for p in cv)
dl = '\n'.join('  line(%s, %s, stroke: (thickness: 0.9pt))'
               % (fmt((a, b)), fmt((c, d))) for a, b, c, d in dash)

typ = f'''#set page(width: auto, height: auto, margin: 2pt)
#set text(size: 7pt)
#import "@preview/cetz:0.4.2": canvas, draw

#canvas({{
  import draw: *
  let S = 148.0
  let px = (x, y) => (x / S, ({H}.0 - y) / S)

  line(px(55.8,12), px(58.2,325), stroke: (thickness: 0.9pt))
  line(px(54,325.2), px(994,322.5), stroke: (thickness: 0.9pt))
{dl}
  line(path: true, stroke: (thickness: 1.3pt, cap: "round"), {cur})
  circle(px(D1[0], D1[1]), radius: 9.0 / S, fill: black, stroke: none)
  circle(px(D2[0], D2[1]), radius: 8.5 / S, fill: black, stroke: none)

  content(px(32.5,106), anchor: "center", [$t_i$])
  content(px(374,350), anchor: "center", [$i$])
  content(px(735,349), anchor: "center", [$i+1$])
}})
'''
open('typ/dt39-bump.typ', 'w', newline='').write(typ)
print('written')
