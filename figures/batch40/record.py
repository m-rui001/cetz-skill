from pathlib import Path
from datetime import datetime
from zoneinfo import ZoneInfo
from PIL import Image, ImageDraw

root=Path(__file__).resolve().parents[2]
batch=Path(__file__).parent
stamp=datetime.now(ZoneInfo('Asia/Shanghai')).strftime('%Y-%m-%d %H:%M')
experience=root/'work/EXPERIENCE.md'
if '## batch40：斜向台面与器件计数' not in experience.read_text(encoding='utf-8'):
    with experience.open('a',encoding='utf-8') as stream:
        stream.write('\n\n## batch40：斜向台面与器件计数\n\n'
                     '- 两块大型光路 2/2 通过，各 1 次视觉重试。沿原图像素坐标建立器件端点和台面四边，可保留斜向布局；不用先把原图改成横向再重排。\n'
                     '- 复杂光路先列完整组件/支路清单：本批 CV-QKD 有 10 个柱形器件、4 个 PIN、2 个 FM，反馈、时钟、零差探测和信号/LO 都须保留。\n'
                     '- 柱形器件用轴向向量与垂向向量参数化；表面灰色层带、两端椭圆和外轮廓独立画，原生矢量即可近似立体外形。\n'
                     '- 光纤小环是闭合椭圆，手拼两段控制点会误画成心形；量好中心/半径后直接 circle(radius:(rx,ry))。\n'
                     '- 双行斜向标注若旋转后拥挤，按原图分开两行的绝对中心，比调段落行距更容易控制位置。\n'
                     '- 图例端点与文字用 west 锚点；居中锚点会把较长图例压到彩色线段上。\n'
                     '- compare.py 先按墨迹框去白边、再等宽归一且保持纵横比，因此页边距不改变此比较中的内部图形几何。对含白边的整幅等宽缩放则需同时控制白边，否则比例可被误判。\n')
log=root/'community.md'
if 'Codex（batch40 收口）' not in log.read_text(encoding='utf-8'):
    with log.open('a',encoding='utf-8') as stream:
        stream.write(f'\n\n### [{stamp}] Codex（batch40 收口）\n'
                     '- pdf019 双基底 DV-QKD、pdf020 同传 LO 的大型 CV-QKD 光路，2/2 通过，各 1 次视觉重试；300 ppi 编译、原图、源码、逐图比对、SOURCE.json、RESULTS.md 已齐；预览 work/PDF-PREVIEW-5.png。\n'
                     '- Fig.4 与 Fig.10 全部独立面板均已转绘，仍需按源图布局合成完整复合版；Fig.6 集成芯片可转绘示意部分也仍待做。当前 11 整图 + 8 附加面板通过、5 数据曲线排除，下一图号 pdf021。\n'
                     '- 给 Agent-C 的比较补充：我的 compare.py 先按墨迹框去白边，再等宽归一并保持纵横比，页边距不会改变此比较中的内部几何；整幅含白边比较时则需控制双方白边。字体沿用主人清楚即可的标准。\n'
                     '- 已看到 batch41 属 Agent-C，后续新批先查日志与目录。整体目标未完成，无阻塞；本轮为具体进展。\n')
tiles=[]
for name in ['pdf019-dv-qkd-benches','pdf020-transmitted-lo-cv-qkd']:
    img=Image.open(batch/f'png/{name}.png').convert('RGB')
    box=img.convert('L').point(lambda v:255 if v<245 else 0).getbbox()
    if box:img=img.crop(box)
    img.thumbnail((1000,650))
    tile=Image.new('RGB',(1040,img.height+70),'white')
    ImageDraw.Draw(tile).text((20,12),name,fill='#444444')
    tile.paste(img,((1040-img.width)//2,45))
    tiles.append(tile)
sheet=Image.new('RGB',(1040,sum(t.height for t in tiles)+20),'#eeeeee')
y=0
for tile in tiles:
    sheet.paste(tile,(0,y));y+=tile.height+20
sheet.save(root/'work/PDF-PREVIEW-5.png')
print('Recorded batch40 and preview.')
