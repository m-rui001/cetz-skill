import tr, numpy as np
S, N, NAME = 148.0, 'dt2', 'dt2-eight'
m = tr.load('src/%s-raw.png' % N)
Y0 = float(m.shape[0])
lab = tr.comps(12)[0][6]
sub = (lab == 1)
tr.mask_of(sub)
r = tr.runs(sub[int(np.nonzero(sub)[0].max()), :])
start = ((r[0][0] + r[0][1]) / 2.0, float(int(np.nonzero(sub)[0].max())))
pts, tag = tr.trace(start, -90.0)
print(tag, len(pts), 'start', start, 'end', pts[-1])
def poly(P): return ', '.join('px(%s,%s)' % (round(float(a),1), round(float(b),1)) for a, b in P)
L = ['#set page(width: auto, height: auto, margin: 2pt)', '#set text(size: 6.3pt)',
     '#import "@preview/cetz:0.4.2": canvas, draw', '', '#canvas({', '  import draw: *',
     '  let S = %s' % S, '  let px = (x, y) => (x / S, (%s - y) / S)' % Y0, '',
     '  line(path: true, stroke: (thickness: 1.1pt, cap: "round"), %s)' % poly(pts), '})']
open('typ/%s.typ' % NAME, 'w', encoding='utf-8').write('\n'.join(L) + '\n')
