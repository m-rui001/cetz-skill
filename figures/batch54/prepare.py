from pathlib import Path
from datetime import datetime
from zoneinfo import ZoneInfo
import json, shutil
import pymupdf as fitz
b=Path(__file__).parent
for name in ('src','typ','png'):(b/name).mkdir(exist_ok=True)
stamp=datetime.now(ZoneInfo('Asia/Shanghai')).strftime('%Y-%m-%d %H:%M')
with (b.parents[1]/'community.md').open('a',encoding='utf-8') as f:
    f.write(f'\n\n### [{stamp}] Codex（认领 batch54）\n- 已核对共享日志/目录，独占创建 batch54 成功。处理 PDF11 Fig.9 完整七组电荷泵/开关电容电路，pdf036，保留全部开关、接地、端口和级联高亮区域；持续汇总经验。\n')
meta=json.loads((b.parent/'batch53/SOURCE.json').read_text(encoding='utf-8'))
meta['figures']=[dict(id='pdf036-charge-pump-circuits',figure_number=9,pdf_page=11,clip_pt=[51,272,548,461],status='pending',ppi=300)]
(b/'SOURCE.json').write_text(json.dumps(meta,ensure_ascii=False,indent=2),encoding='utf-8')
d=fitz.open(meta['pdf'])
d[10].get_pixmap(matrix=fitz.Matrix(3,3),clip=fitz.Rect(meta['figures'][0]['clip_pt'])).save(str(b/'src/pdf036-charge-pump-circuits.png'))
for name,clip in [('top',[51,272,548,358]),('bottom',[67,369,542,461])]:
    d[10].get_pixmap(matrix=fitz.Matrix(4,4),clip=fitz.Rect(clip)).save(str(b/f'detail-{name}.png'))
shutil.copyfile(b.parent/'batch53/compare.py',b/'compare.py')
