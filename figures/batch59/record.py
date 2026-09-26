from pathlib import Path
from datetime import datetime
from zoneinfo import ZoneInfo
from PIL import Image
import json
b=Path(__file__).parent
root=b.parents[1]
p=b/'SOURCE.json'; meta=json.loads(p.read_text(encoding='utf-8'))
meta['figures'][0].update(status='pass',visual_retries=1,ppi=300)
p.write_text(json.dumps(meta,ensure_ascii=False,indent=2),encoding='utf-8')
im=Image.open(b/'png/pdf041-full-wave-multiplier-rectifiers.png').convert('RGB');im.thumbnail((1600,1100));im.save(root/'work/PDF-PREVIEW-16.png')
(b/'RESULTS.md').write_text('''# batch59 — Fig.14 完整全波倍增整流器

来源：Forouzesh 等，Step-Up DC–DC Converters，DOI 10.1109/TPEL.2017.2652318，PDF14。源文件只读，裁切见 SOURCE.json。

| 范围 | 自包含原生 CeTZ | 编译 | 最终实际目视结论 | 视觉重试 |
|---|---|---|---|---:|
| Fig.14 完整 (a)–(f) | typ/pdf041-full-wave-multiplier-rectifiers.typ | 300 ppi | 通过 | 1 |

1/1 整图通过，无放弃。保留 doubler、quadrupler、even group、tripler、quintupler、odd group 六面板，全部器件、空心端口、节点、接地、输入图标、非连接跨线、级联省略号、黄色分组和红蓝可选器件区。

初稿与修正后对照均实际查看。首版输出公式与相邻输入文字重叠，奇数组末级电容标签靠近红色可选器件；局部减小字号并调整位置后清晰分开，几何布局不变。字体允许与原文不同。最终 typ 不读取图像/SVG，不依赖其他批次文件；原图、PNG、cmp、元数据和生成器齐全。预览 work/PDF-PREVIEW-16.png。

下一步 PDF15 Fig.15/16，pdf042 起。
''',encoding='utf-8')
p=root/'work/EXPERIENCE.md';t=p.read_text(encoding='utf-8')
row='| 59 | `work/batch59` | 1/1（完整六组全波倍增整流器） | 2026-09-26 |'
if row not in t:
    lines=t.splitlines();positions=[i for i,line in enumerate(lines) if line.startswith('| ') and '`work/batch' in line]
    lines.insert(max(positions)+1,row);t='\n'.join(lines)+'\n'
if '## batch59：' not in t:
    t+='''

## batch59：通用电路中的可选器件和跨线（Codex）

- 通用奇数组面板的红蓝区域是成对的替代器件示意，不是一个固定级数的实接电路。保留原来的断开边界、横/竖器件和两组十字省略号，不擅自把它们连接成一条新支路。
- 偶数组里不同电容接到两条交错母线。逐条记录节点与跨线弧，分别处理上、下回接路径；不能把“视觉上交叉”默认画成电气连接。
- 六面板的标签要在整图中检查。单看一面板没问题的输出公式，可能撞上邻面板 Vin。本批局部用 7pt 输出公式和 6.5pt 末级电容标签，少量平移，修正重叠；不移动电路去迁就字体。
- 黑白平面电路适合 CeTZ，即使含少量高亮和波形图标也可原生构造。这里的正弦/方波小图标表示输入类型，不是定量数据曲线。
- 编译返回运行 session 时，必须等同一进程结束才生成比较图。旧 PNG 或尚未完成的 compare 不作为新版本证据。本批首稿和最终稿均有成功编译后的实际目视对照，1/1 完整图通过，视觉重试 1。
'''
p.write_text(t,encoding='utf-8')
p=root/'work/pdf-candidates/8da2-converters/STATUS.md';t=p.read_text(encoding='utf-8')
t=t.replace('当前 Fig.1–5、7–13 十二幅完整图通过（batch47/49/50/53/54/55/57/58）','当前 Fig.1–5、7–14 十三幅完整图通过（batch47/49/50/53/54/55/57/58/59）')
t=t.replace('| 14 | 14 | 全波倍增整流器，待转绘 |','| 14 | 14 | batch59/pdf041 完整六面板通过，视觉重试 1 |')
t=t.replace('下一步 Fig.14 完整六组全波倍增整流器，再继续 Fig.15 等。新图号从 pdf041 起','下一步 Fig.15 电压提升单元和 Fig.16 有源开关电感框图。新图号从 pdf042 起')
p.write_text(t,encoding='utf-8')
with (root/'work/pdf-candidates/SELECTION.md').open('a',encoding='utf-8') as f:
    f.write('\n\n### 8da22c007a Fig.14 完整通过\n\n- batch59/pdf041：PDF14 全部六组全波倍增整流器，含奇/偶组、级联省略号、非连接跨线、黄底分组及红蓝可选器件。1/1 完整通过，视觉重试 1。下一步 PDF15 Fig.15/16，pdf042 起。\n')
stamp=datetime.now(ZoneInfo('Asia/Shanghai')).strftime('%Y-%m-%d %H:%M')
with (root/'community.md').open('a',encoding='utf-8') as f:
    f.write(f'\n\n### [{stamp}] Codex（batch59 收口，经验已追加）\n- pdf041 Fig.14 全部六组全波倍增整流器：1/1 完整图通过、视觉重试 1。节点/跨线/器件方向、全部端口/公式/图标、奇偶省略号、黄底及红蓝可选器件已保留。自包含 CeTZ、只读原图、300 ppi 编译图、实际比较、SOURCE.json/RESULTS.md 齐；预览 work/PDF-PREVIEW-16.png。\n- EXPERIENCE.md 已追加可选器件与通用结构、交错母线跨线、跨面板标签检查、输入图标与定量曲线区别、等待编译完成后才比较的经验。\n- 本篇十三幅完整图通过，2 个定量图号排除，余 19 个；下一步 PDF15 Fig.15/16，pdf042 起。总体持续目标未完成，新批先核对日志/目录并确认原子创建。\n')
print('Recorded batch59.')
