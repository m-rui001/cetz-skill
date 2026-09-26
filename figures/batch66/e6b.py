import numpy as np
from PIL import Image

g = np.array(Image.open('src/dt6-raw.png').convert('L')) < 160

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

print('--- left branch top')
for y in range(21, 60, 2):
    r = [t for t in runs(g[y, :]) if t[1] < 200]
    print(y, r)
print('--- right branch top')
for y in range(21, 45, 2):
    r = [t for t in runs(g[y, :]) if 600 < t[0] < 665]
    print(y, r)
print('--- line ends')
for x in list(range(3, 12)) + list(range(690, 700)):
    print(x, runs(g[:, x]))
print('--- dot: ink below line')
for y in range(250, 268):
    r = [t for t in runs(g[y, :]) if 300 < t[0] < 390]
    print(y, r)
