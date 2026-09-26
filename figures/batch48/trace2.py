import sys
from PIL import Image
import numpy as np
from scipy import ndimage

d, name = sys.argv[1], sys.argv[2]
dil = int(sys.argv[3]) if len(sys.argv) > 3 else 3
eps = float(sys.argv[4]) if len(sys.argv) > 4 else 4.0
a = np.asarray(Image.open('src/%s-raw.png' % name).convert('L'))
white = a >= 200
lab, n = ndimage.label(white, structure=np.array([[0, 1, 0], [1, 1, 1], [0, 1, 0]]))
sizes = ndimage.sum(white, lab, index=np.arange(1, n + 1))
print('# regions', n, 'sizes', sorted([int(s) for s in sizes], reverse=True)[:8])


def cycles(mask):
    m = np.pad(mask, 1)
    H, W = m.shape
    e = {}
    for y in range(H):
        for x in range(W):
            if not m[y, x]:
                continue
            if x + 1 < W and not m[y, x + 1]:
                e.setdefault((x, y), []).append((x + 1, y))
                e.setdefault((x + 1, y), []).append((x, y))
            if y + 1 < H and not m[y + 1, x]:
                e.setdefault((x, y), []).append((x, y + 1))
                e.setdefault((x, y + 1), []).append((x, y))
    out = []
    for v in list(e):
        while e.get(v):
            w = e[v].pop()
            if v in e.get(w, []):
                e[w].remove(v)
            cyc = [v, w]
            while w != v:
                cands = [q for q in e.get(w, []) if q != cyc[-2]]
                if not cands:
                    cands = e.get(w, [])
                if not cands:
                    break
                u = cands[0]
                if w in e.get(u, []):
                    e[u].remove(w)
                cyc.append(u)
                w = u
            if len(cyc) > 10:
                out.append(cyc[:-1])
    return out


def dp(pts, eps):
    if len(pts) < 3:
        return pts
    P = np.array(pts, float)
    keep = np.zeros(len(P), bool)
    keep[0] = keep[-1] = True
    stack = [(0, len(P) - 1)]
    while stack:
        i, j = stack.pop()
        if j <= i + 1:
            continue
        ab = P[j] - P[i]
        L = np.hypot(*ab)
        seg = P[i:j + 1]
        dev = np.abs(np.cross(ab, seg - P[i])) / L if L > 0 else np.hypot(*(seg - P[i]).T)
        k = int(np.argmax(dev[1:-1])) + i + 1
        if dev[k - i] > eps:
            keep[k] = True
            stack.append((i, k))
            stack.append((k, j))
    return [p for p, k in zip(pts, keep) if k]


for i in range(1, n + 1):
    m = lab == i
    if m.sum() < 400:
        continue
    ys, xs = np.where(m)
    md = ndimage.binary_dilation(m, structure=np.ones((3, 3), bool), iterations=dil)
    for c in cycles(md):
        s = dp(c, eps)
        if len(s) < 4:
            continue
        print('### r%d n%d bbox %d..%d %d..%d' % (i, len(s), xs.min(), xs.max(), ys.min(), ys.max()))
        print('(' + ','.join('(%d,%d)' % (round(x - 1), round(y - 1)) for x, y in s) + ')')
