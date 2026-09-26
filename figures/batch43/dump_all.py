import zipfile, io, os, re
from PIL import Image
import numpy as np

BASE = 'E:/EPUB/work/reocr_stage'
book = next(n for n in os.listdir(BASE) if 'Guillemin' in n)
p = os.path.join(BASE, book, 'render', book + '.epub')
z = zipfile.ZipFile(p)
names = sorted(n for n in z.namelist() if re.search(r'\.(png|jpe?g)$', n, re.I))
print('total images', len(names))
hits = []
for i, n in enumerate(names):
    try:
        im = Image.open(io.BytesIO(z.read(n)))
    except Exception:
        continue
    w, h = im.size
    if not (500 <= w <= 1400 and 330 <= h <= 900):
        continue
    a = np.asarray(im.convert('L'))
    ink = (a < 160).mean()
    if 0.004 <= ink <= 0.16:
        hits.append((i, n, im))
print('hits', len(hits))
os.makedirs('cand', exist_ok=True)
for k, (i, n, im) in enumerate(hits):
    im.convert('L').save('cand/c%02d_%d.png' % (k, i))
    print(k, i, im.size, os.path.basename(n))
