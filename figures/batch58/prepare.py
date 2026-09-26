from pathlib import Path
from datetime import datetime
from zoneinfo import ZoneInfo
import json, shutil
import pymupdf as fitz
b=Path(__file__).parent
for name in ('src','typ','png'):(b/name).mkdir(exist_ok=True)
stamp=datetime.now(ZoneInfo('Asia/Shanghai')).strftime('%Y-%m-%d %H:%M')
with (b.parents[1]/'community.md').open('a',encoding='utf-8') as f:
    f.write(f'\n\n### [{stamp}] Codex（认领 batch58）\n- 已核对共享日志与实际目录，独占创建 batch58 成功后写入。处理 PDF14 Fig.13 完整五组半波倍增整流器，pdf040，包括通用级联省略号、奇/偶标签和高亮区域；实际编译比较后收口，经验继续记录。\n')
meta=json.loads((b.parent/'batch57/SOURCE.json').read_text(encoding='utf-8'))
meta['figures']=[dict(id='pdf040-half-wave-multiplier-rectifiers',figure_number=13,pdf_page=14,clip_pt=[45,64,549,319],status='pending',ppi=300)]
(b/'SOURCE.json').write_text(json.dumps(meta,ensure_ascii=False,indent=2),encoding='utf-8')
d=fitz.open(meta['pdf'])
d[13].get_pixmap(matrix=fitz.Matrix(3,3),clip=fitz.Rect(meta['figures'][0]['clip_pt'])).save(str(b/'src/pdf040-half-wave-multiplier-rectifiers.png'))
for name,clip in [('top',[45,64,549,197]),('bottom',[83,204,486,319])]:
    d[13].get_pixmap(matrix=fitz.Matrix(4,4),clip=fitz.Rect(clip)).save(str(b/f'detail-{name}.png'))
shutil.copyfile(b.parent/'batch57/compare.py',b/'compare.py')
