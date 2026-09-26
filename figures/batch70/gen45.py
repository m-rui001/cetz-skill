import tr, numpy as np
from PIL import Image, ImageDraw

S = 148.0
m = tr.load('src/dt45-raw.png')
H, W = m.shape
Y0 = float(H)
full = tr.comps(15)
lab = full[0][6]
CID = [c[0] for c in full if c[3] - c[2] > 200]
print('ellipse comps', CID)

def poly(P):
    return ', '.join('px(%s,%s)' % (round(float(a), 1), round(float(b), 1)) for a, b in P)

L = ['#set page(width: auto, height: auto, margin: 2pt)',
     '#set text(size: 6.0pt)',
     '#import "@preview/cetz:0.4.2": canvas, draw',
     '', '#canvas({', '  import draw: *',
     '  let S = %s' % S,
     '  let px = (x, y) => (x / S, (%s - y) / S)' % Y0, '']
dbg = Image.fromarray(np.array(Image.open('src/dt45-raw.png').convert('L'))).convert('RGB')
dd = ImageDraw.Draw(dbg)
for cid in CID:
    sub = (lab == cid)
    ys, xs = np.nonzero(sub)
    lx = int(xs.min())
    st0 = (float(lx), float(ys[xs <= lx + 1].mean()))
    tr.mask_of(sub)
    pts, tag = tr.trace(st0, -90.0)
    print('comp', cid, tag, len(pts), 'bbox', int(pts[0][0]), st0)
    L.append('  line(path: true, stroke: (thickness: 1.05pt, cap: "round"), %s)' % poly(pts + [pts[0]]))
    dd.line(pts + [pts[0]], fill=(255, 0, 0), width=1)
tr.mask_of(m)
L.append('  line(px(162.5,478), px(163.5,559))')
L.append('  line(close: true, fill: black, stroke: none, px(157,557), px(171,557), px(164,589.5))')
for x, y, n, x0, x1, y0, y1 in tr.blobs(7):
    if n >= 40 and not (545 < y < 595):
        L.append('  circle(px(%s,%s), radius: %s / S, fill: black, stroke: none)' % (round(x, 1), round(y, 1), round(3.0 + (n / 3.14159) ** .5, 1)))
for cid in (7, 8, 9, 16, 17, 18):
    c = [q for q in full if q[0] == cid][0]
    cx, cy = (c[2] + c[3]) / 2.0, (c[4] + c[5]) / 2.0
    r = ((c[3] - c[2] + 1) + (c[5] - c[4] + 1)) / 4.0
    L.append('  circle(px(%s,%s), radius: %s / S, fill: black, stroke: none)' % (cx, cy, round(r, 1)))
for cx, cy, t in [(126, 60.5, '$x_1$'), (333.5, 55, '$V_1$'), (127.5, 229.5, '$x_i$'),
                  (333.5, 225, '$V_i$'), (128.5, 405, '$x_N$'), (339.5, 400.5, '$V_N$'),
                  (137, 648.5, '$y$'), (332.5, 645.5, '$U$'), (143.5, 532.5, '$f$')]:
    L.append('  content(px(%s,%s), anchor: "center", [#text(size: 6.0pt)[%s]])' % (cx, cy, t))
L.append('})')
open('typ/dt45-fibers.typ', 'w', encoding='utf-8').write('\n'.join(L) + '\n')
dbg.save('dbg45.png')
print('wrote')
