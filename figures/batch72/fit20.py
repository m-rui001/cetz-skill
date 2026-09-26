"""dt20: robust conic (ellipse) fits from radial shell sampling."""
import json
import numpy as np
import tr

m = tr.load('src/dt20-rings-raw.png')
lab, n = __import__('scipy.ndimage', fromlist=['ndimage']).label(m, np.ones((3, 3)))
G = (lab == 1)          # everything drawn: 3 nested ellipses + tilted arc + arrowheads
tr.mask_of(G)
H, W = G.shape


def fit_ellipse(P):
    """Fitzgibbon direct least-squares conic fit (no recentering). P: (N,2)."""
    x = P[:, 0]
    y = P[:, 1]
    D = np.c_[x * x, x * y, y * y, x, y, np.ones_like(x)]
    S = D.T @ D
    B = np.zeros((6, 6))
    B[0, 2] = B[2, 0] = 2.0
    B[1, 1] = -1.0
    ev = np.linalg.solve(S + 1e-9*np.eye(6), B)
    vals, vecs = np.linalg.eig(ev)
    ok = []
    for i in range(6):
        v = vecs[:, i]
        if abs(vals[i]) < 1e-12 or not np.isfinite(vals[i]).all():
            continue
        lam = 1.0 / vals[i]
        q = 4 * v[0] * v[2] - v[1] ** 2
        if q > 0 and lam > 0:
            ok.append((lam, v))
    if not ok:
        return None
    v = min(ok, key=lambda t: t[0])[1]
    a, b, c, d, f, g = v
    mx, my = P[:, 0].mean(), P[:, 1].mean()
    x0 = (2 * c * d - b * f) / (b * b - 4 * a * c)
    y0 = (2 * a * f - b * d) / (b * b - 4 * a * c)
    cx, cy = x0 + mx, y0 + my
    up = 2 * (a * c * g - f * f * c / 4.0 - d * d * c / 4.0)
    return dict(coef=[a, b, c, d, f, g], center=[cx, cy])


def params(a, b, c, d, f, g):
    x0 = (2 * c * d - b * f) / (b * b - 4 * a * c)
    y0 = (2 * a * f - b * d) / (b * b - 4 * a * c)
    A, B, C = a, b / 2.0, c
    F = g - (A * x0 * x0 + 2 * B * x0 * y0 + C * y0 * y0)
    w, V = np.linalg.eigh(np.array([[A, B], [B, C]]))
    sa = np.sqrt(abs(F / w))                      # semi-axis along V[:,i]
    i_maj = int(np.argmax(sa))
    ang = np.rad2deg(np.arctan2(V[1, i_maj], V[0, i_maj]))
    other = 1 - i_maj
    return dict(cx=x0, cy=y0, rx=sa[i_maj], ry=sa[other], angle=ang)


def conic_eval(a, b, c, d, f, g, ox, oy, P):
    x = P[:, 0] - ox
    y = P[:, 1] - oy
    return a * x * x + b * x * y + c * y * y + d * x + f * y + g


def ray_clusters(O, rmax=320.0):
    """For each angle, list of (mean_r, npts) ink clusters along the ray."""
    out = {}
    ths = np.arange(0, 360, 0.5)
    rs = np.arange(2.0, rmax, 0.5)
    for t in ths:
        u = np.array([np.cos(np.deg2rad(t)), np.sin(np.deg2rad(t))])
        pts = O[None, :] + rs[:, None] * u[None, :]
        xi = np.clip(np.round(pts[:, 0]).astype(int), 0, W - 1)
        yi = np.clip(np.round(pts[:, 1]).astype(int), 0, H - 1)
        hit = G[yi, xi]
        cl = []
        i = 0
        while i < len(hit):
            if hit[i]:
                j = i
                while j + 1 < len(hit) and hit[j + 1]:
                    j += 1
                cl.append((rs[i:j + 1].mean(), j - i + 1))
                i = j + 1
            else:
                i += 1
        out[float(t)] = cl
    return out


def gdist(a, b, c, d, f, g, P):
    x = P[:, 0]
    y = P[:, 1]
    F = a * x * x + b * x * y + c * y * y + d * x + f * y + g
    gx = 2 * a * x + b * y + d
    gy = b * x + 2 * c * y + f
    return np.abs(F) / np.maximum(np.hypot(gx, gy), 1e-9)


def robust_fit(P, thresh=2.5, iters=6):
    keep = np.ones(len(P), bool)
    fit = None
    for _ in range(iters):
        fit = fit_ellipse(P[keep])
        if fit is None:
            return None, keep
        a, b, c, d, f, g = fit['coef']
        r = gdist(a, b, c, d, f, g, P)
        nk = r < thresh
        if nk.sum() < 20:
            nk = r < np.sort(r)[max(20, len(r) // 4)]
        if (nk == keep).all():
            keep = nk
            break
        keep = nk
    return fit_ellipse(P[keep]), keep


def sample_ell(pr, n=2000):
    t = np.linspace(0, 2 * np.pi, n, endpoint=False)
    a = np.deg2rad(pr['angle'])
    x = pr['rx'] * np.cos(t)
    y = pr['ry'] * np.sin(t)
    return np.c_[pr['cx'] + x * np.cos(a) - y * np.sin(a),
                 pr['cy'] + x * np.sin(a) + y * np.cos(a)]


def wipe(mask, pr, r=6):
    from scipy import ndimage
    P = sample_ell(pr).astype(int)
    band = np.zeros_like(mask)
    xs = np.clip(P[:, 0], 0, W - 1)
    ys = np.clip(P[:, 1], 0, H - 1)
    band[ys, xs] = True
    return mask & ~ndimage.binary_dilation(band, np.ones((2 * r + 1, 2 * r + 1)))


if __name__ == '__main__':
    O = np.array([214.8, 145.4])
    clouds = [[], [], []]
    for t in np.arange(0, 360, 0.5):
        u = np.array([np.cos(np.deg2rad(t)), np.sin(np.deg2rad(t))])
        rs = np.arange(2.0, 320.0, 0.5)
        pp = O[None, :] + rs[:, None] * u[None, :]
        xi = np.clip(np.round(pp[:, 0]).astype(int), 0, W - 1)
        yi = np.clip(np.round(pp[:, 1]).astype(int), 0, H - 1)
        hit = G[yi, xi]
        loc = []
        i = 0
        while i < len(hit):
            if hit[i]:
                j = i
                while j + 1 < len(hit) and hit[j + 1]:
                    j += 1
                loc.append(rs[i:j + 1].mean())
                i = j + 1
            else:
                i += 1
        if len(loc) == 3:
            for k in range(3):
                clouds[k].append(O + loc[k] * u)
    out = {}
    work = G.copy()
    for k, name in enumerate(['inner', 'middle', 'outer']):
        P = np.array(clouds[k])
        fit, keep = robust_fit(P)
        pr = params(*fit['coef'])
        pr['npts'] = int(keep.sum()); pr['nall'] = int(len(P))
        while pr['angle'] > 90: pr['angle'] -= 180
        out[name] = pr
        print(name, {kk: (round(vv, 2) if isinstance(vv, float) else vv) for kk, vv in pr.items()})
        work = wipe(work, pr)
    np.save('work_left.npy', work)
    json.dump(out, open('fit20.json', 'w'), indent=1)
    tr.mask_of(work)
    print('leftover px', int(work.sum()))
    for c in tr.comps(8):
        print('  comp', c[1], 'x', c[2], c[3], 'y', c[4], c[5])
