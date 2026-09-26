"""Compose native CeTZ panel bodies at their original PDF positions."""
from pathlib import Path
from datetime import datetime
from zoneinfo import ZoneInfo
import json
import pymupdf as fitz
from PIL import Image

root=Path(__file__).resolve().parents[2]
batch=Path(__file__).parent
for folder in ['typ','src','png']:(batch/folder).mkdir(exist_ok=True)
stamp=datetime.now(ZoneInfo('Asia/Shanghai')).strftime('%Y-%m-%d %H:%M')
log=root/'community.md'
if 'Codex（同时认领冲突，组合版移至 batch44）' not in log.read_text(encoding='utf-8'):
    with log.open('a',encoding='utf-8') as stream:
        stream.write(f'\n\n### [{stamp}] Codex（同时认领冲突，组合版移至 batch44）\n'
                     '- 已查日志和目录，batch41 属 Agent-C，batch44 空闲，认领 work/batch44。\n'
                     '- 合成 Fig.4 与 Fig.10 完整布局（pdf021/022），全部面板继续采用 CeTZ 原生源码，以 PDF 面板位置和尺寸定位，组合版不嵌入渲染 PNG。\n'
                     '- 前轮为具体进展；Fig.6 示意部分仍待转绘，总体目标保持原范围。\n')

