from pathlib import Path
from datetime import datetime
from zoneinfo import ZoneInfo
from PIL import Image, ImageDraw
import json, re
b=Path(__file__).parent
root=b.parents[1]
stamp=datetime.now(ZoneInfo('Asia/Shanghai')).strftime('%Y-%m-%d %H:%M')
meta=json.loads((b/'SOURCE.json').read_text(encoding='utf-8'))
meta['figures'][0].update(status='pass',visual_retries=1,ppi=300)
(b/'SOURCE.json').write_text(json.dumps(meta,ensure_ascii=False,indent=2),encoding='utf-8')
im=Image.open(b/'png/pdf037-switched-capacitor-converters.png').convert('RGB')
im.thumbnail((1600,1100));im.save(root/'work/PDF-PREVIEW-13.png')

repairs={47:{'pdf030-converter-isolation-structures':3},49:{'pdf031-directional-converters':3,'pdf032-voltage-current-fed':3},50:{'pdf033-soft-switching-networks':3},53:{'pdf034-minimum-phase-boost':2},54:{'pdf036-charge-pump-circuits':2}}
for n,items in repairs.items():
    p=root/f'work/batch{n}/SOURCE.json'
    data=json.loads(p.read_text(encoding='utf-8'))
    for item in data['figures']:
        if item['id'] in items:
            item.update(visual_retries=items[item['id']],status='pass',capacitor_junction_review=stamp)
    p.write_text(json.dumps(data,ensure_ascii=False,indent=2),encoding='utf-8')
    p=root/f'work/batch{n}/RESULTS.md'
    t=p.read_text(encoding='utf-8')
    lines=t.splitlines()
    for i,line in enumerate(lines):
        if line.startswith('|'):
            for name,value in items.items():
                if name in line:
                    # Preserve table text, replace only the numeric retry cell.
                    lines[i]=re.sub(r'\|\s*[12]\s*\|',f'| {value} |',line)
    t='\n'.join(lines)+'\n'
    t+=f'\n## 曲极板连接补正（{stamp}，Codex / batch55 回查）\n\n'
    t+='此前下引线端点与 Bézier 曲极板中点之间有细小空隙，现按实际中点补齐；已重新 300 ppi 编译、重建比较并实际查看，保持通过。通过图数不增加。\n\n'
    t+='当前累计视觉重试：'+ '、'.join(f'{name} = {value}' for name,value in items.items())+'。本章更新后的 SOURCE.json 和当前比较图为最终证据，早期收口叙述的次数属于历史。\n'
    p.write_text(t,encoding='utf-8')

