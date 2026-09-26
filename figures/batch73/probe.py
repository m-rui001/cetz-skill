import zipfile, io, os, re, sys
import numpy as np
from PIL import Image

BASE = 'E:/EPUB/work/reocr_stage'
keys = sys.argv[1:]
for book in sorted(os.listdir(BASE)):
    if not any(k.lower() in book.lower() for k in keys):
        continue
    rend = os.path.join(BASE, book, 'render')
    if not os.path.isdir(rend):
        print(book, '-> no render dir', os.listdir(os.path.join(BASE, book))[:6])
        continue
    ep = next((f for f in os.listdir(rend) if f.endswith('.epub')), None)
    if ep is None:
        print(book, '-> no epub', os.listdir(rend)[:6])
        continue
    z = zipfile.ZipFile(os.path.join(rend, ep))
    names = sorted(n for n in z.namelist() if re.search(r'\.(png|jpe?g)$', n, re.I))
    print('==', book, '| images:', len(names))
    rows = []
    for i, n in enumerate(names):
        try:
            im = Image.open(io.BytesIO(z.read(n))).convert('L')
        except Exception as e:
            rows.append((i, 'ERR', str(e)[:40]))
            continue
        a = np.asarray(im)
        if a.size == 0:
            continue
        ink = float((a < 160).mean())
        ys, xs = np.nonzero(a < 160)
        bw = xs.max() - xs.min() + 1 if len(xs) else 0
        bh = ys.max() - ys.min() + 1 if len(ys) else 0
        rows.append((i, im.size, round(ink, 4), (bw, bh), os.path.basename(n)))
    for r in rows:
        print('  ', r)
