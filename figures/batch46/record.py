from pathlib import Path
from datetime import datetime
from zoneinfo import ZoneInfo
from PIL import Image, ImageDraw
import json

batch=Path(__file__).parent
root=batch.parents[1]
manifest=json.loads((batch/'SOURCE.json').read_text(encoding='utf-8'))
for entry,retries in zip(manifest['figures'],[1,0,1]):entry.update(status='pass',visual_retries=retries)
(batch/'SOURCE.json').write_text(json.dumps(manifest,ensure_ascii=False,indent=2),encoding='utf-8')
old=root/'work/batch45/SOURCE.json'
meta=json.loads(old.read_text(encoding='utf-8'))
meta['remaining_panels']=[]
meta['later_completed_schematic_regions']='batch46/pdf026–028'
old.write_text(json.dumps(meta,ensure_ascii=False,indent=2),encoding='utf-8')
panels=[]
for entry in manifest['figures']:
    im=Image.open(batch/f"png/{entry['id']}.png").convert('RGB')
    im.thumbnail((740,650))
    panels.append((entry['id'],im))
preview=Image.new('RGB',(800,sum(im.height+46 for _,im in panels)+20),'white')
pen=ImageDraw.Draw(preview)
y=12
for name,im in panels:
    pen.text((20,y),name,fill='black');preview.paste(im,(20,y+23));y+=im.height+46
preview.save(root/'work/PDF-PREVIEW-7.png')
path=root/'work/EXPERIENCE.md'
text=path.read_text(encoding='utf-8')
anchor='| 45 | `work/batch45` | 0/2，芯片效果图视觉尝试 2 张后放弃；另 1 张草稿终止 | 2026-09-26 |'
text=text.replace(anchor,anchor+'\n| 46 | `work/batch46` | 3/3（两段平面光路和偏振球概念图；照片背景排除） | 2026-09-26 |')
text+='''\n\n## batch46：照片上的光路叠加层与概念球面\n\n- 复合图可只取清楚的平面叠加层，但必须写清排除地图摄影背景，不宣称整张照片或完整复合图通过。原始参考保留，仍按原始坐标核对器件、分支、标签；白底输出的外部文字改黑色保证可读。\n- 调制关系的偏振球不是实验数据曲线：球面和两条主要调制弧可以原生 CeTZ 表达。淡色辅助经纬线近似，主要弧线、方向箭头和态/CDM 标签须逐项核对。\n- 探测器连线末端不要凭视觉留“很小的空隙”；把端点统一为器件端口坐标。sphere 首版遗漏纵向向下箭头，必须看原图逐项检查后补齐。\n- 本批 3/3 独立局部通过，重试 1/0/1；整张 Fig.6 未重画，仍与芯片排除、batch45 失败尝试分开记账。\n'''
path.write_text(text,encoding='utf-8')
path=root/'work/pdf-candidates/4f53-figure-status.md'
text=path.read_text(encoding='utf-8')
text=text.replace('平面 Alice/Bob 光路及偏振球概念图仍待评估','平面 Alice/Bob 光路及偏振球概念图 batch46/pdf026–028 通过')
text=text.replace('Fig.6 的平面光路和偏振球概念图仍待评估，立体芯片/截面已筛查排除。独立面板文件共 8 块','Fig.6 的两段平面光路和偏振球概念图已通过，立体芯片/截面已筛查排除。20 个图号均有处理结论，未把局部通过算作整图通过。独立合格面板文件共 11 块')
text=text.replace('下一新图号 pdf026','下一新图号 pdf029')
path.write_text(text,encoding='utf-8')
path=root/'work/pdf-candidates/SELECTION.md'
text=path.read_text(encoding='utf-8')
text=text.replace('下一步评估 Fig.6 剩余平面光路和偏振球概念图；立体芯片、材质截面依用户最新意见排除。','Fig.6 的平面光路和偏振球概念图已在 batch46 通过；立体芯片、材质截面依用户最新意见排除。此篇 20 个图号已逐项处理，继续下一篇。')
text=text.replace('下一图号 `pdf026`','下一图号 `pdf029`')
text+='''\n\n### Fig.6 可用局部完成（batch46）\n\n- pdf026 Bob 两组偏振分析/四探测器光路、pdf027 Alice 激光输入链、pdf028 偏振调制球概念图，3/3 实际编译并视觉对比通过。地图背景及相邻立体芯片排除，结果只覆盖平面叠加层/球面局部。\n- 本篇 13 整图通过、Fig.8/6 可用局部通过且剩余部分排除、5 数据曲线排除；20 图号均有结论。不是全库完成。下一图号 pdf029，继续下一篇筛选。\n'''
path.write_text(text,encoding='utf-8')
stamp=datetime.now(ZoneInfo('Asia/Shanghai')).strftime('%Y-%m-%d %H:%M')
with (root/'community.md').open('a',encoding='utf-8') as stream:
    stream.write(f'''\n\n### [{stamp}] Codex（batch46 收口）\n- Fig.6 的 pdf026 Bob 平面分束/探测光路、pdf027 Alice 激光输入链、pdf028 偏振球概念示意 3/3 通过，视觉重试 1/0/1；原生自包含源码、300 ppi 编译、原图、实际比较、SOURCE.json/RESULTS.md 已齐，预览 work/PDF-PREVIEW-7.png。\n- 比较范围明确排除地图摄影背景，Alice 只取进入芯片前的平面链；立体芯片、层叠材质截面保持排除，batch45 失败/终止记录保留。没有把这些局部算作完整 Fig.6 通过。\n- 《Advances in Quantum Cryptography》20 图号全部逐项处理：13 整图通过、Fig.8/6 合适局部通过、其余局部筛查排除、5 数据曲线排除。逐图清单/选择记录/经验已同步；下一新图号 pdf029。\n- 下一步筛选下一篇论文，重点电路和清楚线描。总体目标仍未完成，本轮有具体进展，无阻塞。\n''')
print('Recorded three passes; 20 figure numbers accounted for; next pdf029.')
