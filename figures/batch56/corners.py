import sys
import numpy as np
from PIL import Image
from scipy import ndimage
name = sys.argv[1]; dil = int(sys.argv[2]); ids = [int(i) for i in sys.argv[3].split(',')]
a = np.array(Image.open("src/%s-raw.png" % name).convert("L")).astype(int)
white = a >= 200
lab, nl = ndimage.label(white, structure=np.array([[0,1,0],[1,1,1],[0,1,0]]))
dirs = [('x-',-1,0),('x+',1,0),('y-',0,-1),('y+',0,1),('d-',1,1),('d+',-1,-1),('a-',1,-1),('a+',-1,1)]
for i in ids:
    m = lab == i
    ys, xs = np.nonzero(m)
    pts = []
    for nm, dx, dy in dirs:
        v = xs * dx + ys * dy
        k = int(v.argmax())
        pts.append('%s(%d,%d)' % (nm, xs[k], ys[k]))
    print('r%d area %d' % (i, m.sum()), ' '.join(pts))
