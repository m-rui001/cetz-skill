from pathlib import Path
from datetime import datetime
from zoneinfo import ZoneInfo
from PIL import Image
import json

batch=Path(__file__).parent
root=batch.parents[1]
path=batch/'SOURCE.json'
meta=json.loads(path.read_text(encoding='utf-8'))
meta['figures'][0].update(status='pass',visual_retries=2,ppi=300)
path.write_text(json.dumps(meta,ensure_ascii=False,indent=2),encoding='utf-8')
im=Image.open(batch/'png/pdf033-soft-switching-networks.png').convert('RGB')
im.thumbnail((1500,1000))
im.save(root/'work/PDF-PREVIEW-10.png')
path=root/'work/EXPERIENCE.md'
text=path.read_text(encoding='utf-8')
anchor='| 49 | `work/batch49` | 2/2（完整单向/双向与电压/电流馈电结构） | 2026-09-26 |'
row='| 50 | `work/batch50` | 1/1（完整谐振／软开关网络，全部四面板） | 2026-09-26 |'
if row not in text:text=text.replace(anchor,anchor+'\n'+row)
text+='''\n\n## batch50：换流支线位置与小磁性符号（Codex）\n\n- 电气节点相同不代表绘图位置可以换：换流电容应回到源图的固定触点，若直接回到桥臂中点，会画出多余长支线，并增加与输出线的交叉。先确定器件接触点坐标，再写连线。\n- 细小磁性器件要放大原图：本图辅助电路框中第一个符号是两个同向绕组、各自磁芯，第二个才是相对绕组和共用磁芯的变压器。复用一个图标会使第一项方向和磁芯数量都不符。\n- 电容 helper 分别开放水平/垂直引线长度。小单元的短支路若调用长引线，会产生回折或穿越；ZVT 的水平 C_r 单独设置短引线，避免向左绕回。\n- 端口字母放在元件行稍外侧：A 向左、A′ 向右，按源图区分定位；统一居中于空心端口会挤到 L_s/C_s。字体宽容不能作为文字重叠的理由。\n- Typst 数学下标相邻 s1/s2 会被当成变量，写 `s 1`/`s 2`，或需要正体时用引号；不要用未定义的连写变量。\n- 本批执行原子 mkdir 后先查看返回码，确认独占成功才生成依赖文件，避免重演 batch48 冲突。完整四面板 1/1 通过，视觉重试 2；实际比较后才记通过。\n'''
path.write_text(text,encoding='utf-8')
path=root/'work/pdf-candidates/8da2-converters/STATUS.md'
text=path.read_text(encoding='utf-8')
text=text.replace('当前 Fig.1–4 四幅完整图通过（batch47/49），其余继续处理。','当前 Fig.1–5 五幅完整图通过（batch47/49/50），Fig.6 定量图表排除，其余继续处理。')
text=text.replace('| 5 | 7 | 谐振网络与软开关单元，待转绘 |','| 5 | 7 | batch50/pdf033 完整四面板通过，视觉重试 2 |')
text=text.replace('| 6 | 8 | (b)/(c) 响应曲线/Bode 图按用户标准排除；(a) 极零点概念位置图需单独放大评估 |','| 6 | 8 | 已放大 (a)，数值坐标上的极零点/传递函数定量图表；与 (b)/(c) 响应/Bode 曲线一并按用户标准排除 |')
text=text.replace('下一步 Fig.5 谐振/软开关网络，再继续其余电路。新图号从 pdf033 起','下一步 Fig.7 完整最小相位升压电路组，再继续 Fig.8 等。新图号从 pdf034 起')
path.write_text(text,encoding='utf-8')
with (root/'work/pdf-candidates/SELECTION.md').open('a',encoding='utf-8') as stream:
    stream.write('\n\n### 8da22c007a Fig.5 完整通过，Fig.6 完成筛查\n\n- PDF7 Fig.5 谐振/软开关网络全部四面板及小局部，batch50/pdf033，通过，2 次视觉重试。PDF8 Fig.6a 已实际放大，是数值坐标的定量极零点/传递函数示例，与响应/Bode 图一起排除，不计视觉尝试。\n- 下一步 PDF9 Fig.7 完整电路组，pdf034 起；完整 34 图号继续逐项处理。\n')
stamp=datetime.now(ZoneInfo('Asia/Shanghai')).strftime('%Y-%m-%d %H:%M')
with (root/'community.md').open('a',encoding='utf-8') as stream:
    stream.write(f'''\n\n### [{stamp}] Codex（batch50 收口；经验已追加）\n- pdf033 Fig.5 谐振/软开关网络完整 (a)–(d) 通过，1/1，视觉重试 2；六种谐振网络、六种开关单元、原/副边辅助电路及全部小框都保留。300 ppi 实际编译、原图、独立 CeTZ、最终比較、SOURCE.json/RESULTS.md 已齐，预览 work/PDF-PREVIEW-10.png。\n- 已追加 EXPERIENCE.md batch50：换流电容回接位置、小磁性符号的绕组/磁芯区别、水平/垂直引线参数、A/A′ 左右标签、数学 s1 下标和先确认原子 mkdir 成功。\n- Fig.6a 放大后归为数值坐标的定量极零点/传递函数图，与 b/c 曲线按主人标准一起排除。本篇 Fig.1–5 完整通过，下一步 Fig.7 全部电路，下一图号 pdf034。整体目标未完成，本轮为具体进展，无阻塞。\n''')
print('Recorded Fig.5 pass, Fig.6 screening and batch50 lessons.')
