import numpy as np
from scipy import ndimage
import tr

tr.load('src/it33-raw.png')
M = tr.M
lab, n = ndimage.label(M, structure=np.ones((3, 3)))


def sub(ids):
    return np.isin(lab, list(ids))


def endpoints(P, p):
    """extreme pair along PCA main axis"""
    q = P - P.mean(0)
    _, _, vt = np.linalg.svd(q, full_matrices=False)
    u = vt[0]
    t = q @ u
    return P[np.argmin(t)], P[np.argmax(t)]


def shafts(G, O, rmin=25.0, bin=0.5):
    ys, xs = np.nonzero(G)
    P = np.c_[xs, ys].astype(float)
    v = P - O
    r = np.hypot(v[:, 0], v[:, 1])
    a = np.rad2deg(np.arctan2(-(v[:, 1] - 0), v[:, 0]))  # y up positive
    sel = r > rmin
    idx = np.floor(a[sel] / bin).astype(int)
    order = np.argsort(idx)
    out = []
    for b in np.unique(idx):
        m = sel.copy()
        m[sel] = (idx == b)
        ang = b * bin
        rr = r[m]
        if len(rr) < 40:
            continue
        # pixels at this angle: shaft length = max radius
        out.append((ang, len(rr), rr.max()))
    return out


def report(name, G):
    print('=====', name)
    ys, xs = np.nonzero(G)
    O = np.array([xs.min(), ys[xs == xs.min()].mean()])
    print('leftmost', O)
    for ang, cnt, rmax in shafts(G, O):
        print(f'  shaft ang {ang:7.2f} deg  npix {cnt:5d}  rmax {rmax:7.1f}')


G11 = sub([11])
report('c11 parallelogram', G11)

# residual after removing shaft bands: barbs + wedge
for ang in (52.0, 52.5, 53.0):
    pass
