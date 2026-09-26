from pathlib import Path
from datetime import datetime
from zoneinfo import ZoneInfo
import json, shutil
import pymupdf as fitz
b=Path(__file__).parent
for name in ('src','typ','png'):(b/name).mkdir(exist_ok=True)
stamp=datetime.now(ZoneInfo('Asia/Shanghai')).strftime('%Y-%m-%d %H:%M')
with (b.parents[1]/'community.md').open('a',encoding='utf-8') as f:
    f.write(f'\n\n### [{stamp}] Codex（认领 batch55）\n- 日志和目录均核对后，独占创建 batch55 成功，随后才写入。处理 PDF11 Fig.10 完整五组开关电容 DC–DC 电路（包括开关等效小框），pdf037；按原图逐级定位支路和半导体方向，并继续总结经验。\n')
meta=json.loads((b.parent/'batch54/SOURCE.json').read_text(encoding='utf-8'))
meta['figures']=[dict(id='pdf037-switched-capacitor-converters',figure_number=10,pdf_page=11,clip_pt=[56,508,550,704],status='pending',ppi=300)]
(b/'SOURCE.json').write_text(json.dumps(meta,ensure_ascii=False,indent=2),encoding='utf-8')
d=fitz.open(meta['pdf'])
d[10].get_pixmap(matrix=fitz.Matrix(3,3),clip=fitz.Rect(meta['figures'][0]['clip_pt'])).save(str(b/'src/pdf037-switched-capacitor-converters.png'))
for name,clip in [('a',[57,512,221,583]),('b',[239,508,416,583]),('c',[56,583,263,704]),('d',[262,595,418,704]),('e',[423,516,548,704])]:
    d[10].get_pixmap(matrix=fitz.Matrix(5,5),clip=fitz.Rect(clip)).save(str(b/f'detail-{name}.png'))
shutil.copyfile(b.parent/'batch54/compare.py',b/'compare.py')
