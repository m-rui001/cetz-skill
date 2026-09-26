from pathlib import Path
from datetime import datetime
from zoneinfo import ZoneInfo
from PIL import Image, ImageDraw
from io import BytesIO
import pymupdf as fitz
import json

root=Path(__file__).resolve().parents[2]
batch=Path(__file__).parent
for folder in ['src','typ','png','screen']:(batch/folder).mkdir(exist_ok=True)
stamp=datetime.now(ZoneInfo('Asia/Shanghai')).strftime('%Y-%m-%d %H:%M')
with (root/'community.md').open('a',encoding='utf-8') as stream:
    stream.write(f'\n\n### [{stamp}] Codex（认领 batch45）\n'
                 '- 前轮具体进展：Fig.4/10 完整组合版已通过并协调归 batch44。已核对日志/目录，batch43 属 Agent-C，认领此前空闲 work/batch45。\n'
                 '- 继续 Fig.6 集成芯片示意，先看内嵌图并逐部位建清单；拟转绘 (1)a 硅光发射器、(3)a InP 发射器、(3)b TriPleX 接收器，编号从 pdf023 起。\n'
                 '- (2)、(3)c/d/f 以及 (4) 光路/芯片示意保留后续处理；显微照片和地图照片逐项记录筛查排除，不把整张 Fig.6 排除。\n')
source='E:/pdf/pdfonly-stem/pdfcorpus/out/pdfs/epr/4f/4f53c97362c66632bad047e1440e69ed41896204.pdf'
doc=fitz.open(source)
page=doc[39]
sheet=Image.new('RGB',(1200,8*410),'#eeeeee')
pen=ImageDraw.Draw(sheet)
for idx,entry in enumerate(page.get_images()):
    data=doc.extract_image(entry[0])
    im=Image.open(BytesIO(data['image'])).convert('RGB')
    im.save(batch/f'screen/xref-{entry[0]}.png')
    im.thumbnail((575,370))
    if im.width<575:
        factor=min(575/im.width,370/im.height)
        im=im.resize((round(im.width*factor),round(im.height*factor)))
    x,y=idx%2*600+10,idx//2*410+25
    pen.text((x,y-20),f'xref {entry[0]} native {entry[2]}x{entry[3]}',fill='red')
    sheet.paste(im,(x,y))
sheet.save(batch/'screen/contact.png')
for xref in [1125,1126,1127]:
    im=Image.open(batch/f'screen/xref-{xref}.png')
    im.resize((im.width*3,im.height*3)).save(batch/f'screen/large-{xref}.png')
im=Image.open(batch/'screen/xref-1125.png')
im.save(batch/'src/pdf023-silicon-polarization-tx.png')
(batch/'SOURCE.json').write_text(json.dumps({'title':'Advances in Quantum Cryptography','pdf':source,'pdf_page':40,'figure_number':6,
    'figures':[{'id':'pdf023-silicon-polarization-tx','panel':'(1)a','xref':1125,'native_px':[399,176]}],
    'remaining_panels':['(2)','(3)a','(3)b','(3)c','(3)d','(3)f','(4) line diagrams'],
    'screening_exclusions':[
        {'xref':1128,'panel':'(1)b','reason':'micrograph; photograph detail not suitable for CeTZ replication'},
        {'panel':'(3)e/g','reason':'micrographs within composite xref 1126'},
        {'panel':'(4) aerial map and micrographs','reason':'photographs; retain schematic portions'},
    ]},ensure_ascii=False,indent=2),encoding='utf-8')
print('Extracted 15 embedded images; Fig.6 screening source contact sheet ready.')
