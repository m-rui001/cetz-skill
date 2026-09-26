import json

S = json.load(open('segs15.json'))


def blk(name, pts, closed=True):
    lines = []
    for i in range(0, len(pts), 6):
        lines.append('    ' + ', '.join('(%g,%g)' % (p[0], p[1]) for p in pts[i:i + 6]))
    body = ',\n'.join(lines)
    return '  let %s = (\n%s\n  )\n' % (name, body)


typ = '#set page(width: auto, height: auto, margin: 2pt)\n'
typ += '#set text(size: 6.5pt)\n'
typ += '#import "@preview/cetz:0.4.2": canvas, draw\n\n'
typ += '#canvas({\n  import draw: *\n  let S = 148.0\n'
typ += '  let px = (x, y) => (x / S, (338.0 - y) / S)\n'
typ += '  let P = (pts) => pts.map(p => px(p.at(0), p.at(1)))\n'
typ += '  let t = (thickness: 0.95pt)\n\n'
for nm, key in (('oo', 'outer'), ('ii', 'inner'), ('hh', 'hole'), ('zz', 'zz')):
    typ += blk(nm, S[key])
for nm, key in (('al', 'al'), ('ar', 'ar')):
    typ += blk(nm, S[key], False)
typ += """
  line(path: true, cycle: true, ..P(oo), stroke: t)
  line(path: true, cycle: true, ..P(ii), stroke: t)
  line(path: true, cycle: true, ..P(hh), stroke: t)
  line(path: true, cycle: true, ..P(zz), stroke: t)
  line(path: true, ..P(al), stroke: t)
  line(path: true, ..P(ar), stroke: t)

  content(px(233.5, 81.5), anchor: "center", [#$Z$])
  content(px(423.5, 174.5), anchor: "center", [#$X$])
  content(px(519, 80.5), anchor: "west", [Two circles on the torus])
  content(px(521, 176), anchor: "west", [$I ( X , Z ) = - I ( Z , X )$])
})
"""
open('typ/dt15-torus.typ', 'w').write(typ)
print('written')
