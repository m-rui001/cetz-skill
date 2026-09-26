from pathlib import Path
from datetime import datetime
from zoneinfo import ZoneInfo
import json

root=Path(__file__).resolve().parents[2]
batch=Path(__file__).parent
stamp=datetime.now(ZoneInfo('Asia/Shanghai')).strftime('%Y-%m-%d %H:%M')
manifest=json.loads((batch/'SOURCE.json').read_text(encoding='utf-8'))
manifest['figures'][0]['status']='abandoned_after_visual_comparison'
manifest['figures'][1]['status']='abandoned_after_visual_comparison'
manifest['figures'][2]['status']='draft_stopped_before_visual_comparison'
manifest['screening_exclusions'].append({'panel':'remaining perspective chips and layered sections in (2), (3)c/d/f, (4)b',
    'reason':'user identified this class of figure as unsuitable for CeTZ; material, perspective and fine waveguide detail are essential to matching the source'})
manifest['remaining_panels']=['(2)d polarization sphere concept diagram','(4) Alice/Bob flat optical system diagrams (xref1119/1113)']
(batch/'SOURCE.json').write_text(json.dumps(manifest,ensure_ascii=False,indent=2),encoding='utf-8')
path=root/'work/EXPERIENCE.md'
text=path.read_text(encoding='utf-8')
anchor='| 44 | `work/batch44` | 2/2（Fig.4/10 完整组合版，复用面板，不重复计新转绘） | 2026-09-26 |'
row='| 45 | `work/batch45` | 0/2，芯片效果图视觉尝试 2 张后放弃；另 1 张草稿终止 | 2026-09-26 |'
if row not in text:text=text.replace(anchor,anchor+'\n'+row)
text+='''\n\n## batch45：先判断 CeTZ 是否适合原图表达\n\n- 用户指出立体芯片效果图不适合 CeTZ；其材质、透视层次和密集微细器件不能只靠框图拓扑衡量相似度。后续在筛选阶段跳过这类图，优先光路框图、几何线描、电路与流程。\n- pdf023/pdf024 虽已编译，实际比较仍看到器件轮廓、微细路径和材质明显不同，判定放弃；不能因为“能编译”或“主要组件齐全”直接通过。pdf025 只有未完成草稿，未进入视觉比较，单独记账。\n- 用户字体宽容没有降低图形相似度要求。依赖原图材质表达的图不应先改成简化示意，再按简化效果验收。\n- 复合图仍逐部位筛选：Fig.6 的照片和立体芯片排除，平面 Alice/Bob 光路及偏振球概念图保留另行评估。\n'''
path.write_text(text,encoding='utf-8')
status=root/'work/pdf-candidates/4f53-figure-status.md'
text=status.read_text(encoding='utf-8')
text=text.replace('| 6 | 40 | 已放大筛查；尚待逐面板处理。含光路/芯片示意、截面示意、显微照片和地图照片；不能把整张当照片排除 |',
    '| 6 | 40 | 按用户最新意见筛查排除立体芯片/材质截面及照片；batch45/pdf023、024 实际视觉尝试后放弃，pdf025 草稿终止。平面 Alice/Bob 光路及偏振球概念图仍待评估 |')
text=text.replace('Fig.6 示意部分仍待转绘。','Fig.6 的平面光路和偏振球概念图仍待评估，立体芯片/截面已筛查排除。')
text=text.replace('下一新图号 pdf023。','pdf023–025 保留失败或终止记录，下一新图号 pdf026。')
status.write_text(text,encoding='utf-8')
selection=root/'work/pdf-candidates/SELECTION.md'
text=selection.read_text(encoding='utf-8')
text=text.replace('下一步继续 Fig.6 的示意部分。','下一步评估 Fig.6 剩余平面光路和偏振球概念图；立体芯片、材质截面依用户最新意见排除。')
text=text.replace('下一图号 `pdf023`','下一图号 `pdf026`')
text+='''\n\n### Fig.6 芯片图适用性修正（batch45）\n\n- 用户指出这类立体芯片图不适合 CeTZ。pdf023/024 原生草稿经编译和实际视觉比较后放弃，pdf025 草稿停止，0 通过。保留原始图片与草稿，详见 batch45/RESULTS.md。\n- 其他密集芯片透视图、层叠材质截面以及照片筛查排除；平面系统光路 xref1113/1119 和偏振球概念图可继续评估。\n'''
selection.write_text(text,encoding='utf-8')
with (root/'community.md').open('a',encoding='utf-8') as stream:
    stream.write(f'''\n\n### [{stamp}] Codex（batch45 收口；按主人意见调整筛图）\n- 主人指出“这种图就不适合 Cetz”：停止立体芯片、依赖材质/透视的层叠截面和密集微细波导效果图复刻。以后优先几何线描、光路框图、电路和流程图；数据曲线继续排除，字体清晰即可，图形仍需接近。请 Agent-C 同步采用此筛图口径。\n- batch45 没有通过项：pdf023/024 已实际编译和目视比对，微细器件形状、路径与材质相似度不足，2 次尝试均放弃继续复刻；pdf025 未完成草稿停止，无 PNG，不计视觉尝试。原图、草稿与现有比较保留，RESULTS.md/SOURCE.json/EXPERIENCE.md 已更新。\n- Fig.6 其余立体芯片/材质截面和照片筛查排除，平面 Alice/Bob 光路及偏振球概念图仍可评估。逐图清单已同步；下一新图号 pdf026。此前 batch44 合格结果不变。\n- 总体目标仍未完成，继续从适合 CeTZ 的图型选图；此条记录具体进展与筛选修正，无阻塞。\n''')
print('Recorded user screening preference, abandoned comparisons and remaining flat diagrams.')
