import numpy as np
from PIL import Image
from scipy import ndimage

N = 'dt5-square'
OX, OY = 18, 16
s = np.array(Image.open(f'src/{N}-raw.png').convert('L')).astype(int) < 160
r = np.array(Image.open(f'png/{N}.png').convert('L')).astype(int) < 160
bs = [int(np.nonzero(s)[1].min()), int(np.nonzero(s)[1].max()),
      int(np.nonzero(s)[0].min()), int(np.nonzero(s)[0].max())]
br = [int(np.nonzero(r)[1].min()), int(np.nonzero(r)[1].max()),
      int(np.nonzero(r)[0].min()), int(np.nonzero(r)[0].max())]
sw = bs[1] - bs[0] + 1
sc = sw / (br[1] - br[0] + 1)
rc = r[br[2]:br[3] + 1, br[0]:br[1] + 1]
big = np.array(Image.fromarray((rc * 255).astype('uint8')).resize(
    (int((br[1] - br[0] + 1) * sc), int((br[3] - br[2] + 1) * sc)), Image.LANCZOS)) > 128
dist = ndimage.distance_transform_edt(~s)
H, W = s.shape
yy = np.nonzero(big)[0] + br[2] - (br[2] * 0)  # coords in resized image
xs = np.nonzero(big)[1]
ys = np.nonzero(big)[0]
ty, tx = ys + OY, xs + OX
ok = (ty >= 0) & (ty < H) & (tx >= 0) & (tx < W)
d = dist[ty[ok], tx[ok]]
sx, sy = tx[ok], ty[ok]
print('mean', round(d.mean(), 3), 'n', len(d))
# bin by source component / region: use a coarse grid
bins = {
    'frame': lambda x, y: ((y < 20) | (y > 300) | ((y > 70) & (y < 90) & (x > 80) & (x < 380)) | ((y > 250) & (y < 275) & (x > 80) & (x < 380)) | ((x > 45) & (x < 75) & (y > 100) & (y < 230)) | ((x > 390) & (x < 415) & (y > 100) & (y < 230))),
    'eq1': lambda x, y: (x > 540) & (y < 168),
    'eq2': lambda x, y: (x > 540) & (y >= 168),
    'f': lambda x, y: (x > 210) & (x < 250) & (y < 55),
    'g': lambda x, y: (x > 210) & (x < 250) & (y > 280),
    'phi': lambda x, y: (x < 45) & (y > 140) & (y < 195),
    'psi': lambda x, y: (x > 420) & (x < 455) & (y > 150) & (y < 200),
    'XY': lambda x, y: (x > 40) & (x < 425) & (y > 50) & (y < 95),
    'UV': lambda x, y: (x > 40) & (x < 425) & (y > 235) & (y < 280),
}
for k, f in bins.items():
    m = f(sx, sy)
    print('%-6s n=%5d mean=%5.2f max=%5.1f' % (k, m.sum(), d[m].mean() if m.sum() else -1,
                                               d[m].max() if m.sum() else -1))
rest = ~np.any([f(sx, sy) for f in bins.values()], 0)
print('rest  n=%5d mean=%5.2f' % (rest.sum(), d[rest].mean() if rest.sum() else -1))
