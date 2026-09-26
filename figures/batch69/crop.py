from pathlib import Path
import json,pymupdf as fitz
b=Path(__file__).parent;p=b/'SOURCE.json';m=json.loads(p.read_text(encoding='utf-8'));d=fitz.open(m['pdf'])
m['figures']=[dict(id='pdf044-active-switched-inductor-circuits',figure_number=17,pdf_page=16,clip_pt=[98,65,493,316],status='pending',ppi=300),dict(id='pdf045-switched-coupled-inductor',figure_number=18,pdf_page=16,clip_pt=[123,498,467,586],status='pending',ppi=300)]
for q in m['figures']:d[15].get_pixmap(matrix=fitz.Matrix(4,4),clip=fitz.Rect(q['clip_pt'])).save(str(b/'src'/ (q['id']+'.png')))
for tag,box in [('top',[98,65,493,190]),('bottom',[116,199,482,316]),('18c',[375,499,467,586])]:d[15].get_pixmap(matrix=fitz.Matrix(5,5),clip=fitz.Rect(box)).save(str(b/f'detail-{tag}.png'))
p.write_text(json.dumps(m,ensure_ascii=False,indent=2),encoding='utf-8')
