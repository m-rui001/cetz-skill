import tr, numpy as np
S, N, NAME = 148.0, 'dt9', 'dt9-source'
m = tr.load('src/%s-raw.png' % N)
Y0 = float(m.shape[0])
full = tr.comps(12)
lab = full[0][6]
def pxs(p): return 'px(%s,%s)' % (round(float(p[0]), 1), round(float(p[1]), 1))
L = ['#set page(width: auto, height: auto, margin: 2pt)', '#set text(size: 6.5pt)',
     '#import "@preview/cetz:0.4.2": canvas, draw', '', '#canvas({', '  import draw: *',
     '  let S = %s' % S, '  let px = (x, y) => (x / S, (%s - y) / S)' % Y0, '', ]
for c in full:
    cid, n, x0, x1, y0, y1 = c[:6]
    if cid == 3 or cid >= 9 or x1 - x0 < 40:
        continue
    sub = (lab == cid)
    r = tr.arrow(sub)
    if not r:
        print('fail', cid); continue
    tail, tip, b1, b2 = r
    L.append('  line(stroke: (thickness: 1.15pt, cap: "round"), %s, %s)' % (pxs(tail), pxs(tip)))
    L.append('  line(stroke: (thickness: 1.15pt, cap: "round"), %s, %s)' % (pxs(tip), pxs(b1)))
    L.append('  line(stroke: (thickness: 1.15pt, cap: "round"), %s, %s)' % (pxs(tip), pxs(b2)))
c3 = [q for q in full if q[0] == 3][0]
cx, cy = (c3[2]+c3[3])/2.0, (c3[4]+c3[5])/2.0
L.append('  circle(%s, radius: %s / S, fill: black, stroke: none)' % (pxs((cx, cy)), round((c3[3]-c3[2]+c3[5]-c3[4])/4.0, 1)))
L.append('  content(px(193,356.5), anchor: "center", [#text(size: 6.5pt)[Source]])')
L.append('})')
open('typ/%s.typ' % NAME, 'w', encoding='utf-8').write('\n'.join(L) + '\n')
