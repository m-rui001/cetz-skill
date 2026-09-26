import numpy as np
from PIL import Image

g = np.array(Image.open('src/dt39-raw.png').convert('L')) < 160


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


for x in list(range(330, 400, 4)) + list(range(400, 480, 8)) + list(range(480, 700, 20)) + list(range(690, 790, 6)) + list(range(790, 830, 8)):
    print(x, runs(g[:, x]))
