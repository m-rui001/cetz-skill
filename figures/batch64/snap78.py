import numpy as np
from PIL import Image
from scipy import ndimage

a = np.array(Image.open('src/dt78-raw.png').convert('L')) < 160
lab, n = ndimage.label(a, structure=np.ones((3, 3)))
c1 = lab == 1
rough = [(519,4),(513,12),(506,20),(499,28),(495,36),(492,44),(491,52),(491,60),(491,68),(493,76),
         (496,84),(499,92),(503,100),(506,108),(508,116),(510,124),(510,132),(509,140),(506,148),
         (501,156),(495,164),(488,172),(480,180),(473,188),(465,196),(460,204),(452,212),(452,220),
         (451,228),(450,236),(451,244),(454,252),(458,260),(464,268),(470,276),(475,284),(480,292),
         (484,300),(487,308),(490,316),(493,324),(495,332),(497,340),(498,348),(499,356),(499,364),
         (499,372),(498,380),(497,388),(496,396),(495,404),(494,412),(494,420),(494,428),(494,436),
         (494,444),(495,452),(495,460),(497,468),(497,476),(499,484),(501,492),(504,500),(508,508),
         (513,516),(521,524),(525,531)]

ys, xs = np.nonzero(c1)
pts = np.stack([xs, ys], 1).astype(float)


def snap(p, r=6.0, it=4):
    q = np.array(p, float)
    for _ in range(it):
        sel = ((pts - q) ** 2).sum(1) < r * r
        if not sel.any():
            print('  MISS', p)
            return q
        nq = pts[sel].mean(0)
        if np.hypot(*(nq - q)) < 0.4:
            return nq
        q = nq
    return q


curve = [snap(p) for p in rough]

m = np.zeros(a.shape, bool)
p = np.array(curve)
for i in range(len(p) - 1):
    u, v = p[i], p[i + 1]
    L = int(np.hypot(*(v - u))) + 1
    for t in range(L + 1):
        x, y = u + (v - u) * t / L
        m[max(0, int(y) - 3):int(y) + 4, max(0, int(x) - 3):int(x) + 4] = True
bad = c1 & ~ndimage.binary_dilation(m, np.ones((7, 7)))
print('curve ink %d uncovered %d (%.1f%%)' % (c1.sum(), bad.sum(), 100 * bad.sum() / c1.sum()))

lines = []
for i in range(0, len(curve), 6):
    lines.append('    ' + ', '.join('(%g,%g)' % (c[0], c[1]) for c in curve[i:i + 6]))
body = ',\n'.join(lines)

typ = f'''#set page(width: auto, height: auto, margin: 2pt)
#set text(size: 6.0pt)
#import "@preview/cetz:0.4.2": canvas, draw

#canvas({{
  import draw: *
  let S = 148.0
  let px = (x, y) => (x / S, (545.0 - y) / S)
  let P = (pts) => pts.map(p => px(p.at(0), p.at(1)))
  let t = (thickness: 0.95pt)
  let hd = (symbol: ">", fill: black, length: 6.9pt, width: 2.7pt)

  let yy = (
{body}
  )

  line(path: true, ..P(yy), stroke: t)
  line(px(10, 225.5), px(306, 226), stroke: t, mark: (end: hd))
  circle(px(452, 220), radius: 8.0 / S, fill: black, stroke: none)

  content(px(161, 200), anchor: "center", [#text(size: 6.6pt)[$f$]])
  content(px(479, 220), anchor: "center", [#text(size: 6.4pt)[$y$]])
  content(px(549, 529), anchor: "center", [#text(size: 6.2pt)[$Y$]])
}})
'''
open('typ/dt78-map.typ', 'w').write(typ)
print('written')
