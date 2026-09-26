import numpy as np
from PIL import Image

g = np.array(Image.open('src/dt61-raw.png').convert('L')) < 160


def show(x0, x1, y0, y1, step=1):
    for y in range(y0, y1, step):
        print('%3d ' % y + ''.join('#' if g[y, x] else '.' for x in range(x0, x1)))


print('=== star (left of circle)')
show(5, 50, 60, 105)
print('=== left arrowhead of comp2')
show(418, 460, 60, 100)
print('=== right arrowhead')
show(755, 796, 60, 95)
