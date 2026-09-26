import numpy as np
from PIL import Image
s=np.array(Image.open('src/dt54-tangent-raw.png').convert('L')).astype(int)<160
r=np.array(Image.open('png/dt54-tangent.png').convert('L')).astype(int)<160
bs=(15,489,16,446); br=(4,187,4,168)
sx=(bs[1]-bs[0])/(br[1]-br[0]); sy=(bs[3]-bs[2])/(br[3]-br[2])
def R(x): return (x-bs[0])/sx+br[0]
def Ry(y): return (y-br[2])*sy+bs[2]
def runs(col, conv=None):
    xs=np.nonzero(col)[0]; out=[]
    if len(xs)==0: return out
    a=xs[0]; p=xs[0]
    for y in xs[1:]:
        if y>p+2: out.append((a,p)); a=y
        p=y
    out.append((a,p))
    if conv: out=[(round(conv(u)),round(conv(v))) for u,v in out]
    return [(int(u),int(v)) for u,v in out]
for x in range(180,500,20):
    c=int(round(R(x)))
    if c<0 or c>=r.shape[1]: continue
    print('x%4d'%x, 'src',runs(s[:,c]), 'rnd', runs(r[:,c],Ry))
