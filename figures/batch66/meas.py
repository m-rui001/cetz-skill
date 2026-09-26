"""Compare source ink box vs mapped render ink box inside a source-space window.
usage: python meas.py NAME OX OY X0 X1 Y0 Y1   (windows inclusive)
"""
import sys
import numpy as np
from PIL import Image

N, OX, OY = sys.argv[1], int(sys.argv[2]), int(sys.argv[3])
X0, X1, Y0, Y1 = [int(v) for v in sys.argv[4:8]]

s = np.array(Image.open(f'src/{N}-raw.png').convert('L')).astype(int) < 160
r = np.array(Image.open(f'png/{N}.png').convert('L')).astype(int) < 160
ys, xs = np.nonzero(s)
bsw = xs.max() - xs.min() + 1
rys, rxs = np.nonzero(r)
BR = [rxs.min(), rxs.max(), rys.min(), rys.max()]
sc = bsw / (BR[1] - BR[0] + 1)
rc = r[BR[2]:BR[3] + 1, BR[0]:BR[1] + 1]
big = np.array(Image.fromarray((rc * 255).astype('uint8')).resize(
    (int((BR[1] - BR[0] + 1) * sc), int((BR[3] - BR[2] + 1) * sc)), Image.LANCZOS)) > 128
gy, gx = np.nonzero(big)
mx = gx + BR[0] * 0 + OX          # mapped source coords
my = gy + OY
inw = (mx >= X0) & (mx <= X1) & (my >= Y0) & (my <= Y1)
sub = s[Y0:Y1 + 1, X0:X1 + 1]
sy, sx = np.nonzero(sub)


def fmt(t):
    return 'x %6.1f..%-6.1f w %5.1f  y %6.1f..%-6.1f h %5.1f  n %d' % t


print('src   ', fmt((sx.min() + X0, sx.max() + X0, sx.max() - sx.min() + 1,
                     sy.min() + Y0, sy.max() + Y0, sy.max() - sy.min() + 1, len(sx))))
if inw.sum():
    print('render', fmt((mx[inw].min(), mx[inw].max(), mx[inw].max() - mx[inw].min() + 1,
                         my[inw].min(), my[inw].max(), my[inw].max() - my[inw].min() + 1, inw.sum())))
else:
    print('render none')
