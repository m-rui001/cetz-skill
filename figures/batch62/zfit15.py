import numpy as np, json
from PIL import Image
from scipy import ndimage

a = np.array(Image.open('src/dt15-raw.png').convert('L')) < 160
a[:, 480:] = False
lab, n = ndimage.label(a, structure=np.ones((3, 3)))
a = lab == 1
pts = np.stack([*np.nonzero(a)[::-1]], 1).astype(float)
S = json.load(open('segs15.json'))
inner = np.array(S['inner']); hole = np.array(S['hole'])

keep = []
for p in pts:
    if not (243 < p[0] < 318 and 12 < p[1] < 128): continue
    if np.hypot(*(p - inner).T).min() < 9: continue
    if np.hypot(*(p - hole).T).min() < 9: continue
    keep.append(p)
keep = np.array(keep)


def fit(Q):
    X, Y = Q[:, 0], Q[:, 1]
    D = np.stack([X * X, Y * Y, X, Y, np.ones_like(X)], 1)
    _, _, vt = np.linalg.svd(D, full_matrices=False)
    A, B, C, Dd, E = vt[-1]
    if A * B <= 0: return None
    cx, cy = -C / (2 * A), -Dd / (2 * B)
    F = E - C * C / (4 * A) - Dd * Dd / (4 * B)
    if -F / A <= 0 or -F / B <= 0: return None
    return np.array([cx, cy]), np.sqrt(-F / A), np.sqrt(-F / B)


best = None
for phi in np.arange(0, 180, 0.5):
    tp = np.deg2rad(phi)
    R = np.array([[np.cos(tp), np.sin(tp)], [-np.sin(tp), np.cos(tp)]])
    Q = keep @ R.T
    x0, x1 = Q[:, 0].min(), Q[:, 0].max()
    y0, y1 = Q[:, 1].min(), Q[:, 1].max()
    c = np.array([(x0 + x1) / 2, (y0 + y1) / 2]); ra = (x1 - x0) / 2; rb = (y1 - y0) / 2
    if ra < 5 or rb < 5: continue
    ang = np.arctan2(Q[:, 1] - c[1], Q[:, 0] - c[0])
    rp = 1 / np.sqrt((np.cos(ang) / ra) ** 2 + (np.sin(ang) / rb) ** 2)
    res = np.abs(np.hypot(Q[:, 0] - c[0], Q[:, 1] - c[1]) - rp).mean()
    if best is None or res < best[0]:
        best = (res, phi, c @ R, ra, rb, tp)

res, phi, cen, ra, rb, tp = best
print('Z tilt %.1f radii %.1f %.1f rms %.2f' % (phi, ra, rb, res))
R = np.array([[np.cos(tp), np.sin(tp)], [-np.sin(tp), np.cos(tp)]])
t = np.linspace(0, 2 * np.pi, 72, endpoint=False)
zz = np.stack([ra * np.cos(t), rb * np.sin(t)], 1) @ np.linalg.inv(R) + cen
S['zz'] = [[round(float(p[0]), 1), round(float(p[1]), 1)] for p in zz]
json.dump(S, open('segs15.json', 'w'))
print('sample', np.round(zz[0], 1), np.round(zz[18], 1))
