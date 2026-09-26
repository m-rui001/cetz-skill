"""dt1 v3: trace shaft through the head, leftover ink = second barb."""
import json
import numpy as np
import tr
from scipy import ndimage

m = tr.load('src/dt1-raw.png')
lab, n = ndimage.label(m, np.ones((3, 3)))
GROUPS = {'a_tl': [3], 'a_tm': [2], 'a_tr': [1], 'a_ml': [7, 4], 'a_mr': [5],
          'a_bl': [10], 'a_bm': [8], 'a_br': [9]}
out = {}
for name, ids in GROUPS.items():
    C = np.isin(lab, ids)
    den = ndimage.gaussian_filter(C.astype(float), 3.0)
    hy, hx = np.unravel_index(int(np.argmax(den)), C.shape)
    head = np.array([hx, hy], float)
    ys, xs = np.nonzero(C)
    P = np.c_[xs, ys].astype(float)
    tail = P[np.argmax(np.hypot(P[:, 0] - head[0], P[:, 1] - head[1]))]
    tr.mask_of(C)
    u0 = head - tail
    pts, tag = tr.trace(tuple(tail), np.rad2deg(np.arctan2(u0[1], u0[0])), nsteps=1500,
                        R=6.0, halfwin=45.0)
    band = np.zeros_like(C)
    Sp = np.array(pts).astype(int)
    band[np.clip(Sp[:, 1], 0, C.shape[0] - 1), np.clip(Sp[:, 0], 0, C.shape[1] - 1)] = True
    band = ndimage.binary_dilation(band, np.ones((9, 9)))
    R = C & ~band
    lr, lk = ndimage.label(R, np.ones((3, 3)))
    barbs = []
    for i in range(1, lk + 1):
        yy, xx = np.nonzero(lr == i)
        if len(xx) < 12:
            continue
        Q = np.c_[xx, yy].astype(float)
        Qc = Q - Q.mean(0)
        w, V = np.linalg.eigh(Qc.T @ Qc)
        u = V[:, -1]
        t = Qc @ u
        e1 = Q[np.argmin(t)]
        e2 = Q[np.argmax(t)]
        barbs.append([list(map(float, e1)), list(map(float, e2)), int(len(xx))])
    out[name] = dict(shaft=[list(map(float, p)) for p in pts], tag=tag, barbs=barbs)
    print(name, tag, 'shaft', len(pts), 'end', np.round(pts[-1], 1).tolist(),
          '| barbs', [(np.round(b[0], 1).tolist(), np.round(b[1], 1).tolist(), b[2]) for b in barbs])

ys, xs = np.nonzero(lab == 6)
out['dot'] = dict(c=[float(xs.mean()), float(ys.mean())], r=float(np.sqrt(len(xs) / np.pi)))
json.dump(out, open('dec1.json', 'w'))
print('dot', np.round(out['dot']['c'], 2).tolist(), round(out['dot']['r'], 2))
