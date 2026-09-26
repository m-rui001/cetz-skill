import numpy as np, json, sys
from PIL import Image
from scipy import ndimage

m = np.load('m21.npy')
H, W = m.shape

def runs(colmask):
    out, i = [], 0
    while i < len(colmask):
        if colmask[i]:
            j = i
            while j+1 < len(colmask) and colmask[j+1]: j += 1
            out.append((i, j)); i = j+1
        else: i += 1
    return out

def trace(start, heading, nsteps=4000, R=7.0, halfwin=55.0, hsm=0.55):
    cur = np.array(start, float)
    hd = np.deg2rad(heading)
    pts = [tuple(cur)]
    angs = np.arange(-halfwin, halfwin + .001, 0.5)
    for k in range(nsteps):
        good = []
        for a in angs:
            th = hd + np.deg2rad(a)
            p = cur + R*np.array([np.cos(th), np.sin(th)])
            xi, yi = int(round(p[0])), int(round(p[1]))
            if 0 <= xi < W and 0 <= yi < H and m[yi, xi]:
                good.append(a)
        if not good:
            pts.append(('STOP', tuple(cur), k)); break
        good = np.array(good)
        # split into intervals
        iv = [[good[0]]]
        for a in good[1:]:
            if a - iv[-1][-1] <= 1.0: iv[-1].append(a)
            else: iv.append([a])
        # interval whose midpoint is closest to 0 (straight ahead)
        best = min(iv, key=lambda g: abs(np.mean(g)))
        nm = np.mean(best)
        th = hd + np.deg2rad(nm)
        cur = cur + R*np.array([np.cos(th), np.sin(th)])
        hd = (1-hsm)*hd + hsm*th
        pts.append(tuple(cur))
        if k > 20 and np.hypot(*(cur - np.array(pts[0]))) < R*0.9:
            pts.append(('CLOSED', tuple(cur), k)); break
    return pts

def colstart(x):
    r = runs(m[:, x])
    return [( (a+b)/2.0, x) for a, b in r]

print('left cols', {x: colstart(x) for x in range(45, 52)})
print('right cols', {x: colstart(x) for x in range(560, 567)})

def clean(p):
    return [q for q in p if isinstance(q, tuple) and len(q)==2]

out = {}
for name, st, hd in [('X', (45.0,133.0), -90.0), ('Z', (566.0,169.5), -90.0)]:
    p = trace(st, hd)
    tail = [q for q in p if not (isinstance(q, tuple) and len(q)==2)]
    c = clean(p)
    print(name, 'pts', len(c), 'tail', tail[:1], 'last', c[-1] if c else None)
    out[name] = c
json.dump(out, open('trace21.json','w'))
im = np.array(Image.open('src/dt21-raw.png').convert('L'))
d = Image.fromarray(im).convert('RGB')
dr = Image.Image.load(d)
import PIL.ImageDraw as D
dd = D.Draw(d)
for name, col in [('X',(255,0,0)),('Z',(0,0,255))]:
    dd.line(out[name], fill=col, width=1)
d.save('dbg21.png')
