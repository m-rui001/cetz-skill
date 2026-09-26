import numpy as np
from PIL import Image

g = np.array(Image.open('src/dt6-raw.png').convert('L')) < 160

def runs(a, off=0):
    out, i = [], 0
    while i < len(a):
        if a[i]:
            j = i
            while j < len(a) and a[j]:
                j += 1
            out.append((i + off, j - 1 + off))
            i = j
        else:
            i += 1
    return out

# fitted line: (5,257.5) -> (697,252.5)
def ly(x):
    return 257.5 + (252.5 - 257.5) * (x - 5) / 692.0

pts = []
for x in range(24, 648):
    rr = runs(g[:, x])
    cand = [t for t in rr if abs((t[0] + t[1]) / 2 - ly(x)) > 6]
    if len(cand) == 1:
        a, b = cand[0]
        if b - a <= 14:
            pts.append((x, (a + b) / 2.0))
print('n pts', len(pts), 'gap cols', 647 - 24 + 1 - len(pts))
P = np.array(pts)
c = np.polyfit(P[:, 0], P[:, 1], 2)
res = P[:, 1] - np.polyval(c, P[:, 0])
print('coef', c, 'max res', np.abs(res).max(), 'rms', np.sqrt((res**2).mean()))
# where is fit vs line
print('fit bottom', -c[1] / (2 * c[0]), np.polyval(c, -c[1] / (2 * c[0])))
np.save('par6.npy', P)
