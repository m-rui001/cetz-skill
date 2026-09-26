"""Generic straight-line-art decomposer: robust shaft fit + residual blobs.

usage: python e33b.py <src.png> <comp_id> [comp_id ...]
"""
import sys
import numpy as np
from scipy import ndimage
import tr


def raster(P, shape, w=1):
    m = np.zeros(shape, bool)
    for p in P:
        x, y = int(round(p[0])), int(round(p[1]))
        m[max(0, y - w):y + w + 1, max(0, x - w):x + w + 1] = True
    return m


def fit(G, iters=4, thr=2.5):
    """robust line fit; returns (p0, u, tmin, tmax, inlier_mask_of_points)"""
    ys, xs = np.nonzero(G)
    P = np.c_[xs, ys].astype(float)
    keep = np.ones(len(P), bool)
    for _ in range(iters):
        Q = P[keep]
        c = Q.mean(0)
        q = Q - c
        _, _, vt = np.linalg.svd(q, full_matrices=False)
        u = vt[0]
        t = (P - c) @ u
        d = np.abs((P - c) @ np.array([-u[1], u[0]]))
        keep = d < thr
    Q = P[keep]
    c = Q.mean(0)
    t = (P - c) @ u
    tq = t[keep]
    return c, u, tq.min(), tq.max(), keep, P, t, d


def blobs_of(R, minpx=15):
    lab, n = ndimage.label(R, structure=np.ones((3, 3)))
    out = []
    for i in range(1, n + 1):
        m = lab == i
        px = int(m.sum())
        if px < minpx:
            continue
        ys, xs = np.nonzero(m)
        P = np.c_[xs, ys].astype(float)
        c = P.mean(0)
        q = P - c
        _, s, vt = np.linalg.svd(q, full_matrices=False)
        u = vt[0]
        t = q @ u
        a, b = P[np.argmin(t)], P[np.argmax(t)]
        w = np.abs(q @ vt[1]).max()
        box_fill = px / max(1.0, (xs.max() - xs.min() + 1) * (ys.max() - ys.min() + 1))
        out.append((px, tuple(np.round(c, 1)), tuple(np.round(a, 1)), tuple(np.round(b, 1)),
                    round(float(np.hypot(*(b - a))), 1), round(float(w), 1), round(float(box_fill), 2)))
    return out


if __name__ == '__main__':
    src = sys.argv[1]
    tr.load(src)
    lab, n = ndimage.label(tr.M, structure=np.ones((3, 3)))
    for v in sys.argv[2:]:
        ids = [int(x) for x in v.split(',')]
        G = np.isin(lab, ids)
        c, u, t0, t1, keep, P, t, d = fit(G)
        ang = np.rad2deg(np.arctan2(-u[1], u[0]))
        print(f'--- comps {v}: shaft p0=({c[0]:.1f},{c[1]:.1f}) u=({u[0]:.4f},{u[1]:.4f}) '
              f'ang={ang:.2f} end0=({c[0]+u[0]*t0:.1f},{c[1]+u[1]*t0:.1f}) '
              f'end1=({c[0]+u[0]*t1:.1f},{c[1]+u[1]*t1:.1f}) inl={int(keep.sum())}/{len(P)}')
        band = raster(P[keep], G.shape, w=0)
        band = ndimage.binary_dilation(band, np.ones((9, 9)))
        R = G & ~band
        print('    residual blobs (px, ctr, endA, endB, len, halfwidth, boxfill):')
        for b in sorted(blobs_of(R), key=lambda z: -z[0]):
            print('   ', b)
