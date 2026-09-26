import numpy as np
from scipy import ndimage
import tr, e33b

tr.load('src/it5-raw.png')
lab, n = ndimage.label(tr.M, structure=np.ones((3, 3)))
print('n comp', n, 'shape', tr.M.shape)
for i, sl in enumerate(ndimage.find_objects(lab), start=1):
    px = int((lab[sl] == i).sum())
    if px < 12:
        continue
    y0, y1, x0, x1 = sl[0].start, sl[0].stop - 1, sl[1].start, sl[1].stop - 1
    print(f'c{i:3d} px{px:6d} ({x0},{y0})-({x1},{y1}) w{x1-x0+1:4d} h{y1-y0+1:4d}')
