"""Generate typ/dt1-saddle.typ from dec1.json."""
import json

d = json.load(open('dec1.json'))
Y0 = 410.0
S = 148.0


def P(p):
    return 'px(%.1f,%.1f)' % (p[0], p[1])


L = ['#set page(width: auto, height: auto, margin: 2pt)',
     '#set text(size: 6.5pt)',
     '#import "@preview/cetz:0.4.2": canvas, draw',
     '',
     '#canvas({',
     '  import draw: *',
     '  let S = %.1f' % S,
     '  let px = (x, y) => (x / S, (%.1f - y) / S)' % Y0,
     '  let st = (thickness: 1.4pt, dash: none) => (paint: black, thickness: thickness, cap: "round", dash: dash)',
     '']

for k in ['a_tl', 'a_tm', 'a_tr', 'a_ml', 'a_mr', 'a_bl', 'a_bm', 'a_br']:
    a = d[k]
    sh = a['shaft']
    L.append('  // %s' % k)
    L.append('  line(stroke: st(), %s)' % ', '.join(P(p) for p in sh))
    tip = sh[-1]
    for b in a['barbs']:
        far = max(b[:2], key=lambda p: (p[0] - tip[0]) ** 2 + (p[1] - tip[1]) ** 2)
        L.append('  line(stroke: st(), %s, %s)' % (P(tip), P(far)))
dot = d['dot']
L.append('  circle(%s, radius: %.2f / S, fill: black, stroke: none)' % (P(dot['c']), dot['r']))
L.append('  content(px(195.5,399.0), anchor: "center", [#text(size: 6.2pt, weight: "bold")[Saddle]])')
L.append('})')
open('typ/dt1-saddle.typ', 'w', encoding='utf-8').write('\r\n'.join(L) + '\r\n')
print('wrote', len(L), 'lines')