# Refresh all affected summary previews, preserving their original item groupings.
groups={8:[(47,'pdf029-converter-classification'),(47,'pdf030-converter-isolation-structures')],9:[(49,'pdf031-directional-converters'),(49,'pdf032-voltage-current-fed')],10:[(50,'pdf033-soft-switching-networks')],11:[(53,'pdf034-minimum-phase-boost'),(53,'pdf035-voltage-boost-tree')],12:[(54,'pdf036-charge-pump-circuits')]}
for number,items in groups.items():
    images=[]
    for n,name in items:
        im=Image.open(root/f'work/batch{n}/png/{name}.png').convert('RGB')
        im.thumbnail((1500,1100));images.append(im)
    sheet=Image.new('RGB',(1540,sum(im.height for im in images)+45*len(images)+20),'white')
    draw=ImageDraw.Draw(sheet);y=10
    for (_,name),im in zip(items,images):
        draw.text((20,y),name,fill='black');sheet.paste(im,((1540-im.width)//2,y+25));y+=im.height+45
    sheet.save(root/f'work/PDF-PREVIEW-{number}.png')

p=root/'work/EXPERIENCE.md';t=p.read_text(encoding='utf-8')
row='| 55 | `work/batch55` | 1/1（完整五组开关电容变换器；另补正六张已通过图） | 2026-09-26 |'
if row not in t:
    lines=t.splitlines();positions=[i for i,line in enumerate(lines) if line.startswith('| ') and '`work/batch' in line]
    lines.insert(max(positions)+1,row);t='\n'.join(lines)+'\n'
t+='''

## batch55：曲极板连接点、方向参数与历史产物回查（Codex）

- 曲极板引线应接在实际曲线中点，不能按肉眼估计一个尾线起点。对称三次 Bézier 在 t=0.5 的权重为 1/8、3/8、3/8、1/8；端点 y+10、控制点 y+3 时，中点为 y+4.75。垂直尾线从 y+4.75 起，水平弯板同样计算 x 中点，避免留下细小断线。
- 新经验要回查旧产物：发现前述问题后，补正 batch47/pdf030、batch49/pdf031/pdf032、batch50/pdf033、batch53/pdf034、batch54/pdf036 共六张同类图。重新实际编译、比较后保持通过，不重复计新图；额外各记一次视觉补正，更新清单、SOURCE.json、RESULTS.md 和预览。
- 二极管默认方向不能覆盖所有面板。Fig.10 (a) D1/D2 向下、(e) 四只竖向二极管向上，helper 增加 `up` 参数逐项指定。源图图标中的粗横杆与三角形必须一起检查。
- 生成器继承旧 helper 时先核对其参数签名：batch53 的 diode 原本无 `up` 参数，第一次方向修改报编译错误；增加局部新版定义后才成功输出。编译失败后旧 PNG 仍存在，所以必须先确认成功编译，再把比较图作为“修正后”证据。
- 同一图重复标 S1a/S1p/S1b 不自动改字。按原图保留，不能以推测的电气编号“修正”源图，字体宽容也不允许误写标签。
- 阶梯色块和灰色寄生电感都是原图内容。用原生色块/白色缺口恢复红蓝 L 形区域，灰色线圈保持相应颜色，不省略成只有主电路；开关等效小框同样属于完整图范围。
- 本批 Fig.10 五面板与小框 1/1 新整图通过，视觉重试 1。六张回查补正保持各自原通过数，不算新图。
'''
p.write_text(t,encoding='utf-8')
p=root/'work/pdf-candidates/8da2-converters/STATUS.md';t=p.read_text(encoding='utf-8')
t=t.replace('当前 Fig.1–5、7–9 八幅完整图通过（batch47/49/50/53/54），Fig.6 定量图表排除，其余继续处理。','当前 Fig.1–5、7–10 九幅完整图通过（batch47/49/50/53/54/55），Fig.6 定量图表排除，其余继续处理。')
for figure,n in ((2,3),(3,3),(4,3),(5,3),(7,2),(9,2)):
    pattern=rf'(?m)^(\| {figure} \|.*?视觉重试 )\d+(.*)$'
    t=re.sub(pattern,lambda m:m.group(1)+str(n)+m.group(2),t)
t=t.replace('| 10 | 11 | 开关电容变换器，待转绘 |','| 10 | 11 | batch55/pdf037 完整五面板及等效框通过，视觉重试 1 |')
t=t.replace('下一步 Fig.10 五组开关电容 DC–DC 电路，再继续 Fig.11 等。新图号从 pdf037 起','下一步 Fig.11 完整电压倍增单元，再继续 Fig.12 等。新图号从 pdf038 起')
t+='\n\n2026-09-26 batch55 回查补正六张曲极板电容接线，重新编译并实际比对通过；累计重试已同步上表，不增加通过图数。\n'
p.write_text(t,encoding='utf-8')
with (root/'work/pdf-candidates/SELECTION.md').open('a',encoding='utf-8') as f:
    f.write('\n\n### 8da22c007a Fig.10 完整通过与曲极板补正\n\n- batch55/pdf037：PDF11 Fig.10 完整五组电路与开关等效框，通过，视觉重试 1。另六张曲极板连接补正已实际编译/比对，见各 SOURCE.json/RESULTS.md 和逐图清单；保持原通过数。下一步 PDF12 Fig.11 倍增单元，pdf038 起。\n')
with (root/'community.md').open('a',encoding='utf-8') as f:
    f.write(f'''\n\n### [{stamp}] Codex（batch55 收口与历史符号补正；经验已追加）
- pdf037 Fig.10 完整五组开关电容变换器及开关等效框，1/1 新整图通过，视觉重试 1；全部原生 CeTZ、原图、300 ppi PNG、最终实际比较、SOURCE.json/RESULTS.md 已齐，预览 work/PDF-PREVIEW-13.png。初稿 (a) 二极管方向和 (b) 下排电容位置已修正。
- 从 Bézier 对称中点发现曲极板接线细小空隙，已回查补正 pdf030/031/032/033/034/036 共六张，全部重新编译并实际查看比较，保持通过、不重复增计图数；当前累计视觉重试 3/3/3/3/2/2，SOURCE/RESULTS/逐图清单与预览8–12同步。没有改动其他 Agent 的产物。
- 已追加 EXPERIENCE.md batch55：曲极板实际中点、方向参数、旧 helper 参数签名、编译失败不能拿旧 PNG 当新证据、原标签重复保留、阶梯色块/灰线圈完整性以及经验回查旧产物。
- 本篇 Fig.1–5、7–10 九幅完整通过，Fig.6/34 定量图排除；下一步 Fig.11 完整倍增单元，从 pdf038 起。新批号先核对三方共享日志和目录并确认独占创建。整体目标未完成，本轮为具体进展，无阻塞。
''')
print('Recorded batch55, six corrective reviews, previews and lessons.')
