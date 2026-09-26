import numpy as np
from PIL import Image
from scipy import ndimage

NAME = 'dt16'
a = np.array(Image.open('src/%s-raw.png' % NAME).convert('L')) < 160
lab, n = ndimage.label(a, structure=np.ones((3, 3)))
c = lab == 6
ys, xs = np.nonzero(c)
P = np.stack([xs, ys], 1).astype(float)
Q = P[(P[:, 1] < 206) | (P[:, 1] > 226)]
for cc in ([348, 65], [348, 216]):
    Q = Q[np.hypot(*(Q - np.array(cc, float)).T) > 13]
A = np.c_[2 * Q[:, 0], 2 * Q[:, 1], np.ones(len(Q))]
sol, *_ = np.linalg.lstsq(A, (Q ** 2).sum(1), rcond=None)
cx, cy = sol[0], sol[1]
r = np.sqrt(sol[2] + cx * cx + cy * cy)
res = np.abs(np.hypot(Q[:, 0] - cx, Q[:, 1] - cy) - r)
print('circle %.1f %.1f r %.1f  frac<3px %.3f' % (cx, cy, r, (res < 3).mean()))

S, Y0 = 148.0, 319.0
body = ['''#set page(width: auto, height: auto, margin: 2pt)
#set text(size: 6.5pt)
#import "@preview/cetz:0.4.2": canvas, draw

#canvas({
  import draw: *
  let S = %.1f
  let px = (x, y) => (x / S, (%.1f - y) / S)
  let t = (thickness: 1.05pt)
  let hd = (symbol: ">", fill: black, length: 3.9pt, width: 2.9pt)

  circle(px(%.1f, %.1f), radius: %.1f / S, stroke: t)
  line(px(12, 218), px(686, 214.5), stroke: t)
  line(px(348, 184), px(348, 91), stroke: (thickness: 1.15pt), mark: (end: hd))
  circle(px(348, 216), radius: 7.5 / S, fill: black, stroke: none)
  circle(px(348, 65), radius: 8.0 / S, fill: black, stroke: none)
  content(px(339, 30), anchor: "center", [#text(size: 6.8pt)[$phi_1(x)$]])
  content(px(255, 192), anchor: "center", [#text(size: 6.5pt)[$W$]])
  content(px(348, 236), anchor: "center", [#text(size: 6.5pt)[$x$]])
})
''' % (S, Y0, cx, cy, r)]
open('typ/%s-ball.typ' % NAME, 'w').write(body[0])
print('written typ/%s-ball.typ' % NAME)
