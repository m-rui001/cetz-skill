from pathlib import Path
import json, shutil
import pymupdf as fitz

b=Path(__file__).parent
pdf='E:/pdf/pdfonly-stem/pdfcorpus/out/pdfs/vbn/8d/8da22c007ab12414f59b180f0f0e67f0f8f736dc.pdf'
clip=[80,63,517,282]
d=fitz.open(pdf)
d[8].get_pixmap(matrix=fitz.Matrix(3,3),clip=fitz.Rect(clip)).save(str(b/'src/pdf034-minimum-phase-boost.png'))
meta=json.loads((b.parent/'batch50/SOURCE.json').read_text(encoding='utf-8'))
meta['figures']=[dict(id='pdf034-minimum-phase-boost',figure_number=7,pdf_page=9,clip_pt=clip,status='pending',ppi=300)]
(b/'SOURCE.json').write_text(json.dumps(meta,ensure_ascii=False,indent=2),encoding='utf-8')
shutil.copyfile(b.parent/'batch50/compare.py',b/'compare.py')
for name,clip in [('e',[370,135,519,207]),('f',[80,208,218,282]),('h',[370,208,519,282])]:
    d[8].get_pixmap(matrix=fitz.Matrix(6,6),clip=fitz.Rect(clip)).save(str(b/f'detail-{name}.png'))
