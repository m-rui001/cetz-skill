from pathlib import Path
from datetime import datetime
from zoneinfo import ZoneInfo
from PIL import Image
import json
b=Path(__file__).parent
root=b.parents[1]
p=b/'SOURCE.json';meta=json.loads(p.read_text(encoding='utf-8'))
meta['figures'][0].update(status='pass',visual_retries=1,ppi=300)
p.write_text(json.dumps(meta,ensure_ascii=False,indent=2),encoding='utf-8')
im=Image.open(b/'png/pdf040-half-wave-multiplier-rectifiers.png').convert('RGB');im.thumbnail((1600,1100));im.save(root/'work/PDF-PREVIEW-15.png')
p=root/'work/EXPERIENCE.md';t=p.read_text(encoding='utf-8')
row='| 58 | `work/batch58` | 1/1（完整五组半波倍增整流器） | 2026-09-26 |'
if row not in t:
    lines=t.splitlines();positions=[i for i,line in enumerate(lines) if line.startswith('| ') and '`work/batch' in line]
    lines.insert(max(positions)+1,row);t='\n'.join(lines)+'\n'
t+='''

## batch58：斜向器件局部坐标与中性点跨线（Codex）

- 斜向二极管按导线方向构造。取起终点差向量归一化为 u，法向量为 (-u_y,u_x)，三角形的尖端沿 u、两底角沿法向量、横杆也沿法向量。本批 CW 三角支路用同一个局部坐标函数画上行和下行器件，保持位置和方向一致。
- 先量符号大小再套 helper：初稿复用较小二极管，整图看起来偏细。修正为接近原图的三角形/横杆尺寸，水平、竖直及斜向分别保留同样的视觉大小；不能因为拓扑正确就跳过形状比对。
- 中性点与跨线要分别登记：Fig.13 (c) 左输入回接线穿过中性导线，交叉处无节点且有小弧；真正中性输出为实心点，而上/下输出是空心端口。不要把所有“端口”统一成空心圆，也不要给非连接交叉补点。
- Neutral/Point 标签位于中性线两侧，直接居中会压住导线。按原图分两段定位，小字号只用于这一局部注释，不能挪走关键线段来迁就标签。
- 输入小符号的方波折线也有方向：高/低段和首尾竖线应看原图，不用随意画一个方波代替；(c) 的符号下移 11 个源坐标单位，保证它与输入端口间的原空白。
- 通用级联图的省略号、奇/偶标签、黄色区域与输出公式均是完整图的组成部分。本批保留所有这些元素，1/1 整图通过、视觉重试 1，不把面板数重复累计。
'''
p.write_text(t,encoding='utf-8')
p=root/'work/pdf-candidates/8da2-converters/STATUS.md';t=p.read_text(encoding='utf-8')
t=t.replace('当前 Fig.1–5、7–12 十一幅完整图通过（batch47/49/50/53/54/55/57），Fig.6 定量图表排除，其余继续处理。','当前 Fig.1–5、7–13 十二幅完整图通过（batch47/49/50/53/54/55/57/58），Fig.6 定量图表排除，其余继续处理。')
t=t.replace('| 13 | 14 | 半波倍增整流器，待转绘 |','| 13 | 14 | batch58/pdf040 完整五面板通过，视觉重试 1 |')
t=t.replace('下一步 Fig.13 完整半波倍增整流器，再继续 Fig.14 等。新图号从 pdf040 起','下一步 Fig.14 完整六组全波倍增整流器，再继续 Fig.15 等。新图号从 pdf041 起')
p.write_text(t,encoding='utf-8')
with (root/'work/pdf-candidates/SELECTION.md').open('a',encoding='utf-8') as f:
    f.write('\n\n### 8da22c007a Fig.13 完整通过\n\n- batch58/pdf040：PDF14 Fig.13 全部五组半波倍增整流器，含中性点、斜向二极管、通用级联省略号/奇偶标记/色块/公式。1/1，通过，视觉重试 1。下一步同页 Fig.14 六组全波电路，pdf041 起。\n')
stamp=datetime.now(ZoneInfo('Asia/Shanghai')).strftime('%Y-%m-%d %H:%M')
with (root/'community.md').open('a',encoding='utf-8') as f:
    f.write(f'''\n\n### [{stamp}] Codex（batch58 收口；经验已追加）
- pdf040 Fig.13 完整五组半波倍增整流器，1/1 整图通过、视觉重试 1；器件/端口/接地、斜向二极管、中性点非连接跨线、输入符号、级联省略号、奇偶标记、输出公式和高亮全保留。原生自包含 CeTZ、原图、300 ppi PNG、最终实际比较、SOURCE.json/RESULTS.md 已齐；预览 work/PDF-PREVIEW-15.png。
- 已追加 EXPERIENCE.md batch58：导线局部坐标下的斜向器件、二极管尺寸、实心中性点与空心端口、Neutral/Point 分置、方波折线/输入符号定位、完整级联元素及整图计数。初稿与最终稿均实际查看。
- 本篇 Fig.1–5、7–13 十二幅完整通过，Fig.6/34 定量图排除；下一步 Fig.14 完整六组全波倍增整流器，pdf041 起。新批号先核对三方日志/目录并确认独占创建。总体目标未完成，本轮为具体进展，无阻塞。
''')
print('Recorded batch58 1/1 pass, preview, lessons and shared status.')
