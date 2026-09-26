import sys, numpy as np
from PIL import Image
from scipy import ndimage

G = np.asarray(Image.open('src/it43-raw.png').convert('L'))
M = G < 160
lab, n = ndimage.label(M, np.ones((3, 3)))
ids = [i for i in range(1, n + 1) if (lab == i).sum() >= 200]
print('geo comps', ids)
for i in ids:
    Cm = (lab == i)
    H, V = [], []
    for y in range(Cm.shape[0]):
        row = np.flatnonzero(Cm[y])
        if len(row) == 0: continue
        st = row[0]; pr = row[0]
        for x in list(row[1:]) + [-99]:
            if x != pr + 1:
                if pr - st >= 12: H.append((y, st, pr))
                st = x
            pr = x
    for x in range(Cm.shape[1]):
        col = np.flatnonzero(Cm[:, x])
        if len(col) == 0: continue
        st = col[0]; pr = col[0]
        for y in list(col[1:]) + [-99]:
            if y != pr + 1:
                if pr - st >= 12: V.append((x, st, pr))
                st = y
            pr = y
    def merge(S, fixed_is_y):
        out = []
        for s in S:
            a, b, c = s
            hit = None
            for o in out:
                if fixed_is_y:
                    if abs(o[0] - a) <= 1 and not (c < o[1] - 3 or b > o[2] + 3): hit = o
                else:
                    if abs(o[0] - a) <= 1 and not (c < o[1] - 3 or b > o[2] + 3): hit = o
            if hit:
                hit[0] = round((hit[0] * 1 + a) / 2); hit[1] = min(hit[1], b); hit[2] = max(hit[2], c)
            else:
                out.append([a, b, c])
        return out
    Hm, Vm = merge(H, True), merge(V, False)
    print('== comp', i, 'H', len(Hm), 'V', len(Vm))
    for s in sorted(Hm): print('  H y=%d x=%d..%d len=%d' % (s[0], s[1], s[2], s[2] - s[1]))
    for s in sorted(Vm): print('  V x=%d y=%d..%d len=%d' % (s[0], s[1], s[2], s[2] - s[1]))
    cover = np.zeros_like(Cm)
    for (a, b, c) in Hm: cover[max(0, a - 1):a + 2, b:c + 1] = True
    for (a, b, c) in Vm: cover[b:c + 1, max(0, a - 1):a + 2] = True
    R = Cm & ~ndimage.binary_dilation(cover, np.ones((5, 5)))
    lb2, m2 = ndimage.label(R, np.ones((3, 3)))
    print('  residual blobs:')
    for j in range(1, m2 + 1):
        P = np.argwhere(lb2 == j)
        if len(P) < 8: continue
        y0, x0 = P.min(0); y1, x1 = P.max(0)
        print('   px %3d (%d,%d)-(%d,%d) ang %.1f' % (
            len(P), x0, y0, x1, y1, np.degrees(np.arctan2(y1 - y0, x1 - x0))))
