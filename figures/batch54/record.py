from pathlib import Path
from datetime import datetime
from zoneinfo import ZoneInfo
from PIL import Image
import json
b=Path(__file__).parent
root=b.parents[1]
p=b/'SOURCE.json'
meta=json.loads(p.read_text(encoding='utf-8'))
meta['figures'][0].update(status='pass',visual_retries=1,ppi=300)
p.write_text(json.dumps(meta,ensure_ascii=False,indent=2),encoding='utf-8')
im=Image.open(b/'png/pdf036-charge-pump-circuits.png').convert('RGB')
im.thumbnail((1600,1100))
im.save(root/'work/PDF-PREVIEW-12.png')
p=root/'work/EXPERIENCE.md'
text=p.read_text(encoding='utf-8')
row='| 54 | `work/batch54` | 1/1（完整七组电荷泵／开关电容电路） | 2026-09-26 |'
if row not in text:
    lines=text.splitlines()
    positions=[i for i,line in enumerate(lines) if line.startswith('| ') and '`work/batch' in line]
    lines.insert(max(positions)+1,row)
    text='\n'.join(lines)+'\n'
text+='''

## batch54：开关相位、绝对引线终点与跨线方向（Codex）

- 开关外形随图而变：Fig.7 的杆向与 Fig.9 并不一致，不能只因为都叫开关就照搬 helper。先看活动杆接在哪侧、固定触点在哪侧，再选择水平或垂直符号；I/II 是相位标记，要逐个保留。
- 双位置开关用单独结构：Fig.9 (b) 的两个活动杆分别接到电容上/下端，另一位置各有空心触点；四触点和上下斜杆不能简化成两个普通开关。电线非连接跨过下方导线时也要保留弧。
- 引线长度与支路终点是两回事：短支路若调用固定长度开关，会先越过回接横线再折返，留下明显尾巴。垂直开关新增可选绝对 `bot` 坐标，将尾线直接收在实际回接点或接地符号处；(c)/(g) 去除了多余短竖线。
- 接地符号的横线必须与竖线实际相接。元件 helper 尾线加上支路延长线后，再核对最终端点，不能因只有一像素空隙就默认已连接；(c)/(d) 在实际渲染中补齐。
- 跨线弧属于哪条导线要按源图确认：本批 (b) 是竖向线绕过横向线，(f) 是横向线绕过电容返回线。只记“交叉处有弧”仍会画错方向；写连接表时同时记经过和被跨越的导线。
- 阶梯网络的高亮区域不是固定矩形：Fig.9 (e) 上部与下部黄色区相互错位，使用闭合原生点列保留阶梯边界；阴影输入端口也用灰色虚线/标签保留，不当作漏画。
- 本批完整七面板 1/1 通过，视觉重试 1；一次修正涵盖尾线与接地，不把编译参数错误算视觉重试，也不把面板数重复累计为图数。
'''
p.write_text(text,encoding='utf-8')
p=root/'work/pdf-candidates/8da2-converters/STATUS.md'
text=p.read_text(encoding='utf-8')
text=text.replace('当前 Fig.1–5、7、8 七幅完整图通过（batch47/49/50/53），Fig.6 定量图表排除，其余继续处理。','当前 Fig.1–5、7–9 八幅完整图通过（batch47/49/50/53/54），Fig.6 定量图表排除，其余继续处理。')
text=text.replace('| 9 | 11 | 电荷泵/开关电容电路，待转绘 |','| 9 | 11 | batch54/pdf036 完整七面板通过，视觉重试 1 |')
text=text.replace('下一步 Fig.9 七组电荷泵/开关电容电路，再继续 Fig.10 等。新图号从 pdf036 起','下一步 Fig.10 五组开关电容 DC–DC 电路，再继续 Fig.11 等。新图号从 pdf037 起')
p.write_text(text,encoding='utf-8')
with (root/'work/pdf-candidates/SELECTION.md').open('a',encoding='utf-8') as f:
    f.write('\n\n### 8da22c007a Fig.9 完整通过\n\n- batch54/pdf036：PDF11 Fig.9 全七组电荷泵/开关电容电路，通过，视觉重试 1。已保留全部相位、触点、接地、跨线及高亮区域。下一步同页 Fig.10 五组电路，pdf037 起。\n')
stamp=datetime.now(ZoneInfo('Asia/Shanghai')).strftime('%Y-%m-%d %H:%M')
with (root/'community.md').open('a',encoding='utf-8') as f:
    f.write(f'''\n\n### [{stamp}] Codex（batch54 收口；经验已追加）
- pdf036 Fig.9 完整七组电荷泵/开关电容电路，1/1 通过，视觉重试 1；七面板、I/II 相位、选择触点、接地、跨线、高亮和灰色端口全部保留。原图、原生自包含 CeTZ、300 ppi PNG、最终实际比较、SOURCE.json/RESULTS.md 已齐；预览 work/PDF-PREVIEW-12.png。
- 已追加 EXPERIENCE.md batch54：开关活动杆方向、双位置四触点、短支路绝对尾线终点、接地一像素空隙、跨线所属导线和阶梯高亮形状。字体允许差异，几何和连接继续按源图。
- 本篇 Fig.1–5、7–9 八幅完整通过，Fig.6/34 定量图排除。下一步 Fig.10 完整五电路，从 pdf037 起；新批号先查三方共享日志和目录、确认独占创建成功再写入。整体目标仍未完成，本轮为具体进展，无阻塞。
''')
print('Recorded batch54 1/1, lessons, source/status, preview and shared log.')
