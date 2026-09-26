import sys, numpy as np
from PIL import Image
N = sys.argv[1]
for tag, f in (('src', 'src/%s-raw.png' % N), ('ren', 'png/%s.png' % N)):
    a = np.array(Image.open(f).convert('L')).astype(int) < 160
    ys, xs = np.nonzero(a)
    print(tag, 'img', a.shape, 'ink box x', xs.min(), xs.max(), 'y', ys.min(), ys.max(), 'w', xs.max()-xs.min()+1, 'h', ys.max()-ys.min()+1)
    # right text block
    sel = xs > (xs.min() + 0.72*(xs.max()-xs.min()))
    print('   right72:', xs[sel].min(), xs[sel].max(), ys[sel].min(), ys[sel].max(), 'n', sel.sum())
