from pathlib import Path
from datetime import datetime
from zoneinfo import ZoneInfo
import json, shutil
import pymupdf as fitz
b=Path(__file__).parent
for name in ('src','typ','png'):(b/name).mkdir(exist_ok=True)
stamp=datetime.now(ZoneInfo('Asia/Shanghai')).strftime('%Y-%m-%d %H:%M')
with (b.parents[1]/'community.md').open('a',encoding='utf-8') as f:
    f.write(f'\n\n### [{stamp}] Codex（认领 batch57）\n- 已核对共享日志与实际目录，batch56 为 Agent-C；独占创建 batch57 成功后写入。处理 PDF12 Fig.11 完整主结构及六种电压倍增单元，pdf038。器件、端口、非连接跨线和全部标签按源图保留，继续总结经验。\n')
meta=json.loads((b.parent/'batch55/SOURCE.json').read_text(encoding='utf-8'))
meta['figures']=[dict(id='pdf038-voltage-multiplier-cells',figure_number=11,pdf_page=12,clip_pt=[325,242,537,443],status='pending',ppi=300)]
(b/'SOURCE.json').write_text(json.dumps(meta,ensure_ascii=False,indent=2),encoding='utf-8')
d=fitz.open(meta['pdf'])
d[11].get_pixmap(matrix=fitz.Matrix(4,4),clip=fitz.Rect(meta['figures'][0]['clip_pt'])).save(str(b/'src/pdf038-voltage-multiplier-cells.png'))
for name,clip in [('top',[325,242,537,374]),('bottom',[325,380,537,443])]:
    d[11].get_pixmap(matrix=fitz.Matrix(6,6),clip=fitz.Rect(clip)).save(str(b/f'detail-{name}.png'))
shutil.copyfile(b.parent/'batch55/compare.py',b/'compare.py')
