import numpy as np
from PIL import Image

g = np.array(Image.open('src/dt6-raw.png').convert('L')) < 160
H, W = g.shape

def runs(a, off=0):
    out, i = [], 0
    while i < len(a):
        if a[i]:
            j = i
            while j < len(a) and a[j]:
                j += 1
            out.append((i + off, j - 1 + off))
            i = j
        else:
            i += 1
    return out

for x in [5, 20, 50, 100, 200, 300, 320, 330, 340, 350, 400, 500, 600, 650, 690, 696]:
    print('x', x, runs(g[:, x]))
print()
for y in [22, 60, 120, 180, 230, 245, 252, 258, 262]:
    r = runs(g[y, :])
    print('y', y, [(a, b, (a + b) / 2) for a, b in r][:8], 'n=', len(r))
