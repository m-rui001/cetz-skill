"""Use the four native PDF polylines as editable CeTZ coordinate data."""
from pathlib import Path
import json
import pymupdf as fitz

root = Path(__file__).parent
source = 'E:/pdf/pdfonly-stem/pdfcorpus/out/pdfs/epr/4f/4f53c97362c66632bad047e1440e69ed41896204.pdf'
doc = fitz.open(source)
page = doc[30]
head = '''#set page(width: auto, height: auto, margin: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw
#set text(font: "Calibri", size: 12pt)
#let turn-text = rotate
// Four source plot polylines expressed as editable native CeTZ coordinates.
#canvas(length: 1pt, {
  import draw: *
  let P = (x,y) => (2*(x - 58),2*(205 - y))
'''
parts = [head]
for curve, color in zip(page.get_drawings()[:4], ['blue','red','black','rgb("#00ef00")']):
    assert all(item[0] == 'l' for item in curve['items'])
    pts = [curve['items'][0][1]] + [item[2] for item in curve['items']]
    coords = ',\n    '.join(f'P({p.x:.5f},{p.y:.5f})' for p in pts)
    parts.append(f'  line({coords},stroke:(paint:{color},thickness:1.52pt))\n')
parts.append('''
  let left = 87.6
  let right = 288.3
  let top = 58.384
  let bottom = 182.525
  rect(P(left,top),P(right,bottom),stroke:.45pt)
  for km in range(0,1201,50) {
    let x = 91.6074 + km*192.8266/1200
    let len = if calc.rem(km,200) == 0 {1.5} else {.9}
    line(P(x,top),P(x,top + len),stroke:.35pt)
    line(P(x,bottom),P(x,bottom - len),stroke:.35pt)
    if calc.rem(km,200) == 0 { content(P(x,188.5),text(size:11.3pt,str(km))) }
  }
  for (y,label) in ((74.5,[0.1]),(97.4,$10^(-4)$),(120.6,$10^(-7)$),(143.7,$10^(-10)$),(166.8,$10^(-13)$)) {
    line(P(left,y),P(left + 1.5,y),stroke:.35pt)
    line(P(right,y),P(right - 1.5,y),stroke:.35pt)
    content(P(86.0,y),text(size:11.3pt,label),anchor:"east")
  }
  for y in range(66,179,8) {
    line(P(left,y),P(left + .9,y),stroke:.25pt)
    line(P(right,y),P(right - .9,y),stroke:.25pt)
  }
  content(P(188,200.0),text(size:13pt,[Alice–Bob distance (km)]))
  content(P(65.5,120.5),turn-text(90deg,text(size:13pt,[Key rate (bit/use)])))
  content(P(219.0,121.0),turn-text(-26deg,text(weight:"bold",size:12pt,[Single Repeater bound])))
  content(P(222.7,137.0),turn-text(-26deg,text(weight:"bold",size:12pt,[Ideal–TF])))
  content(P(108.3,99.3),turn-text(-24deg,text(weight:"bold",size:12pt,[TF–QKD])))
  content(P(158.0,138.0),turn-text(-43deg,text(weight:"bold",size:12pt,[PLOB])))
})
''')
(root/'typ/pdf012-tf-qkd-rates.typ').write_text(''.join(parts),encoding='utf-8')
doc[30].get_pixmap(matrix=fitz.Matrix(4,4),clip=fitz.Rect(58,53,304,205),alpha=False).save(root/'src/pdf012-tf-qkd-rates.png')
manifest = {'title':'Advances in Quantum Cryptography','pdf':source,
            'figures':[{'id':n,'figure_number':fig,'pdf_page':p,'clip_pt':r} for n,fig,p,r in [
                ('pdf010-repeater-levels',17,83,[347.64,52.07,531.47,217.56]),
                ('pdf011-probabilistic-repeaters',18,84,[317.04,52.05,562.06,104.86]),
                ('pdf012-tf-qkd-rates',3,31,[58,53,304,205])]]}
(root/'SOURCE.json').write_text(json.dumps(manifest,ensure_ascii=False,indent=2),encoding='utf-8')
