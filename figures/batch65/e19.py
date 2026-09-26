import numpy as np
from PIL import Image

im = np.array(Image.open('src/dt19-raw.png').convert('L'))
g = im < 160


def runs(v, off=0):
    out, i = [], 0
    while i < len(v):
        if v[i]:
            j = i
            while j + 1 < len(v) and v[j + 1]:
                j += 1
            out.append((off + i, off + j, j - i + 1))
            i = j + 1
        else:
            i += 1
    return out


# ---- S-curve: chain by column, continuity pick
X0, X1, Y0, Y1 = 67, 896, 18, 264
pts = []
prev = None
for x in range(X0, X1):
    rr = [r for r in runs(g[Y0:Y1, x], Y0) if r[2] <= 14]
    if not rr:
        pts.append((x, None))
        continue
    if prev is None:
        c = min(rr, key=lambda r: abs((r[0] + r[1]) / 2 - 205))
    else:
        pr = pts[-1][1]
        if pr is None:
            pr = pts[-2][1]
        c = min(rr, key=lambda r: abs((r[0] + r[1]) / 2 - pr))
        if abs((c[0] + c[1]) / 2 - pr) > 12:
            pts.append((x, None))
            continue
    prev = c
    pts.append((x, (c[0] + c[1]) / 2))

good = [(x, y) for x, y in pts if y is not None]
print('curve cols', len(pts), 'ok', len(good))
miss = [x for x, y in pts if y is None]
print('missing x', miss[:5], '...', miss[-5:] if miss else '', len(miss))
# print every 25th
for i in range(0, len(good), 25):
    print('  ', good[i])
print('  last', good[-1])

# ---- braces: chain by row
def brace(xlo, xhi, ylo, yhi):
    out = []
    for y in range(ylo, yhi + 1):
        rr = runs(g[y, xlo:xhi], xlo)
        if len(rr) == 1:
            out.append(((rr[0][0] + rr[0][1]) / 2, y))
        elif rr:
            out.append(((rr[0][0] + rr[-1][1]) / 2, y))
    return out


R = brace(905, 930, 8, 138)
L = brace(36, 58, 136, 268)
print('Rbrace n', len(R))
for i in range(0, len(R), 6):
    print('  ', R[i])
print('  ', R[-1])
print('Lbrace n', len(L))
for i in range(0, len(L), 6):
    print('  ', L[i])
print('  ', L[-1])
