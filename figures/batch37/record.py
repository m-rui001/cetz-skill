from pathlib import Path
from datetime import datetime
from zoneinfo import ZoneInfo
import pymupdf as fitz
from PIL import Image, ImageDraw

root=Path(__file__).resolve().parents[2]
batch=Path(__file__).parent
stamp=datetime.now(ZoneInfo('Asia/Shanghai')).strftime('%Y-%m-%d %H:%M')
experience=root/'work/EXPERIENCE.md'
if '## batch37：实验光路面板与完整内嵌图' not in experience.read_text(encoding='utf-8'):
    with experience.open('a',encoding='utf-8') as stream:
        stream.write('\n\n## batch37：实验光路面板与完整内嵌图\n\n'
                     '- 3/3 通过（Fig.4b、4c、10b），视觉重试 1/2/2。复合图按面板统计，未处理的面板继续列在逐图状态表。\n'
                     '- 原图排版会遮挡内嵌图片：Fig.4c 右端 TDC 被邻图白底盖住。用 PDF xref 提取完整原始图片，并在 SOURCE.json 中记方法与 native_px；不凭猜测补标签。\n'
                     '- 示意脉冲与数据曲线区分靠图注：Fig.10b 三块时序图说明信号/稳定脉冲的排列，保留；实测或理论数据率曲线按主人要求排除。\n'
                     '- 先确保组件数与支路数：同一蓝底中的 PM 与 AM 是两个独立六边形，不能合成一个长模块。\n'
                     '- 柱脉冲位置可按颜色分割投影读原图，从而纠正高柱/矮柱的相对横坐标；源码仍为可编辑 CeTZ rect。\n'
                     '- range 的第三个位置参数不支持步长，写 range(start,end,step:value)。旋转文字与箭头图标仍需看实际编译方向。\n')
log=root/'community.md'
if 'Codex（batch37 收口）' not in log.read_text(encoding='utf-8'):
    with log.open('a',encoding='utf-8') as stream:
        stream.write(f'\n\n### [{stamp}] Codex（batch37 收口）\n'
                     '- pdf013/014/015，分别为 Fig.4(b) 三态 BB84、Fig.4(c) DPS、Fig.10(b) 本地 LO CV-QKD（含三种时序），3/3 通过，视觉重试 1/2/2；300 ppi PNG、源码、来源、原图、逐图比对与 RESULTS.md 已齐。\n'
                     '- Fig.4c 改用 PDF 完整内嵌图片作为来源，避免邻图白底遮挡 TDC 末端；来源方法已登记。\n'
                     '- 逐图全范围状态表新增 work/pdf-candidates/4f53-figure-status.md：11 张整图通过、3 块附加面板通过、5 张曲线按主人要求排除；Fig.4/6/8/10 尚有待处理面板，未宣称整篇完成。下一图号 pdf016。\n'
                     '- 已看到 Agent-C 从误认领 batch37 更正到 batch38，实际 batch37/src 只有本批三图，保持现有目录。请继续同时查日志与目录。\n'
                     '- 本轮为具体进展，总体任务仍未完成，无阻塞；接下来继续原篇剩余示意面板。\n')

doc=fitz.open('E:/pdf/pdfonly-stem/pdfcorpus/out/pdfs/epr/4f/4f53c97362c66632bad047e1440e69ed41896204.pdf')
out=root/'work/pdf-candidates/remaining-4f53'
(out/'fig8-native.png').write_bytes(doc.extract_image(1179)['image'])
tiles=[]
for name in ['pdf013-three-state-bb84','pdf014-dps-system','pdf015-local-lo-cv-qkd']:
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
    sheet.paste(tile,(0,y))
    y+=tile.height+20
sheet.save(root/'work/PDF-PREVIEW-3.png')
print('Recorded batch37, gallery and full Fig.8 source.')
