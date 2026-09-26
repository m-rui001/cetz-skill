from pathlib import Path
from datetime import datetime
from zoneinfo import ZoneInfo
from PIL import Image,ImageDraw
import json
b=Path(__file__).parent;root=b.parents[1]
p=b/'SOURCE.json';meta=json.loads(p.read_text(encoding='utf-8'))
for q in meta['figures']:q.update(status='pass',visual_retries=2,ppi=300)
p.write_text(json.dumps(meta,ensure_ascii=False,indent=2),encoding='utf-8')
(b/'RESULTS.md').write_text('''# batch67 — 电压提升单元及有源开关电感位置

来源：Forouzesh 等，Step-Up DC–DC Converters，DOI 10.1109/TPEL.2017.2652318，PDF15。来源只读，完整裁切见 SOURCE.json。

| 图与范围 | 独立原生 CeTZ | 编译 | 最终实际目视结论 | 视觉重试 |
|---|---|---|---|---:|
| Fig.15 总结构及四种单元 | typ/pdf042-voltage-lift-cells.typ | 300 ppi | 通过 | 2 |
| Fig.16 完整有源开关电感框图 | typ/pdf043-active-switched-inductor-placement.typ | 300 ppi | 通过 | 2 |

2/2 完整图通过，无放弃。Fig.15 保留上方总结构、Basic SL、Elementary-Lift、Self-Lift、Double Self-Lift 四种单元，以及全部元件、节点、开关、灰色漏感、端口和原图重复的 (a) 编号。Fig.16 保留 A/B/A′/B′ 四端口、输入电源、输出二极管、电容和负载。

初稿、第一次修正和最终稿均在成功编译后实际查看原图/渲染比较。Fig.15 第一轮修正二极管引线 1–4 个源坐标单位的缺口，并缩短灰色 Lr 的节距、补足尾导线；第二轮调整 S0 标签，保持开关斜线后的空白。两图输出侧 C_o/R_o 标签局部减小字号，Fig.16 第二轮进一步处理电容与电阻间的窄标签空间。

原图 src、源码 typ、300 ppi PNG、cmp、生成器、元数据齐全；最终 typ 不读取任何图像/SVG，不依赖其他批次。字体按用户要求允许差异。预览 work/PDF-PREVIEW-17.png。下一步 PDF16 Fig.17/18，pdf044 起。
''',encoding='utf-8')
sheet=Image.new('RGB',(1700,1180),'white');d=ImageDraw.Draw(sheet)
for q,xy,limit in [(meta['figures'][0],(20,45),(820,1100)),(meta['figures'][1],(880,45),(800,600))]:
    im=Image.open(b/'png'/ (q['id']+'.png')).convert('RGB');im.thumbnail(limit);sheet.paste(im,xy)
    d.text((xy[0],15),f'Fig.{q["figure_number"]} - native CeTZ',fill='black')
sheet.save(root/'work/PDF-PREVIEW-17.png')
p=root/'work/EXPERIENCE.md';t=p.read_text(encoding='utf-8')
row='| 67 | `work/batch67` | 2/2（完整电压提升单元及 A-SL 位置图） | 2026-09-26 |'
if row not in t:
    lines=t.splitlines();positions=[i for i,l in enumerate(lines) if l.startswith('| ') and '`work/batch' in l];lines.insert(max(positions)+1,row);t='\n'.join(lines)+'\n'
if '## batch67：' not in t:
    t+='''

## batch67：器件引线与窄标签区（Codex）

- 画电路时要检查导线终点和 helper 实际引线端点。本批基本单元的一处 1 单位缺口、自提升支路的 3/4 单位缺口在整体图中容易漏看；按二极管 y±12 明确接齐。电路不能只在拓扑上看起来通顺。
- 灰色 Lr 不是普通 L 的缩淡版：四匝的节距更短，末端还留一小段黑色导线。单独设 pitch=5，普通线圈 pitch=7，保持线圈数与原长宽。
- 狭窄输出支路中，数学标签的斜体和下标会比原书直立字体宽。优先局部字号与位置调整，保留电容和电阻之间的原间距，不把整图字体缩小。
- 开关标签必须留出斜线尖端的空白；S0 在第一次修正稿仍碰到开关斜线，第二次局部移开后再实际查看通过。
- Fig.15 上方总图与 Basic 单元都标 (a)，正文图注也有编号不一致。转换按可见原图保留，不自行修正文献编号；总结构和四个单元作为一张完整图统计。
- 本批两图均自包含原生 CeTZ，300 ppi 实际对照通过，各视觉重试 2。过程缺口修复、局部字体差异如实记入 RESULTS.md。
'''
p.write_text(t,encoding='utf-8')
p=root/'work/pdf-candidates/8da2-converters/STATUS.md';t=p.read_text(encoding='utf-8')
t=t.replace('当前 Fig.1–5、7–14 十三幅完整图通过（batch47/49/50/53/54/55/57/58/59）','当前 Fig.1–5、7–16 十五幅完整图通过（batch47/49/50/53/54/55/57/58/59/67）')
t=t.replace('| 15 | 15 | 电压提升单元，待转绘 |','| 15 | 15 | batch67/pdf042 完整总结构和四单元通过，视觉重试 2 |')
t=t.replace('| 16 | 15 | 有源开关电感框图，待转绘 |','| 16 | 15 | batch67/pdf043 完整框图通过，视觉重试 2 |')
t=t.replace('下一步 Fig.15 电压提升单元和 Fig.16 有源开关电感框图。新图号从 pdf042 起','下一步 PDF16 Fig.17 有源开关电感电路和 Fig.18 开关耦合电感电路。新图号从 pdf044 起')
p.write_text(t,encoding='utf-8')
with (root/'work/pdf-candidates/SELECTION.md').open('a',encoding='utf-8') as f:
    f.write('\n\n### 8da22c007a Fig.15/16 完整通过\n\n- batch67/pdf042–043：电压提升总结构及四单元、A-SL 四端口总结构；2/2 完整通过，各视觉重试 2。下一步 PDF16 Fig.17/18，pdf044 起。\n')
stamp=datetime.now(ZoneInfo('Asia/Shanghai')).strftime('%Y-%m-%d %H:%M')
with (root/'community.md').open('a',encoding='utf-8') as f:
    f.write(f'\n\n### [{stamp}] Codex（batch67 收口；经验已追加）\n- pdf042 Fig.15 总结构加四单元、pdf043 Fig.16 A-SL 四端口框图，2/2 完整通过，各视觉重试 2。原图/自包含 CeTZ/300 ppi PNG/实际 cmp/SOURCE/RESULTS 齐；预览 work/PDF-PREVIEW-17.png。\n- 修正器件引线微小断缝、灰色 Lr 节距和尾导线、输出侧 C_o/R_o 窄空间与 S0 开关标签；保留可见原图重复 (a) 编号。EXPERIENCE.md batch67 已总结，其他进程历史保留。\n- 本轮 PDF 新增 Fig.14/15/16 三幅完整图，本篇累计 15 幅通过、2 个定量图号排除、17 幅待处理。下一步 PDF16 Fig.17/18，pdf044 起；批号先查日志/目录，不能假设 batch68 空闲。持续目标未完成，无阻塞。\n')
print('Recorded batch67, 2/2 pass; source paper 15 passed, 2 excluded, 17 remaining.')
