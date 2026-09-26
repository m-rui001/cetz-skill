from pathlib import Path
from datetime import datetime
from zoneinfo import ZoneInfo
import pymupdf as fitz
from PIL import Image, ImageDraw

root=Path(__file__).resolve().parents[2]
batch=Path(__file__).parent
stamp=datetime.now(ZoneInfo('Asia/Shanghai')).strftime('%Y-%m-%d %H:%M')
experience=root/'work/EXPERIENCE.md'
if '## batch39：立体器件与软件框图' not in experience.read_text(encoding='utf-8'):
    with experience.open('a',encoding='utf-8') as stream:
        stream.write('\n\n## batch39：立体器件与软件框图\n\n'
                     '- 3/3 通过，视觉重试 0/1/1，全部首稿编译成功。立体 COW 光路以多边形器件面、椭圆端面和独立细光纤路径绘制，不引入嵌入图像。\n'
                     '- 组件标签先按可容纳的器件面计算尺寸。三行文字高度可能由默认段落行距放大；缩小字并设 par(leading:0pt)，实际查看是否超出器件面。\n'
                     '- 光路先画，组件后盖住其内部段；共用源图节点坐标，防止线在器件附近出现细小断口。\n'
                     '- 大框图的控制图标箭头头部需要独立参数：全局 17px 头部放进 31px 图标会压过符号，微型箭头缩至 5–6px。\n'
                     '- 软件系统图的各支路仍保留完整（DAC/ADC 数量、混频器数量、监测分支、LO 输入），不能为通过判定而删掉小组件。\n'
                     '- 表面明暗可分层近似，但记录与来源的差异；本批 COW 器件较原图阴影简化，几何、数量、位置及光路保持。\n')
log=root/'community.md'
if 'Codex（batch39 收口）' not in log.read_text(encoding='utf-8'):
    with log.open('a',encoding='utf-8') as stream:
        stream.write(f'\n\n### [{stamp}] Codex（batch39 收口）\n'
                     '- pdf016 卫星地面光路/概念时序、pdf017 软件定义收发系统、pdf018 COW 实验光路，3/3 通过，视觉重试 0/1/1，300 ppi 源码/原图/PNG/逐图比对/RESULTS.md 已齐；预览 work/PDF-PREVIEW-4.png。\n'
                     '- 立体 COW 器件表面明暗较源图简化，已在结果里记录；器件外形、布局与完整光纤路径保留。字体按主人标准清楚即可。\n'
                     '- 同篇当前 11 张整图通过、6 块附加面板通过、5 张数据曲线排除；仍待 Fig.4(a)、Fig.10(a)、Fig.6 可转绘部分。逐图状态表及 SELECTION.md 已更新，下一图号 pdf019。\n'
                     '- 本轮为具体进展，整体目标未完成，无阻塞；接下来继续剩余光路和集成芯片示意，不扩缩主人原范围。\n')

tiles=[]
for name in ['pdf016-satellite-ground-optics','pdf017-software-defined-qkd','pdf018-cow-experiment']:
    img=Image.open(batch/f'png/{name}.png').convert('RGB')
    box=img.convert('L').point(lambda v:255 if v<245 else 0).getbbox()
    if box:img=img.crop(box)
    img.thumbnail((1000,650))
    tile=Image.new('RGB',(1040,img.height+70),'white')
    ImageDraw.Draw(tile).text((20,12),name,fill='#444444')
    tile.paste(img,((1040-img.width)//2,45))
    tiles.append(tile)
sheet=Image.new('RGB',(1040,sum(t.height for t in tiles)+40),'#eeeeee')
y=0
for tile in tiles:
    sheet.paste(tile,(0,y));y+=tile.height+20
sheet.save(root/'work/PDF-PREVIEW-4.png')

doc=fitz.open('E:/pdf/pdfonly-stem/pdfcorpus/out/pdfs/epr/4f/4f53c97362c66632bad047e1440e69ed41896204.pdf')
out=root/'work/pdf-candidates/remaining-4f53'
(out/'fig4a-native.png').write_bytes(doc.extract_image(954)['image'])
images=doc[57].get_images()
for im in images:
    if im[2:4] == (1808,837):
        (out/'fig10a-native.png').write_bytes(doc.extract_image(im[0])['image'])
        print('Fig.10a embedded image:',im[0])
print('Recorded batch39, preview and next source panels.')
