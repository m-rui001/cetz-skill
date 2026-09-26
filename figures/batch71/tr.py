"""Reusable ink extraction: turtle tracer with heading inertia + run helpers."""
import numpy as np
from scipy import ndimage
from PIL import Image

M = None
H = W = 0

def load(path):
    global M, H, W
    M = np.load(path) if path.endswith('.npy') else (np.array(Image.open(path).convert('L')).astype(int) < 160)
    H, W = M.shape
    return M

def mask_of(img):
    global M, H, W
    M = img
    H, W = M.shape
    return M

def runs(v):
    out, i = [], 0
    while i < len(v):
        if v[i]:
            j = i
            while j + 1 < len(v) and v[j + 1]:
                j += 1
            out.append((i, j)); i = j + 1
        else:
            i += 1
    return out

def col(x):
    return [((a + b) / 2.0, float(x)) for a, b in runs(M[:, x])]

def row(y):
    return [(float(a), (y + b) * 0 + y) for a, b in []]

def trace(start, heading, nsteps=6000, R=7.0, halfwin=55.0, hsm=0.55):
    cur = np.array(start, float)
    hd = np.deg2rad(heading)
    pts = [tuple(cur)]
    angs = np.arange(-halfwin, halfwin + .001, 0.5)
    for k in range(nsteps):
        good = []
        for a in angs:
            th = hd + np.deg2rad(a)
            p = cur + R * np.array([np.cos(th), np.sin(th)])
            xi, yi = int(round(p[0])), int(round(p[1]))
            if 0 <= xi < W and 0 <= yi < H and M[yi, xi]:
                good.append(a)
        if not good:
            return pts, 'OPEN'
        iv = [[good[0]]]
        for a in good[1:]:
            if a - iv[-1][-1] <= 1.0:
                iv[-1].append(a)
            else:
                iv.append([a])
        nm = np.mean(min(iv, key=lambda g: abs(np.mean(g))))
        th = hd + np.deg2rad(nm)
        cur = cur + R * np.array([np.cos(th), np.sin(th)])
        hd = (1 - hsm) * hd + hsm * th
        pts.append(tuple(cur))
        if k > 20 and np.hypot(*(cur - np.array(pts[0]))) < R * 0.9:
            return pts, 'CLOSED'
    return pts, 'MAXSTEP'

def comps(minpx=20, structure=np.ones((3, 3))):
    lab, n = ndimage.label(M, structure=structure)
    out = []
    for i in range(1, n + 1):
        yy, xx = np.nonzero(lab == i)
        if len(yy) >= minpx:
            out.append((i, len(yy), int(xx.min()), int(xx.max()), int(yy.min()), int(yy.max()), lab))
    return out

def blobs(ksize=7, minpx=3):
    lab, n = ndimage.label(ndimage.binary_erosion(M, np.ones((ksize, ksize))), np.ones((3, 3)))
    out = []
    for i in range(1, n + 1):
        yy, xx = np.nonzero(lab == i)
        if len(yy) >= minpx:
            out.append((float(xx.mean()), float(yy.mean()), len(yy),
                        int(xx.min()), int(xx.max()), int(yy.min()), int(yy.max())))
    return out

def sub(mask):
    global M, H, W
    M = mask
    H, W = M.shape
    return M

def arrow(mask, head_r=24.0):
    """Straight-shaft arrow with a V head -> (tail, tip, b1, b2) in pixel coords."""
    from scipy import ndimage
    ys, xs = np.nonzero(mask)
    P = np.c_[xs, ys].astype(float)
    den = ndimage.gaussian_filter(mask.astype(float), 4.0)
    hy, hx = np.unravel_index(int(np.argmax(den)), mask.shape)
    head = np.array([hx, hy], float)
    d = np.hypot(P[:, 0] - head[0], P[:, 1] - head[1])
    sh = P[d > head_r]
    if len(sh) < 10: return None
    tail = sh[np.argmax(np.hypot(sh[:, 0] - head[0], sh[:, 1] - head[1]))]
    u = (head - tail) / np.hypot(*(head - tail))
    n = np.array([-u[1], u[0]])
    hb = P[d <= head_r]
    al = (hb - tail) @ u
    pr = (hb - tail) @ n
    tip = hb[np.argmax(al)]
    b1 = hb[np.argmax(pr)]
    b2 = hb[np.argmin(pr)]
    return tuple(tail), tuple(tip), tuple(b1), tuple(b2)
