import numpy as np
from scipy import ndimage
from PIL import Image
im0 = Image.open('src/dt21-raw.png')
print('size', im0.size, 'mode', im0.mode)
g = np.array(im0.convert('L'))
print('shape', g.shape)
m = g < 160
print('ink', m.sum())
ys, xs = np.nonzero(m)
print('box', xs.min(), xs.max(), ys.min(), ys.max())
lab, n = ndimage.label(m, structure=np.ones((3,3)))
print('ncomp', n)
for i in range(1, n+1):
    yy, xx = np.nonzero(lab == i)
    if len(yy) < 20: continue
    print(i, len(yy), xx.min(), xx.max(), yy.min(), yy.max())
# dots: locally thick blobs -> erosion
er = ndimage.binary_erosion(m, np.ones((5,5)))
lab2, n2 = ndimage.label(er, structure=np.ones((3,3)))
print('eroded comps', n2)
for i in range(1, n2+1):
    yy, xx = np.nonzero(lab2 == i)
    if len(yy) < 4: continue
    print('blob', i, len(yy), round(xx.mean(),1), round(yy.mean(),1), xx.min(), xx.max(), yy.min(), yy.max())
np.save('m21.npy', m)
