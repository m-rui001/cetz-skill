"""Generate typ/dt20-rings.typ from the conic fits in fit20.json / tilted20.json."""
import json
import numpy as np

pr = json.load(open('fit20.json'))
tp = json.load(open('tilted20.json'))
Y0 = 296.0
S = 148.0


def pts(e, n=96, t0=0.0, t1=360.0):
    t = np.deg2rad(np.linspace(t0, t1, n, endpoint=(t1 - t0) < 360))
    a = np.deg2rad(e['angle'])
    ca, sa = np.cos(a), np.sin(a)
    x = np.cos(t) * e['rx']
    y = np.sin(t) * e['ry']
    return np.c_[e['cx'] + x * ca - y * sa, e['cy'] + x * sa + y * ca]


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
     '  let st = (thickness: 0.9pt, dash: none) => (paint: black, thickness: thickness, cap: "round", dash: dash)',
     '']

for k in ['outer', 'middle', 'inner']:
    Q = pts(pr[k], 96)
    L.append('  // %s ellipse' % k)
    L.append('  line(close: true, stroke: st(), %s)' % ', '.join(P(p) for p in Q))

# tilted ellipse: solid near half + dashed far half
Q = pts(tp, 48, 180.0, 360.0)
L.append('  // tilted Z: visible half')
L.append('  line(stroke: st(), %s)' % ', '.join(P(p) for p in Q))
Q = pts(tp, 48, 0.0, 180.0)
L.append('  // tilted Z: hidden half (dashed)')
L.append('  line(stroke: st(dash: (2.6pt, 1.3pt)), %s)' % ', '.join(P(p) for p in Q))

# arrow barbs on the inner curve
L.append('  // orientation arrows')
L.append('  line(stroke: st(), px(330.5,120.0), px(328.5,136.0))')
L.append('  line(stroke: st(), px(101.0,124.0), px(102.5,135.5))')

L.append('')
for cx, cy, sz, txt in [(99.0, 228.5, 6.3, '$X$'), (389.5, 135.0, 6.3, '$Z$'),
                        (490.0, 133.0, 6.2, '$I$'), (503.0, 142.5, 4.3, '2'),
                        (517.5, 136.0, 6.2, '\\('), (539.0, 132.5, 6.2, '$X$'),
                        (558.0, 141.5, 6.2, ','), (582.5, 132.0, 6.2, '$Z$'),
                        (603.0, 134.5, 6.2, '\\)'), (629.5, 132.5, 6.2, '='),
                        (656.5, 130.5, 6.2, '1')]:
    L.append('  content(px(%.1f,%.1f), anchor: "center", [#text(size: %.1fpt)[%s]])' % (cx, cy, sz, txt))
L.append('})')
open('typ/dt20-rings.typ', 'w', encoding='utf-8').write('\r\n'.join(L) + '\r\n')
print('wrote', len(L), 'lines')
