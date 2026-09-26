import numpy as np
from PIL import Image
from scipy import ndimage

g = np.array(Image.open('src/dt61-raw.png').convert('L')) < 160
H, W = g.shape
print('shape', H, W)
lab, n = ndimage.label(g, structure=np.ones((3, 3)))
print('ncomp', n)
for i in range(1, n + 1):
    ys, xs = np.nonzero(lab == i)
    if len(ys) < 12:
        continue
    print(i, len(ys), 'x', xs.min(), xs.max(), 'y', ys.min(), ys.max())
