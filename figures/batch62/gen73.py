import json

segs = json.load(open('segs73.json'))
circle, lobe, ar1, ar2, ar3, ar4, ar5, ar6 = segs


def blk(name, pts, closed=False):
    lines = []
    for i in range(0, len(pts), 8):
        lines.append('    ' + ', '.join('(%g,%g)' % (p[0], p[1]) for p in pts[i:i + 8]))
    body = ',\n'.join(lines)
    if closed:
        body += ',\n    (%g,%g)' % tuple(pts[0])
    return '  let %s = (\n%s\n  )\n' % (name, body)


typ = '#set page(width: auto, height: auto, margin: 2pt)\n'
typ += '#set text(size: 5.9pt)\n'
typ += '#import "@preview/cetz:0.4.2": canvas, draw\n\n'
typ += '#canvas({\n  import draw: *\n  let S = 148.0\n'
typ += '  let px = (x, y) => (x / S, (430.0 - y) / S)\n'
typ += '  let P = (pts) => pts.map(p => px(p.at(0), p.at(1)))\n'
typ += '  let t = (thickness: 1.05pt)\n'
typ += '  let hd = (symbol: ">", fill: black, length: 7.5pt, width: 2.4pt)\n\n'
typ += blk('cc', circle)
typ += blk('ll', lobe)
for nm, s in (('a1', ar1), ('a2', ar2), ('a3', ar3), ('a4', ar4), ('a5', ar5), ('a6', ar6)):
    typ += blk(nm, s)
typ += '\n  line(path: true, cycle: true, ..P(cc), stroke: t)\n'
typ += '  line(path: true, cycle: true, ..P(ll), stroke: t)\n'
for nm in ('a1', 'a2', 'a3', 'a4', 'a5', 'a6'):
    typ += '  line(path: true, ..P(%s), stroke: (thickness: 1.05pt), mark: (end: hd))\n' % nm
typ += """
  content(px(28, 202), anchor: "center", [#$X$])
  content(px(651, 201), anchor: "center", [#$Z$])
  content(px(314, 132), anchor: "center", [#$+1$])
  content(px(277, 290), anchor: "center", [#$-1$])
  content(px(360, 404), anchor: "center", [#$"in " bold(R)^2$])
})
"""
open('typ/dt73-cross.typ', 'w').write(typ)
print('written', len(typ))
