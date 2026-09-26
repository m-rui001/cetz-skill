import numpy as np

bnd = np.load('bnd61b.npy')
H = 164
S = 148.0


def P(x, y):
    return 'px(%.1f,%.1f)' % (x, y)


oval = [bnd[i] for i in range(0, 360, 3)]
oval = list(oval) + [oval[0]]
ovals = ', '.join(P(*p) for p in oval)

# star: 3 strokes through (22,87) at 43,144,95 deg, half length 14.5
st = []
for a in (43, 144, 95):
    t = np.deg2rad(a)
    dx, dy = np.cos(t), np.sin(t)
    st.append((22 - 13.0 * dx, 87 - 13.0 * dy, 22 + 13.0 * dx, 87 + 13.0 * dy))
strokes = '\n'.join('  line(%s, %s, stroke: (thickness: 1.1pt, cap: "round"))'
                    % (P(a, b), P(c, d)) for a, b, c, d in st)

# wavy line
c = np.array(__import__('json').loads(open('line61.json').read()))
w = [[424, 87.5]] + [c[i] for i in range(0, len(c), 5)] + [[791, 77.0]]
wavys = ', '.join(P(*p) for p in w)

heads = [
    [(427, 87), (425, 79), (430, 75)],
    [(427, 90), (430, 96), (436, 99)],
    [(783, 63), (787, 69), (791, 76)],
    [(791, 78), (785, 86), (779, 90)],
]
hd = '\n'.join('  line(path: true, stroke: (thickness: 1.25pt, cap: "round"), %s)'
               % ', '.join(P(*p) for p in h) for h in heads)

typ = f'''#set page(width: auto, height: auto, margin: 2pt)
#set text(size: 6.8pt)
#import "@preview/cetz:0.4.2": canvas, draw

#canvas({{
  import draw: *
  let S = {S}
  let px = (x, y) => (x / S, ({H}.0 - y) / S)

  line(path: true, stroke: (thickness: 1.1pt, cap: "round"), {ovals})
{strokes}
  line(path: true, stroke: (thickness: 1.15pt, cap: "round"), {wavys})
{hd}

  content(px(236.5,86), anchor: "center", [$L$])
  content(px(336.5,80.5), anchor: "center", [#text(size: 8.6pt)[or]])
  content(px(744.5,101.5), anchor: "center", [$L$])
}})
'''
open('typ/dt61-loop.typ', 'w', newline='').write(typ)
print('ok', len(oval), len(w))
