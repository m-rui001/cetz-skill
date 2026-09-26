import tr, numpy as np
from PIL import Image, ImageDraw

S = 148.0
m = tr.load('src/dt25-raw.png')
H, W = m.shape
Y0 = float(H)
lab = tr.comps(15)[0][6]
circ = (lab == 1)
ys, xs = np.nonzero(circ)
lx = int(xs.min())
x0s = xs[xs <= lx + 1]
start = (float(lx), float(ys[xs <= lx + 1].mean()))
tr.mask_of(circ)
pts, st = tr.trace(start, -90.0)
print('start', start, 'trace', st, len(pts))

A, B, X = (93.9, 165.4), (399.2, 132.7), (246.8, 148.3)
def lny(x): return A[1] + (B[1] - A[1]) * (x - A[0]) / (B[0] - A[0])
chord = []
for x in range(int(A[0]) + 10, int(B[0]) - 9):
    for a, b in tr.runs(m[:, x]):
        c = (a + b) / 2.0
        if abs(c - lny(x)) < 6 and b - a <= 9:
            chord.append((float(x), c))
dev = [abs(c - lny(x)) for x, c in chord]
print('chord pts', len(chord), 'max dev', round(max(dev), 2), 'rms', round(float(np.hypot(*np.array(dev).T.std(axis=0)[::-1])) if False else float(np.std(dev)), 2))

def poly(P):
    return ', '.join('px(%s,%s)' % (round(float(a), 1), round(float(b), 1)) for a, b in P)

L = ['#set page(width: auto, height: auto, margin: 2pt)',
     '#set text(size: 6.3pt)',
     '#import "@preview/cetz:0.4.2": canvas, draw',
     '', '#canvas({', '  import draw: *',
     '  let S = %s' % S,
     '  let px = (x, y) => (x / S, (%s - y) / S)' % Y0, '']
L.append('  line(path: true, stroke: (thickness: 1.05pt, cap: "round"), %s)' % poly(pts + [pts[0]]))
L.append('  line(px(%s,%s), px(%s,%s))' % (A[0], A[1], B[0], B[1]))
for x, y, n in [(b[0], b[1], b[2]) for b in tr.blobs(7) if b[2] >= 40 and b[0] < 460]:
    r = 3.0 + (n / 3.14159) ** 0.5
    L.append('  circle(px(%s,%s), radius: %s / S, fill: black, stroke: none)' % (round(x, 1), round(y, 1), round(r, 1)))
L += ['  content(px(43,159.5), anchor: "center", [$g(x)$])',
      '  content(px(246,171.5), anchor: "center", [$x$])',
      '  content(px(406,160.5), anchor: "center", [$f(x)$])',
      '})']
open('typ/dt25-chord.typ', 'w', encoding='utf-8').write('\n'.join(L) + '\n')
d = Image.fromarray(np.array(Image.open('src/dt25-raw.png').convert('L'))).convert('RGB')
dd = ImageDraw.Draw(d)
dd.line(pts + [pts[0]], fill=(255, 0, 0), width=1)
dd.line(chord, fill=(0, 160, 0), width=1)
d.save('dbg25.png')
