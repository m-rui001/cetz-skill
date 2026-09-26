"""Trace white-region boundaries of a line-art PNG into ordered polylines.

usage: python trace.py <dir> <name> [eps] [min_area]
Prints each closed contour as a python tuple of (x, y) source-pixel points.
"""
import sys
import numpy as np
from PIL import Image
from scipy import ndimage

d = sys.argv[1]
n = sys.argv[2]
eps = float(sys.argv[3]) if len(sys.argv) > 3 else 3.0
min_area = int(sys.argv[4]) if len(sys.argv) > 4 else 800

a = np.array(Image.open(f"{d}/src/{n}-raw.png").convert("L")).astype(int)
H, W = a.shape
ink = a < 200
white = ~ink
lab, nl = ndimage.label(white, structure=np.array([[0, 1, 0], [1, 1, 1], [0, 1, 0]]))
print("# regions", nl)


def cycles2(mask):
    """Crack-follow the boundary of a boolean region -> list of closed point loops."""
    p = np.zeros((mask.shape[0] + 2, mask.shape[1] + 2), bool)
    p[1:-1, 1:-1] = mask
    edges = []
    for r, c in zip(*np.nonzero(p)):
        R, C = r - 1, c - 1
        if not p[r - 1, c]:
            edges.append(((C, R), (C + 1, R)))
        if not p[r + 1, c]:
            edges.append(((C + 1, R + 1), (C, R + 1)))
        if not p[r, c - 1]:
            edges.append(((C, R + 1), (C, R)))
        if not p[r, c + 1]:
            edges.append(((C + 1, R), (C + 1, R + 1)))
    adj = {}
    for i, e in enumerate(edges):
        adj.setdefault(e[0], []).append(i)
    used = [False] * len(edges)
    loops = []
    for i in range(len(edges)):
        if used[i]:
            continue
        used[i] = True
        pts = [list(edges[i][0]), list(edges[i][1])]
        cur = edges[i][1]
        while True:
            nxt = None
            for j in adj.get(cur, []):
                if not used[j]:
                    nxt = j
                    break
            if nxt is None:
                break
            used[nxt] = True
            e = edges[nxt]
            cur = e[1] if e[0] == cur else e[0]
            pts.append(list(cur))
        loops.append(pts)
    return loops


def dp(pts, eps):
    if len(pts) < 3:
        return pts
    keep = [False] * len(pts)
    keep[0] = keep[-1] = True
    stack = [(0, len(pts) - 1)]
    while stack:
        s, e = stack.pop()
        if e <= s + 1:
            continue
        p0 = np.array(pts[s], float)
        p1 = np.array(pts[e], float)
        dvec = p1 - p0
        L = np.hypot(*dvec) or 1e-9
        nrm = np.array([-dvec[1], dvec[0]]) / L
        arr = np.array(pts[s + 1:e], float)
        dist = np.abs((arr - p0) @ nrm)
        k = int(np.argmax(dist))
        if dist[k] > eps:
            idx = s + 1 + k
            keep[idx] = True
            stack.append((s, idx))
            stack.append((idx, e))
    return [pts[i] for i in range(len(pts)) if keep[i]]


def dp_closed(pts, eps):
    p0 = np.array(pts[0], float)
    k = int(np.argmax([np.hypot(*(np.array(p, float) - p0)) for p in pts]))
    a = dp(pts[:k + 1], eps)
    b = dp(pts[k:] + [pts[0]], eps)
    return a + b[1:-1]


def near(p, q, tol=2.5):
    return abs(p[0] - q[0]) <= tol and abs(p[1] - q[1]) <= tol


def merge(loops):
    """Join crack-walk arcs that were split at ambiguous corners."""
    todo = [l for l in loops if len(l) > 3]
    done = []
    while todo:
        cur = todo.pop(0)
        changed = True
        while changed:
            changed = False
            for other in list(todo):
                nxt = None
                if near(cur[-1], other[0]):
                    nxt = cur + other[1:]
                elif near(cur[-1], other[-1]):
                    nxt = cur + other[-2::-1]
                elif near(cur[0], other[-1]):
                    nxt = other + cur[1:]
                elif near(cur[0], other[0]):
                    nxt = other[::-1] + cur[1:]
                if nxt is None:
                    continue
                todo.remove(other)
                cur = nxt
                changed = True
                break
        done.append(cur)
    return done


for i in range(1, nl + 1):
    m = lab == i
    area = int(m.sum())
    if area < min_area:
        continue
    ys, xs = np.nonzero(m)
    touches = xs.min() == 0 or ys.min() == 0 or xs.max() == W - 1 or ys.max() == H - 1
    if touches:
        continue
    for lp in merge(cycles2(m)):
        if len(lp) < 12:
            continue
        closed = lp + [lp[0]]
        simp = dp_closed(closed, eps)
        if len(simp) < 6:
            continue
        print(f"# region {i} area {area} bbox x {xs.min()}..{xs.max()} y {ys.min()}..{ys.max()} "
              f"pts {len(simp)}")
        print("((" + "),(".join(f"{p[0]},{p[1]}" for p in simp) + "),)")
