from pathlib import Path
from datetime import datetime
from zoneinfo import ZoneInfo
import json
import pymupdf as fitz
from PIL import Image
from io import BytesIO

root=Path(__file__).resolve().parents[2]
batch=Path(__file__).parent
source='E:/pdf/pdfonly-stem/pdfcorpus/out/pdfs/epr/4f/4f53c97362c66632bad047e1440e69ed41896204.pdf'
for folder in ['typ','src','png']:(batch/folder).mkdir(exist_ok=True)
stamp=datetime.now(ZoneInfo('Asia/Shanghai')).strftime('%Y-%m-%d %H:%M')
with (root/'community.md').open('a',encoding='utf-8') as stream:
    stream.write(f'\n\n### [{stamp}] Codex（认领 batch39）\n'
                 '- 已核对日志和目录，batch38 属 Agent-C；认领 work/batch39。\n'
                 '- 从 pdf016 起：Fig.8 右侧卫星光路/脉冲时序、Fig.10(c) 软件定义收发系统、Fig.4(d) COW 实验光路。继续处理既有论文剩余面板，曲线图保持排除。\n'
                 '- 前轮为具体进展（batch37 3/3）；总体仍未完成，无阻塞。\n')
doc=fitz.open(source)
im=Image.open(BytesIO(doc.extract_image(1179)['image']))
im.crop((723,385,1600,1066)).save(batch/'src/pdf016-satellite-ground-optics.png')
doc[57].get_pixmap(matrix=fitz.Matrix(4,4),clip=fitz.Rect(137,352,485,427),alpha=False).save(batch/'src/pdf017-software-defined-qkd.png')
(batch/'src/pdf018-cow-experiment.png').write_bytes(doc.extract_image(949)['image'])
manifest={'title':'Advances in Quantum Cryptography','pdf':source,'figures':[
    {'id':'pdf016-satellite-ground-optics','figure_number':8,'pdf_page':42,'source_method':'embedded image xref 1179 cropped to white ground optics panel','clip_px':[723,385,1600,1066]},
    {'id':'pdf017-software-defined-qkd','figure_number':10,'panel':'c','pdf_page':58,'clip_pt':[137,352,485,427]},
    {'id':'pdf018-cow-experiment','figure_number':4,'panel':'d','pdf_page':35,'source_method':'full embedded image xref 949','native_px':[1500,464]},
]}
(batch/'SOURCE.json').write_text(json.dumps(manifest,ensure_ascii=False,indent=2),encoding='utf-8')
