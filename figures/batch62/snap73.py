import numpy as np, json, sys
from PIL import Image
from scipy import ndimage

a = np.array(Image.open('src/dt73-raw.png').convert('L')) < 160
ys, xs = np.nonzero(a)
pts = np.stack([xs, ys], 1).astype(float)

def snap(p, r=7.0, it=4):
    q = np.array(p, float)
    for _ in range(it):
        sel = ((pts - q) ** 2).sum(1) < r * r
        if not sel.any(): return None
        nq = pts[sel].mean(0)
        if np.hypot(*(nq - q)) < 0.4: q = nq; break
        q = nq
    return q

def refine(rough, r=7.0):
    out = []
    for p in rough:
        s = snap(p, r)
        if s is None:
            print('  MISS', p); out.append(np.array(p, float))
        else:
            out.append(s)
    return out

def thin(segs, w=3):
    m = np.zeros(a.shape, bool)
    for s in segs:
        p = np.array(s, float)
        for i in range(len(p) - 1):
            u, v = p[i], p[i + 1]
            L = int(np.hypot(*(v - u))) + 1
            for t in range(L + 1):
                x, y = u + (v - u) * t / L
                xi, yi = int(round(x)), int(round(y))
                m[max(0, yi - w):yi + w + 1, max(0, xi - w):xi + w + 1] = True
    return m

def report(segs):
    m = thin(segs)
    bad = a & ~ndimage.binary_dilation(m, np.ones((7, 7)))
    lb, n = ndimage.label(bad, np.ones((3, 3)))
    comps = []
    for i in range(1, n + 1):
        yy, xx = np.nonzero(lb == i)
        if len(xx) < 15: continue
        comps.append((len(xx), int(xx.min()), int(xx.max()), int(yy.min()), int(yy.max())))
    comps.sort(reverse=True)
    print('ink %d  uncovered %d (%.1f%%)' % (a.sum(), bad.sum(), 100 * bad.sum() / a.sum()))
    for c in comps[:14]:
        print('   gap px %d  x %d..%d  y %d..%d' % c)

CIRCLE = [(176,74),(182,75),(214,80),(236,88),(250,94),(262,100),(270,112),(278,132),(286,160),(289,190),
          (285,220),(277,240),(264,260),(249,276),(228,288),(210,294),(185,296),(160,292),(140,285),
          (124,276),(112,266),(100,250),(94,240),(89,230),(85,220),(81,210),(79,200),(78,190),
          (78,180),(76,170),(80,160),(86,140),(91,130),(97,120),(105,110),(114,100),(128,90),(150,80),(165,76)]

LOBE = [(274,120),(284,112),(296,108),(308,100),(315,95),(324,90),(340,80),(359,70),(382,60),
        (395,55),(420,45),(449,40),(500,36),(548,40),(570,48),(592,60),(611,80),(621,100),(626,120),
        (630,160),(631,185),(628,200),(617,240),(608,260),(598,280),(584,300),(565,320),(540,340),
        (499,360),(440,365),(378,360),(345,352),(314,340),(277,320),(264,312),(251,300),(245,292),
        (240,283),(232,280),(224,272),(219,262),(211,240),(209,225),(209,210),(212,200),(215,190),
        (220,180),(226,170),(235,160),(244,150),(253,140),(263,130)]

ARROWS = [((76,172),(48,224)), ((633,170),(662,55)), ((274,120),(237,44)), ((274,120),(194,170)),
          ((240,283),(335,229)), ((240,283),(282,382))]

if __name__ == '__main__':
    segs = [refine(CIRCLE), refine(LOBE)]
    for u, v in ARROWS:
        segs.append([np.array(u, float), np.array(v, float)])
    json.dump([[[round(float(c[0]), 1), round(float(c[1]), 1)] for c in s] for s in segs],
              open('segs73.json', 'w'))
    report(segs)
