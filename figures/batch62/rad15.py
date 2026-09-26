import numpy as np, json
from PIL import Image
from scipy import ndimage

a = np.array(Image.open('src/dt15-raw.png').convert('L')) < 160
a[:, 480:] = False
lab, n = ndimage.label(a, structure=np.ones((3, 3)))
a = lab == 1
ys, xs = np.nonzero(a)
pts = np.stack([xs, ys], 1).astype(float)

C = np.array([243.0, 177.0])


def crossings(theta, rmin=0., rmax=300.):
    u = np.array([np.cos(theta), np.sin(theta)])
    v = np.array([-u[1], u[0]])
    q = pts - C
    r = q @ u
    p = np.abs(q @ v)
    sel = (p < 3.0) & (r > rmin) & (r < rmax)
    if not sel.any(): return []
    rr = r[sel]; pp = p[sel]; qq = q[sel]
    order = np.argsort(rr)
    rr, qq = rr[order], qq[order]
    groups = [[0]]
    for i in range(1, len(rr)):
        if rr[i] - rr[i - 1] > 4:
            groups.append([])
        groups[-1].append(i)
    out = []
    for g in groups:
        r0 = float(rr[g].mean())
        c = qq[g].mean(0)
        out.append((round(r0, 1), (round(float(c[0] + C[0]), 1), round(float(c[1] + C[1]), 1))))
    return out


for th in np.arange(0, 360, 30):
    print(int(th), crossings(np.deg2rad(th)))
