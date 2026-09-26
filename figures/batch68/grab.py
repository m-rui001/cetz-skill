import zipfile, io, os, re, sys
import numpy as np
from PIL import Image

BASE = 'E:/EPUB/work/reocr_stage'
book = next(n for n in os.listdir(BASE) if 'Guillemin' in n)
z = zipfile.ZipFile(os.path.join(BASE, book, 'render', book + '.epub'))
names = sorted(n for n in z.namelist() if re.search(r'\.(png|jpe?g)$', n, re.I))
for idx in [int(v) for v in sys.argv[1:]]:
    n = names[idx]
    im = Image.open(io.BytesIO(z.read(n))).convert('L')
    out = f'src/dt{idx}-raw.png'
    im.save(out)
    a = np.asarray(im)
    ys, xs = np.nonzero(a < 160)
    print(idx, im.size, 'ink', round(float((a < 160).mean()), 4), 'bbox',
          xs.min(), xs.max(), ys.min(), ys.max(), '->', out)
