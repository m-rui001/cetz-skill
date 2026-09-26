import sys
import numpy as np
from PIL import Image
from scipy import ndimage

r = np.array(Image.open('png/dt11-deform.png').convert('L')) < 160
s = np.array(Image.open('src/dt11-raw.png').convert('L')) < 160
BR = [int(np.nonzero(r)[1].min()), int(np.nonzero(r)[1].max()),
      int(np.nonzero(r)[0].min()), int(np.nonzero(r)[0].max())]
sw = int(np.nonzero(s)[1].max()) - int(np.nonzero(s)[1].min()) + 1
sc = sw / (BR[1] - BR[0] + 1)
OX, OY = int(sys.argv[1]), int(sys.argv[2])
X0, X1, Y0, Y1 = [int(v) for v in sys.argv[3:7]]


def box(g):
    ys, xs = np.nonzero(g)
    return xs.min(), xs.max(), ys.min(), ys.max()


sr = s[Y0:Y1 + 1, X0:X1 + 1]
rx0 = int(round((X0 - OX) / sc)) + BR[0]
rx1 = int(round((X1 - OX) / sc)) + BR[0]
ry0 = int(round((Y0 - OY) / sc)) + BR[2]
ry1 = int(round((Y1 - OY) / sc)) + BR[2]
rr = r[ry0:ry1 + 1, rx0:rx1 + 1]
print('src  ', box(sr), 'w', box(sr)[1] - box(sr)[0] + 1, 'h', box(sr)[3] - box(sr)[2] + 1, 'ink', sr.sum())
b = box(rr)
conv = [round((b[0] - BR[0]) * sc + OX, 1), round((b[1] - BR[0]) * sc + OX, 1),
        round((b[2] - BR[2]) * sc + OY, 1), round((b[3] - BR[2]) * sc + OY, 1)]
print('render', conv, 'w', round((b[1] - b[0] + 1) * sc, 1), 'h', round((b[3] - b[2] + 1) * sc, 1), 'ink', rr.sum())
