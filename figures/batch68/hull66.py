import numpy as np
from PIL import Image
from scipy import ndimage


def hull(pts):
    pts = sorted(set(map(tuple, pts)))
    if len(pts) < 3:
        return pts
    def cr(o, a, b):
        return (a[0]-o[0])*(b[1]-o[1]) - (a[1]-o[1])*(b[0]-o[0])
    lo = [p for p in pts]
    up = list(reversed(lo))
    lower, upper = [], []
    for p in lo:
        while len(lower) >= 2 and cr(lower[-2], lower[-1], p) <= 0:
            lower.pop()
        lower.append(p)
    for p in up:
        while len(upper) >= 2 and cr(upper[-2], upper[-1], p) <= 0:
            upper.pop()
        upper.append(p)
    return lower[:-1] + upper[:-1]


g = np.array(Image.open('src/dt66-wrap-raw.png').convert('L')) < 160
lab, n = ndimage.label(g, structure=np.ones((3, 3)))


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


# --- wrap arc centreline extended to the tip
m = lab == 6
arc = []
for x in range(410, 605):
    rr = runs(m[:, x])
    if len(rr) == 1 and rr[0][1] - rr[0][0] <= 12:
        arc.append((x, (rr[0][0] + rr[0][1]) / 2))
# extend along the last direction to x=636
(x1, y1), (x2, y2) = arc[-13], arc[-1]
s = (y2 - y1) / (x2 - x1)
arc = arc + [(x, y2 + s * (x - x2)) for x in range(605, 637)]
band = np.zeros(g.shape, bool)
for i in range(len(arc) - 1):
    for t in np.arange(0, 1, 0.05):
        x = arc[i][0] + (arc[i+1][0] - arc[i][0]) * t
        y = arc[i][1] + (arc[i+1][1] - arc[i][1]) * t
        band[int(round(y)), int(round(x))] = True
band = ndimage.binary_dilation(band, np.ones((11, 11)))
res = m & ~band
rl, rn = ndimage.label(res, structure=np.ones((3, 3)))
print('wrap arrow residual comps')
for i in range(1, rn + 1):
    ys, xs = np.nonzero(rl == i)
    if len(ys) < 12:
        continue
    print(' ', i, len(ys), 'x', xs.min(), xs.max(), 'y', ys.min(), ys.max())
    print('   hull', [(round(a, 1), round(b, 1)) for a, b in hull(np.c_[xs, ys])])

# --- figure-eight arrowheads: residual after removing both lobe curves
print()
for name, (cx, cy, ylo, yhi) in [('upper', (847, 58, 0, 116)), ('lower', (847, 165, 112, 216))]:
    pass

print('=== comp6 x>=600 hull')
ys, xs = np.nonzero(m)
sel = xs >= 600
h = hull(np.c_[xs[sel], ys[sel]])
print([(int(a), int(b)) for a, b in h])
print('=== comp1 upper arrow hull (y 82..112, x 855..895)')
mm = (lab == 1)
ys2, xs2 = np.nonzero(mm)
sel2 = (xs2 >= 855) & (xs2 <= 895) & (ys2 >= 82) & (ys2 <= 112)
print([(int(a), int(b)) for a, b in hull(np.c_[xs2[sel2], ys2[sel2]])])
print('=== comp1 lower arrow hull (x 798..842, y 118..145)')
sel3 = (xs2 >= 798) & (xs2 <= 842) & (ys2 >= 118) & (ys2 <= 145)
print([(int(a), int(b)) for a, b in hull(np.c_[xs2[sel3], ys2[sel3]])])
