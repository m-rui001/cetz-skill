import numpy as np
from PIL import Image
from scipy import ndimage

g = np.array(Image.open('src/dt66-raw.png').convert('L')) < 160
lab, n = ndimage.label(g, structure=np.ones((3, 3)))


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


for cid in (7, 6):
    m = lab == cid
    print('=== comp', cid)
    for x in range(m.nonzero()[1].min(), m.nonzero()[1].max() + 1, 10):
        rr = runs(m[:, x])
        print('%4d ' % x + ' '.join('%d-%d' % t for t in rr))
    print('cols with 0 runs:', [x for x in range(m.nonzero()[1].min(), m.nonzero()[1].max()+1) if not runs(m[:, x])][:10])
