import os, sys, io
from PIL import Image

os.chdir(sys.argv[1])
for n in sys.argv[2:]:
    a = Image.open("src/%s.png" % n).convert("RGB")
    b = Image.open("png/%s.png" % n).convert("RGB")
    W = 1150
    a2 = a.resize((W, int(a.height * W / a.width)))
    b2 = b.resize((W, int(b.height * W / b.width)))
    c = Image.new("RGB", (W, a2.height + b2.height + 14), "white")
    c.paste(a2, (0, 0))
    c.paste(b2, (0, a2.height + 14))
    c.save("cmp_%s.png" % n)
    print(n, c.size)
