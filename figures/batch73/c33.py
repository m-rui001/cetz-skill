import numpy as np
from scipy import ndimage
import tr

tr.load('src/it33-raw.png')
M = tr.M
lab, n = ndimage.label(M, structure=np.ones((3, 3)))
print('components', n, 'shape', M.shape)
objs = ndimage.find_objects(lab)
for i, sl in enumerate(objs, start=1):
    px = int((lab[sl] == i).sum())
    y0, y1 = sl[0].start, sl[0].stop - 1
    x0, x1 = sl[1].start, sl[1].stop - 1
    print(f'c{i:3d} px{px:6d} box({x0},{y0})-({x1},{y1}) w{x1-x0+1:4d} h{y1-y0+1:4d}')
