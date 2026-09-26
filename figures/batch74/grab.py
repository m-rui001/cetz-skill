import zipfile, io, os, re, sys
import numpy as np
from PIL import Image

BASE = 'E:/EPUB/work/reocr_stage'
book = next(n for n in os.listdir(BASE) if 'Itskov' in n)
z = zipfile.ZipFile(os.path.join(BASE, book, 'render', book + '.epub'))
names = sorted(n for n in z.namelist() if re.search(r'\.(png|jpe?g)$', n, re.I))

os.makedirs('src', exist_ok=True)
os.makedirs('thumb', exist_ok=True)


def pull(idx, maxw=560):
    im = Image.open(io.BytesIO(z.read(names[idx]))).convert('L')
    a = np.asarray(im)
    ys, xs = np.nonzero(a < 160)
    x0, x1, y0, y1 = xs.min(), xs.max(), ys.min(), ys.max()
    p = 4
    x0 = max(0, x0 - p); y0 = max(0, y0 - p)
    x1 = min(a.shape[1] - 1, x1 + p); y1 = min(a.shape[0] - 1, y1 + p)
    im2 = im.crop((x0, y0, x1 + 1, y1 + 1))
    w, h = im2.size
    if w > maxw:
        s = maxw / w
        im2 = im2.resize((maxw, max(1, int(round(h * s)))), Image.LANCZOS)
    out = f'src/it{idx}-raw.png'
    im2.save(out)
    b = np.asarray(im2)
    print(idx, (w, h), '->', im2.size, 'ink', round(float((b < 160).mean()), 4))
    return im2


if sys.argv[1:]:
    for v in sys.argv[1:]:
        idx, _, mw = v.partition('@')
        pull(int(idx), int(mw) if mw else 560)
else:
    sheets = []
    cur, row = [], []
    for i in range(len(names)):
        im = pull(i)
        im.save(f'thumb/it{i}.png')
