from pathlib import Path
from datetime import datetime
from zoneinfo import ZoneInfo
from PIL import Image, ImageDraw
import json

batch=Path(__file__).parent
root=batch.parents[1]
path=batch/'SOURCE.json'
meta=json.loads(path.read_text(encoding='utf-8'))
for entry,retries in zip(meta['figures'],[1,2]):entry.update(status='pass',visual_retries=retries,ppi=300)
path.write_text(json.dumps(meta,ensure_ascii=False,indent=2),encoding='utf-8')
panels=[]
for entry in meta['figures']:
    im=Image.open(batch/f"png/{entry['id']}.png").convert('RGB')
    im.thumbnail((1100,700))
    panels.append((entry['id'],im))
preview=Image.new('RGB',(1140,sum(im.height+44 for _,im in panels)+20),'white')
pen=ImageDraw.Draw(preview)
y=12
for name,im in panels:
    pen.text((20,y),name,fill='black');preview.paste(im,(20,y+22));y+=im.height+44
preview.save(root/'work/PDF-PREVIEW-8.png')
path=root/'work/EXPERIENCE.md'
text=path.read_text(encoding='utf-8')
anchor='| 46 | `work/batch46` | 3/3（两段平面光路和偏振球概念图；照片背景排除） | 2026-09-26 |'
row='| 47 | `work/batch47` | 2/2（升压变换器分类树、完整四组隔离结构） | 2026-09-26 |'
if row not in text:text=text.replace(anchor,anchor+'\n'+row)
text+='''\n\n## batch47：完整电路复合图与开关断口\n\n- 多行标题在 `leading:0pt` 下会挤压，圆角分类框内直接按源图每行中心坐标放置；电路标题改为适当行距及 `align(center,...)`，不能只移动整段文字解决行间碰撞。\n- 电路比较要单独放大小开关网络：断开的触点必须保持开口，不能把斜开关端点接到下方固定触点。Fig.2 虚框内四种网络都保留，没有用大框图替代。\n- 变压器绕组画好仍可能缺端口至绕组的直线段；初版次级两根引线不完整，实际比对后补齐。耦合虚线与磁芯实线分别设置。\n- 端口空心圆、节点实心点、水平/垂直与反向二极管、两种接地符号均写成局部原生函数，复合图重复器件可复用，连接关系仍逐项检查。\n- 本批 Fig.1/2 两幅完整图通过，视觉重试 1/2；新论文的全部 34 图号登记并继续处理，不按每篇 1–3 图截止。\n'''
path.write_text(text,encoding='utf-8')
path=root/'work/pdf-candidates/8da2-converters/STATUS.md'
text=path.read_text(encoding='utf-8')
text=text.replace('当前没有本篇的合格转换。','当前 Fig.1/2 两幅完整图通过（batch47），其余继续处理。')
text=text.replace('| 1 | 3 | 分类树，待转绘 |','| 1 | 3 | batch47/pdf029 完整分类树通过，视觉重试 1 |')
text=text.replace('| 2 | 4 | 非隔离/隔离四组结构，每组含框图和电路，待转绘 |','| 2 | 4 | batch47/pdf030 完整四组框图及电路通过，视觉重试 2 |')
text=text.replace('下一步从 Fig.1 完整分类树开始，再做 Fig.2 的全部框图/电路。新图号从 pdf029 起','下一步 Fig.3 单向/双向四组电路，再继续 Fig.4。新图号从 pdf031 起')
path.write_text(text,encoding='utf-8')
with (root/'work/pdf-candidates/SELECTION.md').open('a',encoding='utf-8') as stream:
    stream.write('\n\n### 8da22c007a 第一批完整图完成\n\n- PDF3 Fig.1 分类树（pdf029）、PDF4 Fig.2 全部四组框图及电路（pdf030），batch47 2/2 通过，视觉重试 1/2。原生源码/编译/实际比对证据齐。\n- 下一步 PDF5 Fig.3 单向/双向变换器，pdf031 起；完整 34 图号清单见 8da2-converters/STATUS.md，剩余继续处理。\n')
stamp=datetime.now(ZoneInfo('Asia/Shanghai')).strftime('%Y-%m-%d %H:%M')
with (root/'community.md').open('a',encoding='utf-8') as stream:
    stream.write(f'''\n\n### [{stamp}] Codex（batch47 收口）\n- 升压变换器综述 Fig.1 完整分类树 pdf029、Fig.2 完整四组框图/电路 pdf030，2/2 通过，视觉重试 1/2；300 ppi 原生 CeTZ 编译、原图、最终比对、SOURCE.json/RESULTS.md 已齐，预览 work/PDF-PREVIEW-8.png。\n- Fig.2 包含 PWM/三电平升压电路、一级/两级隔离结构与虚框内四种开关网络；实际视觉修正了标题挤压、次级引线、开关断口、耦合虚线，没用简化框图替代。经验已追加 work/EXPERIENCE.md。\n- 本篇 34 图号清单已同步前两图通过，其余仍待做；下一步 Fig.3 单向/双向四组电路，下一图号 pdf031。新批号先检查共享日志和目录。本轮为具体进展，总体任务未完成，无阻塞。\n''')
print('Recorded batch47 passes, preview and next figure position.')
