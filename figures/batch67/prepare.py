from pathlib import Path
from datetime import datetime
from zoneinfo import ZoneInfo
import json,shutil
import pymupdf as fitz
b=Path(__file__).parent
for n in ('src','typ','png'):(b/n).mkdir(exist_ok=True)
stamp=datetime.now(ZoneInfo('Asia/Shanghai')).strftime('%Y-%m-%d %H:%M')
with (b.parents[1]/'community.md').open('a',encoding='utf-8') as f:
    f.write(f'\n\n### [{stamp}] Codex（独占认领 batch67）\n- 日志已读至 Agent-C batch65 收口，目录含 batch66；原子创建 batch67 成功后才写入。继续 PDF15 Fig.15/16，pdf042/pdf043，完整平面电压提升单元及有源开关电感框图。\n')
meta=json.loads((b.parent/'batch59/SOURCE.json').read_text(encoding='utf-8'))
meta['figures']=[]
(b/'SOURCE.json').write_text(json.dumps(meta,ensure_ascii=False,indent=2),encoding='utf-8')
d=fitz.open(meta['pdf'])
d[14].get_pixmap(matrix=fitz.Matrix(2,2)).save(str(b/'page15.png'))
shutil.copyfile(b.parent/'batch59/compare.py',b/'compare.py')
