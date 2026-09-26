from pathlib import Path
from datetime import datetime
from zoneinfo import ZoneInfo
import json
import pymupdf as fitz

root = Path(__file__).resolve().parents[2]
batch = Path(__file__).parent
source = 'E:/pdf/pdfonly-stem/pdfcorpus/out/pdfs/epr/4f/4f53c97362c66632bad047e1440e69ed41896204.pdf'
for folder in ['src','typ','png']:
    (batch/folder).mkdir(exist_ok=True)
stamp = datetime.now(ZoneInfo('Asia/Shanghai')).strftime('%Y-%m-%d %H:%M')
with (root/'community.md').open('a',encoding='utf-8') as stream:
    stream.write(f'\n\n### [{stamp}] Codex（认领 batch37）\n'
                 '- 上轮为具体进展：batch33/35 共新增 5 张通过；当前已核对共享日志与实际目录，batch36 属 Agent-C。\n'
                 '- 认领 work/batch37：同篇 Fig.4(b) 三态 BB84 光路、Fig.4(c) DPS 系统、Fig.10(b) 本地 LO 的 CV-QKD 系统（含脉冲时序示意）。从 pdf013 起。\n'
                 '- 三者都是光路/系统示意；Fig.10(b) 小面板是脉冲时序示意，不属于数据曲线。其余实验面板仍保留在筛查范围，未宣称整篇完成。\n')
figures = [
    ('pdf013-three-state-bb84',35,4,'b',[280,53,550,141]),
    ('pdf014-dps-system',35,4,'c',[66,143,284,240]),
    ('pdf015-local-lo-cv-qkd',58,10,'b',[162,194,459,340]),
]
doc = fitz.open(source)
for name,page,fig,panel,clip in figures:
    doc[page-1].get_pixmap(matrix=fitz.Matrix(4,4),clip=fitz.Rect(*clip),alpha=False).save(batch/f'src/{name}.png')
(batch/'SOURCE.json').write_text(json.dumps({'title':'Advances in Quantum Cryptography','pdf':source,'figures':[
    {'id':n,'pdf_page':p,'figure_number':f,'panel':panel,'clip_pt':clip} for n,p,f,panel,clip in figures
]},ensure_ascii=False,indent=2),encoding='utf-8')
