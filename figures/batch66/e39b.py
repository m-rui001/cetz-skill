import numpy as np
from PIL import Image

g = np.array(Image.open('src/dt39-raw.png').convert('L')) < 160
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


print('--- vertical axis at rows')
for y in [20, 60, 100, 150, 200, 250, 300, 320]:
    print(y, [t for t in runs(g[y, :]) if t[0] < 90])
print('--- horizontal axis at cols')
for x in [60, 150, 300, 500, 700, 900, 990]:
    print(x, [t for t in runs(g[:, x]) if t[0] > 300])
print('--- dash row band')
for y in range(100, 112):
    print(y, int(g[y].sum()))
print('--- left of first dash')
print(105, runs(g[105, 40:100], 40))
print('--- dots on axis: ink above axis near x 360-390 / 720-750')
for x in range(355, 396, 2):
    print(x, runs(g[:, x])[-4:])
print()
for x in range(715, 756, 2):
    print(x, runs(g[:, x])[-4:])
