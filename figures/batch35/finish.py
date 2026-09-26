from pathlib import Path
import json
import re
import shutil
from datetime import datetime
from zoneinfo import ZoneInfo
from PIL import Image, ImageDraw

root = Path(__file__).resolve().parents[2]
batch = Path(__file__).parent
manifest = json.loads((batch/'SOURCE.json').read_text(encoding='utf-8'))
excluded = [f for f in manifest['figures'] if f['id'] == 'pdf012-tf-qkd-rates']
manifest['figures'] = [f for f in manifest['figures'] if f['id'] != 'pdf012-tf-qkd-rates']
for entry in excluded:
    entry['status'] = 'excluded by user: data curve plots do not need reproduction'
manifest['excluded'] = excluded
(batch/'SOURCE.json').write_text(json.dumps(manifest,ensure_ascii=False,indent=2),encoding='utf-8')
archive = batch/'skipped-data-plots'
archive.mkdir(exist_ok=True)
for rel in ['typ/pdf012-tf-qkd-rates.typ','src/pdf012-tf-qkd-rates.png','make_rate_chart.py']:
    source = batch/rel
    if source.exists():
        target = archive/source.name
        if target.exists():
            raise FileExistsError(target)
        shutil.move(source,target)
(archive/'README.md').write_text('用户指定数据曲线图不需要复刻。pdf012 草稿未编译，已停止，不计入验收。此处仅保留工作历史；不运行生成脚本。\n',encoding='utf-8')
experience = root/'work/EXPERIENCE.md'
text = experience.read_text(encoding='utf-8')
rows = list(re.finditer(r'^\| \d+ \|.*$',text,re.M))
if not re.search(r'^\| 35 \|',text,re.M):
    end = rows[-1].end()
    text = text[:end] + '\n| 35 | `work/batch35` | 2/2（PDF 中继示意图，数据曲线按用户要求跳过） | 2026-09-26 |' + text[end:]
    experience.write_text(text,encoding='utf-8')
with experience.open('a',encoding='utf-8') as stream:
    stream.write('\n\n## batch35：中继结构与用户范围补充\n\n'
                 '- 2/2 通过，各 1 次视觉重试。原图双向箭头是实心三角；CeTZ 的 start/end 标记先实际检查方向，必要时用独立三角头部保证左端向左、右端向右。\n'
                 '- 椭圆仍用 circle：radius: (rx, ry)。Typst 的 ellipse 是排版函数，不能当 CeTZ 绘图函数。\n'
                 '- 旋转标签实际比对阅读方向；本次 Quantum memories 应为 -90deg。\n'
                 '- 主人新要求：数据曲线图不需要复刻。筛选记录标为用户范围排除，不计入视觉放弃；只保留已生成的未编译草稿历史。\n')
stamp = datetime.now(ZoneInfo('Asia/Shanghai')).strftime('%Y-%m-%d %H:%M')
with (root/'community.md').open('a',encoding='utf-8') as stream:
    stream.write(f'\n\n### [{stamp}] Codex（batch35 收口与主人新增范围）\n'
                 '- 主人明确：数据曲线图不需要复刻。即刻执行；字体不必完全相同，图形尽量接近。请 EPUB/mathbook 进程也按此新增范围筛选。\n'
                 '- batch35 两张中继示意图 pdf010/011（Fig.17/18）2/2 通过，各 1 次视觉重试，300 ppi PNG、源码、原图、对比、SOURCE.json、RESULTS.md 已齐。\n'
                 '- 同篇 Fig.3/5/7/11/15 是数据曲线图，按主人要求跳过；pdf012 未编译草稿归档到 skipped-data-plots，不计入尝试或放弃。下一 PDF 图号 pdf013。\n'
                 '- 本轮 batch33+35 新增 5/5 通过，同篇累计 11 张通过，5 张曲线排除。尚有 Fig.4/6/8/10 混合实验面板待放大逐项筛查；总体任务仍未完成，无阻塞。\n'
                 '- 已看到 Agent-C 的 batch34 收口和 batch36 认领，保持其目录；下一批先查日志和实际目录。经验及候选选择记录已更新。\n')

names = [(33,'pdf007-adaptive-protocol'),(33,'pdf008-protocol-stretching'),
         (33,'pdf009-coherent-comparison'),(35,'pdf010-repeater-levels'),(35,'pdf011-probabilistic-repeaters')]
tiles = []
for num,name in names:
    img = Image.open(root/f'work/batch{num}/png/{name}.png').convert('RGB')
    ink = img.convert('L').point(lambda v:255 if v <245 else 0).getbbox()
    if ink:
        img = img.crop(ink)
    img.thumbnail((1000,580))
    tile = Image.new('RGB',(1040,img.height +65),'white')
    ImageDraw.Draw(tile).text((20,12),name,fill='#444444')
    tile.paste(img,((1040-img.width)//2,45))
    tiles.append(tile)
gallery=Image.new('RGB',(1040,sum(t.height for t in tiles) +20*(len(tiles)-1)),'#eeeeee')
y=0
for tile in tiles:
    gallery.paste(tile,(0,y))
    y += tile.height+20
gallery.save(root/'work/PDF-PREVIEW-2.png')
print('Recorded batch35; data curve draft archived; preview written.')
