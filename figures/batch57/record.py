from pathlib import Path
from datetime import datetime
from zoneinfo import ZoneInfo
from PIL import Image, ImageDraw
import json
b=Path(__file__).parent
root=b.parents[1]
p=b/'SOURCE.json';meta=json.loads(p.read_text(encoding='utf-8'))
for item in meta['figures']:item.update(status='pass',visual_retries=1,ppi=300)
p.write_text(json.dumps(meta,ensure_ascii=False,indent=2),encoding='utf-8')
images=[]
for item in meta['figures']:
    im=Image.open(b/'png'/f"{item['id']}.png").convert('RGB');im.thumbnail((1500,1150));images.append(im)
sheet=Image.new('RGB',(1540,sum(im.height for im in images)+120),'white');draw=ImageDraw.Draw(sheet);y=10
for label,im in zip(('Fig.11 — voltage multiplier cells','Fig.12 — rectifier placement'),images):
    draw.text((20,y),label,fill='black');sheet.paste(im,((1540-im.width)//2,y+25));y+=im.height+50
sheet.save(root/'work/PDF-PREVIEW-14.png')
p=root/'work/EXPERIENCE.md';t=p.read_text(encoding='utf-8')
row='| 57 | `work/batch57` | 2/2（完整倍增单元与整流器放置结构） | 2026-09-26 |'
if row not in t:
    lines=t.splitlines();positions=[i for i,line in enumerate(lines) if line.startswith('| ') and '`work/batch' in line]
    lines.insert(max(positions)+1,row);t='\n'.join(lines)+'\n'
t+='''

## batch57：水平电容镜像、标签侧别与绕组圈数（Codex）

- 水平电容弯板左右朝向应单独保留：Fig.11 (c) 上端弯板向左、下端向右，(f) 中部电容也向右。镜像不仅改变曲线端点，还要交换左右引线对应的直板/弯板连接点；引线精确接在 Bézier 中点。
- 标签按原图侧别逐个放，不用统一“器件左侧”。本批 (g) C 原本在电容右侧，初稿误放左侧；重看原图后纠正。字体宽容不允许标签挤进曲极板，先调离符号的距离，再小幅调整字号。
- 导线端点与二极管 helper 起点要一致：中心 x=718、左引线长 16 时，支路必须到 x=702，写 701 会留下真实断线。不能靠较粗笔画掩盖，放大编译图核对连续性。
- 小磁性器件的圈数和引线余量分开设定。Fig.12 变压器原图四圈，初稿误用五圈；改为四圈、上下各保留原图短直线，避免绕组占满端口之间全部高度。
- 灰色 Lr、波形小符号属于概念图内容，仍保留其颜色和位置。Fig.12 的正弦/方波只标示输入类型，无数值坐标/数据，不归入用户要求排除的数据曲线。
- 本批完整 Fig.11/12 2/2 通过，视觉重试各 1；只在成功编译并实际查看最终比较后收口，七/二面板不重复计数。
'''
p.write_text(t,encoding='utf-8')
p=root/'work/pdf-candidates/8da2-converters/STATUS.md';t=p.read_text(encoding='utf-8')
t=t.replace('当前 Fig.1–5、7–10 九幅完整图通过（batch47/49/50/53/54/55），Fig.6 定量图表排除，其余继续处理。','当前 Fig.1–5、7–12 十一幅完整图通过（batch47/49/50/53/54/55/57），Fig.6 定量图表排除，其余继续处理。')
t=t.replace('| 11 | 12 | 电压倍增单元，待转绘 |','| 11 | 12 | batch57/pdf038 完整七面板通过，视觉重试 1 |')
t=t.replace('| 12 | 13 | 电压倍增整流器的放置框图，待转绘 |','| 12 | 13 | batch57/pdf039 完整两面板通过，视觉重试 1 |')
t=t.replace('下一步 Fig.11 完整电压倍增单元，再继续 Fig.12 等。新图号从 pdf038 起','下一步 Fig.13 完整半波倍增整流器，再继续 Fig.14 等。新图号从 pdf040 起')
p.write_text(t,encoding='utf-8')
with (root/'work/pdf-candidates/SELECTION.md').open('a',encoding='utf-8') as f:
    f.write('\n\n### 8da22c007a Fig.11/12 完整通过\n\n- batch57/pdf038：PDF12 Fig.11 完整主结构/六种倍增单元；pdf039：PDF13 Fig.12 完整两种倍增整流器放置结构。2/2，通过，各 1 次视觉重试。概念输入小符号保留、数据图继续排除。下一步 PDF14 Fig.13，pdf040 起。\n')
stamp=datetime.now(ZoneInfo('Asia/Shanghai')).strftime('%Y-%m-%d %H:%M')
with (root/'community.md').open('a',encoding='utf-8') as f:
    f.write(f'''\n\n### [{stamp}] Codex（batch57 收口；经验已追加）
- pdf038 Fig.11 完整七面板倍增单元、pdf039 Fig.12 完整两组倍增整流器放置结构，2/2 完整图通过，各 1 次视觉重试；主结构、器件/节点、弯板方向、非连接跨线、灰色电感、输入类型小符号、磁性器件全部保留。原生自包含 CeTZ、原图、300 ppi PNG、最终实际比较、SOURCE.json/RESULTS.md 已齐；预览 work/PDF-PREVIEW-14.png。
- 已追加 EXPERIENCE.md batch57：水平电容镜像时交换引线连接点、标签正确侧别/曲极板余量、二极管端点差一个单位的断线、绕组圈数和引线分开设定、概念波形小符号与数据图的区分。修正前后都实际查看，面板不重复累计通过数。
- 本篇 Fig.1–5、7–12 十一幅完整通过，Fig.6/34 定量图排除；下一步 Fig.13 完整半波倍增整流器，pdf040 起。新批号先核对三方日志/目录并确认独占创建成功。总体目标未完成，本轮为具体进展，无阻塞。
''')
print('Recorded batch57 2/2 pass, preview, lessons and shared status.')