source='E:/pdf/pdfonly-stem/pdfcorpus/out/pdfs/epr/4f/4f53c97362c66632bad047e1440e69ed41896204.pdf'
doc=fitz.open(source)
specs=[
    ('pdf021-dv-qkd-complete',35,4,[66,52,549,244],[
        (40,'pdf019-dv-qkd-benches',[70.683197,53.951981,292.656189,139.906982]),
        (37,'pdf013-three-state-bb84',[292,53,550,141]),
        (37,'pdf014-dps-system',[70.683197,139.906967,284.427185,239.266968]),
        (39,'pdf018-cow-experiment',[280.180023,152.649200,547.382019,235.333008]),
    ]),
    ('pdf022-cv-qkd-complete',58,10,[127,65,486,428],[
        (40,'pdf020-transmitted-lo-cv-qkd',[150.438004,68.522995,472.807007,188.302002]),
        (37,'pdf015-local-lo-cv-qkd',[162,194,459,340]),
        (39,'pdf017-software-defined-qkd',[137,352,485,427]),
    ]),
]
manifest={'title':'Advances in Quantum Cryptography','pdf':source,'figures':[]}
for name,page,figure,clip,panels in specs:
    typ=['#set page(width:auto,height:auto,margin:5pt)\n#import "@preview/cetz:0.4.2":canvas,draw\n']
    placements=[]
    for index,(number,panel,rect) in enumerate(panels):
        original=root/f'work/batch{number}/typ/{panel}.typ'
        code=original.read_text(encoding='utf-8')
        start=code.index('#canvas')
        header=[]
        for line in code[:start].splitlines():
            if line.startswith('#set page') or line.startswith('#import'):
                continue
            if line.startswith('#set ') or line.startswith('#let '):
                header.append(line[1:])
        body=code[start:].replace('#canvas','canvas',1).strip()
        if figure==4 and panel=='pdf018-cow-experiment':
            # PDF page covers/replaces this image's native labels with larger text.
            old='=>content(P(x,y),text(size:size,c))'
            assert old in body
            header.append('let hidden-text = hide')
            body=body.replace(old,'=>content(P(x,y),hidden-text(text(size:size,c)))')
        typ.append(f'// Native panel copied from batch{number}/{panel}.typ\n#let panel-{index}() = {{\n'+'\n'.join(header)+'\n'+body+'\n}\n')
        im=Image.open(root/f'work/batch{number}/src/{panel}.png').convert('RGB')
        ink=im.convert('L').point(lambda v:255 if v<245 else 0).getbbox()
        assert ink
        x1,y1,x2,y2=ink
        rx,ry,rw,rh=rect[0],rect[1],rect[2]-rect[0],rect[3]-rect[1]
        x=rx+x1/im.width*rw-clip[0]
        y=ry+y1/im.height*rh-clip[1]
        w=(x2-x1)/im.width*rw
        h=(y2-y1)/im.height*rh
        placements.append((index,x,y,w,h))
    typ.append('''
// Scale native vector content, including stroke widths and text, to PDF placement.
#let panel-at(body,x,y,w,h)=context {
  let measured=measure(body)
  place(top+left,dx:x,dy:y,scale(x:w/measured.width*100%,y:h/measured.height*100%,reflow:true,body))
}
''')
    typ.append(f'#box(width:{clip[2]-clip[0]}pt,height:{clip[3]-clip[1]}pt)[\n')
    for index,x,y,w,h in placements:
        typ.append(f'  #panel-at(panel-{index}(),{x:.5f}pt,{y:.5f}pt,{w:.5f}pt,{h:.5f}pt)\n')
    labels=[]
    for block in doc[page-1].get_text('dict')['blocks']:
        if block['type']!=0:continue
        for line in block['lines']:
            text=''.join(s['text'] for s in line['spans'])
            if text in ('a)','b)','c)','d)'):
                x,y,_,_=line['bbox']
                size=8 if figure==4 else 8.5
                typ.append(f'  #place(top+left,dx:{x-clip[0]:.5f}pt,dy:{y-clip[1]:.5f}pt)[#text(font:"Calibri",size:{size}pt)[{text}]]\n')
                labels.append(text)
            elif figure==4 and 280<line['bbox'][0]<549 and 139<line['bbox'][1]<244:
                for span in line['spans']:
                    x,y,_,_=span['bbox']
                    label=json.dumps(span['text'],ensure_ascii=False)
                    typ.append(f'  #place(top+left,dx:{x-clip[0]:.5f}pt,dy:{y-clip[1]:.5f}pt)[#text(font:"Calibri",size:{span["size"]:.5f}pt,{label})]\n')
    if figure==4:
        typ.append('  #place(top+left)[#canvas(length:1pt,{\n  import draw:*\n')
        typ.append(f'  let P=(x,y)=>(x - {clip[0]},{clip[3]} - y)\n')
        typ.append(f'  rect((0,0),({clip[2]-clip[0]},{clip[3]-clip[1]}),fill:none,stroke:none)\n')
        for graphic in doc[page-1].get_drawings():
            r=graphic['rect']
            if not (280<r.x0<549 and 140<r.y0<244):continue
            filled=graphic['fill'] is not None and sum(graphic['fill'])<.1
            stroked=graphic['color'] is not None and sum(graphic['color'])<.1
            if not (filled or stroked):continue
            stroke=f'{graphic["width"]:.6f}pt' if stroked else 'none'
            items=graphic['items']
            point=lambda p:f'P({p.x:.6f},{p.y:.6f})'
            if all(item[0]=='l' for item in items):
                points=[items[0][1]]+[item[2] for item in items]
                coords=','.join(point(p) for p in points)
                typ.append(f'  line({coords},close:{str(filled).lower()},fill:{"black" if filled else "none"},stroke:{stroke})\n')
            else:
                for item in items:
                    assert item[0]=='c'
                    typ.append(f'  bezier({point(item[1])},{point(item[4])},{point(item[2])},{point(item[3])},stroke:{stroke})\n')
        typ.append('})]\n')
    typ.append(']\n')
    (batch/f'typ/{name}.typ').write_text(''.join(typ),encoding='utf-8')
    doc[page-1].get_pixmap(dpi=300,clip=fitz.Rect(*clip),alpha=False).save(batch/f'src/{name}.png')
    manifest['figures'].append({'id':name,'figure_number':figure,'pdf_page':page,'clip_pt':clip,
        'source_panels':[{'batch':n,'id':p,'placement_pt':r} for n,p,r in panels],
        'labels':labels,'composition':'native CeTZ content scaled to PDF image placements',
        'pdf_annotation_overlay':figure==4})
(batch/'SOURCE.json').write_text(json.dumps(manifest,indent=2),encoding='utf-8')
print('Composed two complete vector figures.')
