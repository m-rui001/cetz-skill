import numpy as np
from PIL import Image
from scipy import ndimage

g = np.array(Image.open('src/dt66-raw.png').convert('L')) < 160
lab, n = ndimage.label(g, structure=np.ones((3, 3)))
m = lab == 1


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


for y in range(9, 214, 4):
    rr = runs(m[y, :])
    print('%3d n=%d ' % (y, len(rr)) + ' '.join('%d-%d' % t for t in rr))
