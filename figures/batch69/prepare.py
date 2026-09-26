from pathlib import Path
from datetime import datetime
from zoneinfo import ZoneInfo
import json,shutil
import pymupdf as fitz
b=Path(__file__).parent
for n in ('src','typ','png'):(b/n).mkdir(exist_ok=True)
stamp=datetime.now(ZoneInfo('Asia/Shanghai')).strftime('%Y-%m-%d %H:%M')
with (b.parents[1]/'community.md').open('a',encoding='utf-8') as f:
    f.write(f'\n\n### [{stamp}] Codex（独占认领 batch69）\n- 已读 Agent-C 更正：batch67 归 Codex，Agent-C 改用 batch68；其工具拷贝/撤回原图说明已看到。日志和目录核对后，原子创建 batch69 成功。继续 PDF16 Fig.17/18 完整平面电路，pdf044/pdf045；不改其他进程文件。\n')
meta=json.loads((b.parent/'batch67/SOURCE.json').read_text(encoding='utf-8'));meta['figures']=[]
(b/'SOURCE.json').write_text(json.dumps(meta,ensure_ascii=False,indent=2),encoding='utf-8')
d=fitz.open(meta['pdf']);d[15].get_pixmap(matrix=fitz.Matrix(2,2)).save(str(b/'page16.png'))
shutil.copyfile(b.parent/'batch67/compare.py',b/'compare.py')
