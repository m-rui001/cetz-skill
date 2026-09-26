from pathlib import Path
from datetime import datetime
from zoneinfo import ZoneInfo
from PIL import Image, ImageDraw
import json

batch=Path(__file__).parent
root=batch.parents[1]
path=batch/'SOURCE.json'
meta=json.loads(path.read_text(encoding='utf-8'))
panels=[]
for entry in meta['figures']:
    entry.update(status='pass',visual_retries=2,ppi=300)
    im=Image.open(batch/f"png/{entry['id']}.png").convert('RGB')
    im.thumbnail((650,1470))
    panels.append((entry['id'],im))
path.write_text(json.dumps(meta,ensure_ascii=False,indent=2),encoding='utf-8')
preview=Image.new('RGB',(1360,max(im.height for _,im in panels)+70),'white')
pen=ImageDraw.Draw(preview)
for i,(name,im) in enumerate(panels):
    x=20+i*680
    pen.text((x,12),name,fill='black');preview.paste(im,(x,40))
preview.save(root/'work/PDF-PREVIEW-9.png')
path=root/'work/EXPERIENCE.md'
text=path.read_text(encoding='utf-8')
anchor='| 47 | `work/batch47` | 2/2（升压变换器分类树、完整四组隔离结构） | 2026-09-26 |'
row='| 49 | `work/batch49` | 2/2（完整单向/双向与电压/电流馈电结构） | 2026-09-26 |'
if row not in text:text=text.replace(anchor,anchor+'\n'+row)
text+='''\n\n## batch49：绕组、漏感、断口与并发批号（Codex）\n\n- 绕组不能给所有场景固定的上下引线余量。原图紧凑全桥的绕组占满两端之间的高度，固定留 7px 上下直线会让四圈绕组过密；用 `lead` 参数区分总线框图和详细电路。调整贝塞尔横向控制量后，绕组弧与双磁芯之间保持空隙。\n- 漏感 L_k 与普通输入电感不是同一尺寸：本批普通四圈电感 pitch=11、depth=12，漏感只有两三圈、pitch=6–7、depth=4。复用函数必须允许各项独立变化，否则漏感会显得与主电感一样大，挤到匝比标签。\n- MOSFET 体二极管已有闭合侧支路，调用独立二极管函数时应关闭默认外部引线，避免上下多出尾巴。理想开关需要保留断口，不能让斜刃碰到另一固定接点。\n- 交叉不是连接：全桥两条跨桥输出线与桥臂相交时用小跨线弧，交点不加实心点；实际接点才加点。完整比对之外放大这部分逐条核对。\n- 有些图注与图内编号不一致：Fig.4 的图注只列 (a)–(c)，但图内还有 (d) 辅助变压器。必须同时看实际图面，保留所有面板。\n- 共享批号检查和目录创建之间存在并发窗口。本轮 `mkdir(exist_ok=False)` 已因 batch48 被占用失败，却误执行了后续写入。正确顺序是检查命令返回码，任何创建失败立即停止所有依赖操作，先重新选号并独占创建，再写源码。不能让后续编译成功掩盖前置失败。\n- 修复只移动可明确归属自己的文件，逐项验证源/目标在指定目录内，其他前缀和工具文件保持原处；最终文件须从新目录重新编译。本批移至 batch49，batch48 属 Agent-C。\n- 本批两图均经过 2 次视觉重试后通过。字体不要求相同，但不能借字体宽容忽略器件结构或连接错误。\n'''
path.write_text(text,encoding='utf-8')
path=root/'work/pdf-candidates/8da2-converters/STATUS.md'
text=path.read_text(encoding='utf-8')
text=text.replace('当前 Fig.1/2 两幅完整图通过（batch47），其余继续处理。','当前 Fig.1–4 四幅完整图通过（batch47/49），其余继续处理。')
text=text.replace('| 3 | 5 | 单向/双向四组电路，待转绘 |','| 3 | 5 | batch49/pdf031 完整四组框图/电路通过，视觉重试 2 |')
text=text.replace('| 4 | 6 | 电压/电流馈电结构，待转绘 |','| 4 | 6 | batch49/pdf032 完整 (a)–(d) 结构通过，视觉重试 2 |')
text=text.replace('下一步 Fig.3 单向/双向四组电路，再继续 Fig.4。新图号从 pdf031 起','下一步 Fig.5 谐振/软开关网络，再继续其余电路。新图号从 pdf033 起')
path.write_text(text,encoding='utf-8')
with (root/'work/pdf-candidates/SELECTION.md').open('a',encoding='utf-8') as stream:
    stream.write('\n\n### 8da22c007a Fig.3/4 完整通过\n\n- PDF5 Fig.3 单向/双向变换器（pdf031）、PDF6 Fig.4 電压/电流馈电含辅助变压器 (d)（pdf032），batch49 2/2 通过，各 2 次视觉重试。batch48 为 Agent-C，本批 PDF 文件已移出并重新编译。\n- 下一步 PDF7 Fig.5 谐振/软开关网络，pdf033 起。完整 34 图号继续逐项处理。\n')
stamp=datetime.now(ZoneInfo('Asia/Shanghai')).strftime('%Y-%m-%d %H:%M')
with (root/'community.md').open('a',encoding='utf-8') as stream:
    stream.write(f'''\n\n### [{stamp}] Codex（batch49 收口；已总结经验）\n- pdf031 Fig.3 完整四组单向/双向框图与电路、pdf032 Fig.4 完整电压/电流馈电结构（含图注未列的 d），2/2 通过，各 2 次视觉重试；全部从 batch49 路径实际编译 300 ppi 并查看最终比较。原图/自包含 CeTZ/PNG/比较/SOURCE.json/RESULTS.md 已齐，预览 work/PDF-PREVIEW-9.png。\n- 主人提醒“记得总结经验”，已按批追加 work/EXPERIENCE.md batch49：绕组引线余量、独立漏感尺寸、体二极管尾线、非连接跨线、图注漏面板、原子目录创建失败必须停止依赖写入及安全移出冲突批。\n- 升压综述 Fig.1–4 全部完整通过，下一步 Fig.5 谐振/软开关网络，从 pdf033 起。新批号先核对共享日志及实际目录。总体目标仍未完成，本轮有具体进展，无阻塞。\n''')
print('Recorded two passes and detailed lessons in EXPERIENCE.md.')
