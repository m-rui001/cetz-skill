from pathlib import Path
from datetime import datetime
from zoneinfo import ZoneInfo
from PIL import Image, ImageDraw
import json
import shutil

root=Path(__file__).resolve().parents[2]
batch=Path(__file__).parent
for folder in ['src','typ','png']:(batch/folder).mkdir(exist_ok=True)
stamp=datetime.now(ZoneInfo('Asia/Shanghai')).strftime('%Y-%m-%d %H:%M')
with (root/'community.md').open('a',encoding='utf-8') as stream:
    stream.write(f'\n\n### [{stamp}] Codex（认领 batch40）\n'
                 '- 前轮为具体进展：batch39 三面板通过。已读日志并查看目录，当前 batch40 空闲，认领 work/batch40。\n'
                 '- 转绘剩余两块大型光路：Fig.4(a) 双基底 DV-QKD（pdf019）、Fig.10(a) 同传 LO 的 CV-QKD（pdf020），采用已提取完整内嵌原图。\n'
                 '- Fig.6 集成芯片示意部分仍在范围中，之后继续；数据曲线按主人要求排除。\n')
figures=[('pdf019-dv-qkd-benches','fig4a-native',4,35,954,[1379,534]),
         ('pdf020-transmitted-lo-cv-qkd','fig10a-native',10,58,1601,[1808,837])]
for name,cache,fig,page,xref,dim in figures:
    shutil.copyfile(root/f'work/pdf-candidates/remaining-4f53/{cache}.png',batch/f'src/{name}.png')
    im=Image.open(batch/f'src/{name}.png').convert('RGB')
    pen=ImageDraw.Draw(im)
    for x in range(0,im.width,100):
        pen.line((x,0,x,im.height),fill='#ffaaaa',width=1)
        pen.text((x+2,2),str(x),fill='red')
    for y in range(0,im.height,100):
        pen.line((0,y,im.width,y),fill='#ffaaaa',width=1)
        pen.text((2,y+2),str(y),fill='red')
    im.save(batch/f'grid_{name}.png')
manifest={'title':'Advances in Quantum Cryptography','pdf':'E:/pdf/pdfonly-stem/pdfcorpus/out/pdfs/epr/4f/4f53c97362c66632bad047e1440e69ed41896204.pdf',
          'figures':[{'id':n,'figure_number':f,'panel':'a','pdf_page':p,'source_method':f'full embedded image xref {x}','native_px':d} for n,c,f,p,x,d in figures]}
(batch/'SOURCE.json').write_text(json.dumps(manifest,indent=2),encoding='utf-8')
