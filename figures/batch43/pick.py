import zipfile, io, os, re, sys
from PIL import Image

BASE = 'E:/EPUB/work/reocr_stage'
book = next(n for n in os.listdir(BASE) if 'Differential' in n)
p = os.path.join(BASE, book, 'render', book + '.epub')
z = zipfile.ZipFile(p)
names = sorted(n for n in z.namelist() if re.search(r'\.(png|jpe?g)$', n, re.I))
hits = []
for i, n in enumerate(names):
    try:
        im = Image.open(io.BytesIO(z.read(n)))
    except Exception:
        continue
    w, h = im.size
    if not (500 <= w <= 1400 and 330 <= h <= 900):
        continue
    g = im.convert('L')
    a = __import__('numpy').asarray(g)
    ink = (a < 160).mean()
    if 0.004 <= ink <= 0.16:
        hits.append((i, n, w, h, round(ink, 4)))
done = {47, 50, 69, 72, 80}
for i, n, w, h, ink in hits:
    flag = 'USED' if i in done else '    '
    print(flag, i, w, h, ink, os.path.basename(n))
