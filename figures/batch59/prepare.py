from pathlib import Path
from datetime import datetime
from zoneinfo import ZoneInfo
import json,shutil
import pymupdf as fitz
b=Path(__file__).parent
for n in ('src','typ','png'):(b/n).mkdir(exist_ok=True)
stamp=datetime.now(ZoneInfo('Asia/Shanghai')).strftime('%Y-%m-%d %H:%M')
with (b.parents[1]/'community.md').open('a',encoding='utf-8') as f:
    f.write(f'\n\n### [{stamp}] Codex（认领 batch59）\n- 核对共享日志与目录，原子创建 batch59 成功后写入。处理 PDF14 Fig.14 完整六组全波倍增整流器，pdf041；含偶/奇通用级联、省略号、跨线、色块和全部器件，持续记录经验。\n')
meta=json.loads((b.parent/'batch58/SOURCE.json').read_text(encoding='utf-8'))
meta['figures']=[dict(id='pdf041-full-wave-multiplier-rectifiers',figure_number=14,pdf_page=14,clip_pt=[46,365,549,637],status='pending',ppi=300)]
(b/'SOURCE.json').write_text(json.dumps(meta,ensure_ascii=False,indent=2),encoding='utf-8')
d=fitz.open(meta['pdf'])
d[13].get_pixmap(matrix=fitz.Matrix(3,3),clip=fitz.Rect(meta['figures'][0]['clip_pt'])).save(str(b/'src/pdf041-full-wave-multiplier-rectifiers.png'))
for n,clip in [('top',[46,365,549,483]),('d',[55,515,195,637]),('e',[203,496,351,637]),('f',[359,480,549,637])]:
    d[13].get_pixmap(matrix=fitz.Matrix(5,5),clip=fitz.Rect(clip)).save(str(b/f'detail-{n}.png'))
shutil.copyfile(b.parent/'batch58/compare.py',b/'compare.py')
