from pathlib import Path
from datetime import datetime
from zoneinfo import ZoneInfo
from PIL import Image, ImageDraw
import json

b=Path(__file__).parent
root=b.parents[1]
p=b/'SOURCE.json'
meta=json.loads(p.read_text(encoding='utf-8'))
for item in meta['figures']:
    item.update(status='pass',visual_retries=1,ppi=300)
p.write_text(json.dumps(meta,ensure_ascii=False,indent=2),encoding='utf-8')
images=[]
for item in meta['figures']:
    im=Image.open(b/'png'/f"{item['id']}.png").convert('RGB')
    im.thumbnail((1500,950))
    images.append(im)
preview=Image.new('RGB',(1540,sum(im.height for im in images)+110),'white')
draw=ImageDraw.Draw(preview)
y=10
for label,im in zip(('Fig.7 — eight circuits','Fig.8 — classification tree'),images):
    draw.text((20,y),label,fill='black')
    preview.paste(im,((1540-im.width)//2,y+25))
    y+=im.height+45
preview.save(root/'work/PDF-PREVIEW-11.png')

p=root/'work/EXPERIENCE.md'
text=p.read_text(encoding='utf-8')
row='| 53 | `work/batch53` | 2/2（完整八电路与电压提升分类树） | 2026-09-26 |'
if row not in text:
    # Preserve all concurrent contributors and insert after the current table's last batch row.
    lines=text.splitlines()
    positions=[i for i,line in enumerate(lines) if line.startswith('| ') and '`work/batch' in line]
    lines.insert(max(positions)+1,row)
    text='\n'.join(lines)+'\n'
text+='''

## batch53：串联开关断口与分类树文字余量（Codex）

- 串联开关不能直接叠加含长引线的通用符号：上一个器件的尾线可能穿过下一个器件的断口，形成错误的连续通路。Fig.7 (c)/(d) 用显式折线逐段接固定触点，每个断口保留独立空隙；只有查看编译图才能确认。
- 电容 helper 的引线起点要与极板类型一起变化：曲极板的连接点和平板不同。把曲极板替换成直线时同步改尾线起点，否则留下小断线；元件不只包括外形，也包括连续接线。
- 交叉斜线先判断是否连接。Fig.7 (e) 有跨线弧而无节点，按原图用 Bézier 小弧绕开另一斜线；不能把交点补成实心节点。
- 耦合电感同时保留绕组、双磁芯线、极性点和标签位置。两组绕组上下排列或分布在输入/输出两侧仍应逐项定位，不能因器件相同而换成统一图标。
- 分类树先锁定框尺寸和分支关系，再调文字字号/行距。字体不必完全一致，但长标签不能撑出框或改变全图包围盒；本批保留源图两行断行，字体从 7pt 缩至 6.55pt 后留出余量。
- 本批两图都经过初稿与修正稿的真实视觉比较，各 1 次视觉重试、2/2 通过；通过数按整图计算，没有把八个电路面板分别重复计数。
'''
p.write_text(text,encoding='utf-8')

p=root/'work/pdf-candidates/8da2-converters/STATUS.md'
text=p.read_text(encoding='utf-8')
text=text.replace('当前 Fig.1–5 五幅完整图通过（batch47/49/50），Fig.6 定量图表排除，其余继续处理。','当前 Fig.1–5、7、8 七幅完整图通过（batch47/49/50/53），Fig.6 定量图表排除，其余继续处理。')
text=text.replace('| 7 | 9 | 最小相位升压电路，待转绘 |','| 7 | 9 | batch53/pdf034 完整八面板通过，视觉重试 1 |')
text=text.replace('| 8 | 11 | 电压提升技术分类树，待转绘 |','| 8 | 11 | batch53/pdf035 完整分类树通过，视觉重试 1 |')
text=text.replace('下一步 Fig.7 完整最小相位升压电路组，再继续 Fig.8 等。新图号从 pdf034 起','下一步 Fig.9 七组电荷泵/开关电容电路，再继续 Fig.10 等。新图号从 pdf036 起')
p.write_text(text,encoding='utf-8')
with (root/'work/pdf-candidates/SELECTION.md').open('a',encoding='utf-8') as f:
    f.write('\n\n### 8da22c007a Fig.7/8 完整通过\n\n- batch53/pdf034：PDF9 Fig.7 八组最小相位升压电路与推导箭头；pdf035：PDF11 Fig.8 完整电压提升分类树。两幅各 1 次视觉重试，最终实际比对通过，2/2。下一步 PDF11 Fig.9 七组电路，pdf036 起。\n')
stamp=datetime.now(ZoneInfo('Asia/Shanghai')).strftime('%Y-%m-%d %H:%M')
with (root/'community.md').open('a',encoding='utf-8') as f:
    f.write(f'''\n\n### [{stamp}] Codex（batch53 收口；经验已总结）
- pdf034 Fig.7 完整八组最小相位升压电路及两条推导箭头、pdf035 Fig.8 完整分类树，2/2 通过，视觉重试各 1；原图、原生自包含 CeTZ、300 ppi PNG、最终比较、SOURCE.json/RESULTS.md 已齐。预览 work/PDF-PREVIEW-11.png。
- 按主人提醒追加 EXPERIENCE.md batch53：串联开关长引线穿过断口、曲/直电容极板连接点、斜线非连接跨线、耦合绕组磁芯/极性点、分类树文字余量和整图计数。没有将面板数当通过图数。
- 本篇 Fig.1–5、7、8 七幅完整通过，Fig.6/34 定量图排除；下一步 Fig.9 七组电荷泵/开关电容电路，从 pdf036 起。新批号需查三方共享日志/实际目录并先确认原子 mkdir 成功。整体目标未完成，本轮为具体进展，无阻塞。
''')
print('Recorded batch53: 2/2 pass, lessons, status, preview and shared log.')
