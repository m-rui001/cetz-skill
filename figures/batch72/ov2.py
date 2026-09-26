"""Overlay a CeTZ render on its source scan (red = source, green = render).

Aligns by uniform scale + translation search, which is more robust than
matching whole-image bounding boxes when the scan is cropped.
usage: python ov.py <dir> <name>
"""
import sys
import numpy as np
from PIL import Image
from scipy import ndimage

d, n = sys.argv[1], sys.argv[2]


def inkm(p):
    a = np.array(Image.open(p).convert("L")).astype(int)
    return a < 160


def bbox(g):
    ys, xs = np.nonzero(g)
    return int(xs.min()), int(xs.max()), int(ys.min()), int(ys.max())


s = inkm(f"{d}/src/{n}-raw.png")
r = inkm(f"{d}/png/{n}.png")
bs, br = bbox(s), bbox(r)
sw, sh = bs[1] - bs[0] + 1, bs[3] - bs[2] + 1
rw, rh = br[1] - br[0] + 1, br[3] - br[2] + 1
sc = sw / rw
rc = np.array(r[br[2]:br[3] + 1, br[0]:br[1] + 1])
big = np.array(Image.fromarray((rc * 255).astype("uint8")).resize(
    (int(rw * sc), int(rh * sc)), Image.LANCZOS)) > 128
dist = ndimage.distance_transform_edt(~s)
rys, rxs = np.nonzero(big)
H, W = s.shape


def score(dx, dy):
    yy = rys + dy
    xx = rxs + dx
    ok = (yy >= 0) & (yy < H) & (xx >= 0) & (xx < W)
    return dist[yy[ok], xx[ok]].mean()


best = None
for dx in range(-80, 81, 8):
    for dy in range(-80, 81, 8):
        v = score(dx, dy)
        if best is None or v < best[0]:
            best = (v, dx, dy)
_, bx, by = best
bv = best[0]
for dx in range(bx - 8, bx + 9):
    for dy in range(by - 8, by + 9):
        v = score(dx, dy)
        if v < bv:
            bx, by, bv = dx, dy, v
best = (bv, bx, by)

cv = np.zeros((H, W), bool)
yy, xx = rys + by, rxs + bx
ok = (yy >= 0) & (yy < H) & (xx >= 0) & (xx < W)
cv[yy[ok], xx[ok]] = True
out = np.full((H, W, 3), 255, dtype="uint8")
out[..., 0] = np.where(s, 0, 255)
out[..., 1] = np.where(cv, 0, 255)
out[..., 2] = np.where(s & cv, 0, 255)
Image.fromarray(out).save(f"{d}/ov_{n}.png")
print(n, "scale", round(sc, 4), "offset", bx, by, "mean dist", round(best[0], 2),
      "ar", round(sw / sh, 3), round(rw / rh, 3))
