"""Per-window residual offset between source ink and the globally-aligned render.

usage: python psk.py <name> [halfWindow]
Aligns render to source with the same scale+translation search as ov.py, then
reports, for each contiguous source-x band of ink, the local (dx, dy) that
further reduces mean nearest-source-ink distance.
"""
import sys
import numpy as np
from PIL import Image
from scipy import ndimage

n = sys.argv[1]


def inkm(p):
    a = np.array(Image.open(p).convert("L")).astype(int)
    return a < 160


s = inkm(f"src/{n}-raw.png")
r = inkm(f"png/{n}.png")


def bbox(g):
    ys, xs = np.nonzero(g)
    return int(xs.min()), int(xs.max()), int(ys.min()), int(ys.max())


bs, br = bbox(s), bbox(r)
sw, sh = bs[1] - bs[0] + 1, bs[3] - bs[2] + 1
rw, rh = br[1] - br[0] + 1, br[3] - br[2] + 1
sc = sw / rw
rc = np.array(Image.fromarray((r[br[2]:br[3] + 1, br[0]:br[1] + 1] * 255).astype("uint8")).resize(
    (int(rw * sc), int(rh * sc)), Image.LANCZOS)) > 128
H, W = s.shape
dist = ndimage.distance_transform_edt(~s)
rys, rxs = np.nonzero(rc)


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
print("global", bx, by, round(bv, 3), "scale", round(sc, 4))

prof = rc.sum(axis=0)
bands = []
inb = False
for x in range(len(prof)):
    if prof[x] and not inb:
        inb, x0 = True, x
    elif not prof[x] and inb:
        inb = False
        if x - x0 > 20:
            bands.append((x0, x))
if inb:
    bands.append((x0, len(prof)))

for x0, x1 in bands:
    m = (rxs >= x0) & (rxs < x1)
    px, py = rxs[m], rys[m]

    def sc2(dx, dy):
        yy = np.clip(py + dy + by, 0, H - 1)
        xx = np.clip(px + dx + bx, 0, W - 1)
        return dist[yy, xx].mean()

    b = None
    for dx in range(-14, 15, 2):
        for dy in range(-14, 15, 2):
            v = sc2(dx, dy)
            if b is None or v < b[0]:
                b = (v, dx, dy)
    _, ldx, ldy = b
    b0 = sc2(0, 0)
    v = b[0]
    for dx in range(ldx - 2, ldx + 3):
        for dy in range(ldy - 2, ldy + 3):
            q = sc2(dx, dy)
            if q < v:
                ldx, ldy, v = dx, dy, q
    src = s[:, max(bs[0], x0 + bx):min(W, x1 + bx)]
    ys2, xs2 = np.nonzero(src)
    print(f"band {x0}..{x1} ink {len(px):5d} base {b0:.2f} -> best dx {ldx:+d} dy {ldy:+d} "
          f"mean {v:.2f} | srcCent {xs2.mean()+max(bs[0],x0+bx):.1f},{ys2.mean():.1f}")
