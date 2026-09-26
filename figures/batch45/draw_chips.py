from pathlib import Path
from PIL import Image, ImageDraw
import json

ROOT=Path(__file__).parent
im=Image.open(ROOT/'screen/xref-1126.png')
parts=[('pdf024-inp-transmitter',(0,0,365,110),'(3)a'),('pdf025-triplex-receiver',(180,215,804,360),'(3)b')]
manifest=json.loads((ROOT/'SOURCE.json').read_text(encoding='utf-8'))
for name,box,panel in parts:
    cropped=im.crop(box)
    cropped.save(ROOT/f'src/{name}.png')
    large=cropped.resize((cropped.width*3,cropped.height*3))
    pen=ImageDraw.Draw(large)
    for x in range(0,cropped.width,50):
        pen.line((x*3,0,x*3,large.height),fill='#ee6666',width=1);pen.text((x*3+3,5),str(x),fill='red')
    for y in range(0,cropped.height,25):
        pen.line((0,y*3,large.width,y*3),fill='#ee6666',width=1);pen.text((5,y*3+3),str(y),fill='red')
    large.save(ROOT/f'screen/grid-{name}.png')
    entry={'id':name,'panel':panel,'xref':1126,'crop_px':box}
    if not any(f['id']==name for f in manifest['figures']):manifest['figures'].append(entry)
manifest['remaining_panels']=['(2)','(3)c','(3)d','(3)f','(4) line diagrams']
(ROOT/'SOURCE.json').write_text(json.dumps(manifest,ensure_ascii=False,indent=2),encoding='utf-8')

def save(name,w,h,scale,body):
    header=f'''#set page(width:auto,height:auto,margin:2pt)
#import "@preview/cetz:0.4.2":canvas,draw
#set text(font:"Arial",size:9pt)
#set par(leading:0pt)
#canvas(length:1pt,{{
  import draw:*
  let s={scale}
  let P=(x,y)=>(s*x,s*({h} - y))
  let poly=(pts,c)=>line(..pts.map(p=>P(..p)),close:true,fill:rgb(c),stroke:none)
  let wave=(pts,t:1.1,c:"#f4f3ef")=>line(..pts.map(p=>P(..p)),stroke:(paint:rgb(c),thickness:s*t*1pt))
  let curve=(a,b,c,d,t:1.1,color:"#f4f3ef")=>bezier(P(..a),P(..b),P(..c),P(..d),stroke:(paint:rgb(color),thickness:s*t*1pt))
  let label=(x,y,c,size:7,fill:white)=>content(P(x,y),text(size:s*size*1pt,fill:fill,c))
  let box=(x,y,w,h,c)=>rect(P(x,y),P(x + w,y + h),fill:rgb(c),stroke:none)
  let heater=(x,y,w,h)=>{{
    box(x,y,w,h,"#b1a057")
    box(x + 1,y + .8,w - 2,h - 1.6,"#e6c24c")
  }}
  let mz=(x1,x2,y,r:4)=>{{
    curve((x1,y),(x1 + 12,y - r),(x1 + 5,y),(x1 + 5,y - r))
    wave(((x1 + 12,y - r),(x2 - 12,y - r)))
    curve((x2 - 12,y - r),(x2,y),(x2 - 5,y - r),(x2 - 5,y))
    curve((x1,y),(x1 + 12,y + r),(x1 + 5,y),(x1 + 5,y + r))
    wave(((x1 + 12,y + r),(x2 - 12,y + r)))
    curve((x2 - 12,y + r),(x2,y),(x2 - 5,y + r),(x2 - 5,y))
  }}
'''
    (ROOT/f'typ/{name}.typ').write_text(header+body+'\n})\n',encoding='utf-8')

save('pdf023-silicon-polarization-tx',399,176,1.5,r'''
  poly(((35,1),(365,1),(396,140),(2,147)),"#808181")
  poly(((2,147),(396,140),(399,148),(1,150)),"#656666")
  // Folded input bus and eight-stage attenuator routing.
  wave(((14,88),(180,88),(186,86),(259,86),(263,101),(240,101)))
  wave(((9,114),(179,114),(181,91),(196,88),(207,88)))
  wave(((193,101),(190,113),(211,113)))
  wave(((241,113),(262,113),(264,125),(243,125)))
  wave(((211,125),(188,125),(186,137),(270,137),(266,59),(37,59),(35,58),(39,24),(48,23)))
  wave(((35,25),(29,60),(53,60),(56,62),(54,66),(18,66)))
  // Colored silicon and doping layers of two racetrack ring modulators.
  for x in (49,112) {
    rect(P(x,83),P(x + 59,108),radius:6*s,fill:rgb("#cd6e77"),stroke:none)
    rect(P(x + 4,87),P(x + 56,107),radius:5*s,fill:rgb("#278ec4"),stroke:none)
    rect(P(x + 8,88),P(x + 55,103),radius:4*s,fill:rgb("#ebcb45"),stroke:none)
    rect(P(x + 11,89),P(x + 49,99),radius:3*s,fill:rgb("#7b8081"),stroke:none)
    box(x + 26,85,14,9,"#e9bc3d")
    box(x + 27,88,13,2,"#f4e094")
    curve((x + 6,88),(x + 25,89),(x + 15,85),(x + 15,89),t:.8)
    curve((x + 25,89),(x + 48,90),(x + 34,97),(x + 35,85),t:.8)
    wave(((x + 48,90),(x + 49,98),(x + 10,98)),t:.8)
    curve((x + 10,98),(x + 6,88),(x + 2,98),(x + 3,89),t:.8)
  }
  // Serpentine VOA, eight independently visible heater strips.
  for i in range(8) {
    let y=84 + i*6.2
    wave(((195,y + 3),(204,y + 3),(208,y + 1),(239,y + 1),(244,y + 3),(251,y + 3)),t:.9)
    heater(209,y,31,4.5)
    if calc.rem(i,2)==0 {curve((251,y + 3),(251,y + 9.2),(258,y + 3),(258,y + 9.2),t:.9)}
    else {curve((195,y + 3),(195,y + 9.2),(189,y + 3),(189,y + 9.2),t:.9)}
  }
  // Polarization modulation bank and the output folded arms.
  wave(((39,23),(58,23)),t:1)
  for (x,w) in ((58,110),(178,31),(225,30)) {
    box(x - 1,18,w + 2,11,"#698eb7")
    heater(x,19,w,3.5)
    heater(x,24,w,3.5)
    wave(((x + w,22),(x + w + 9,22)),t:.9)
  }
  wave(((255,22),(258,22),(258,8),(265,8),(265,18),(285,18),(330,18),(330,20),(287,20),(287,24),(336,24),(367,23)),t:1)
  wave(((255,25),(258,25),(258,36),(265,36),(265,28),(338,28)),t:1)
  label(166,10,[Polarization Modulator],size:8.8)
  label(119,75,[Ring Modulators],size:8.8)
  label(225,76,[VOA],size:9)
  label(29,96,[Input],size:9)
  label(356,29,[Output],size:8.6)
  for (y,c,t) in ((58,"#ffffff",[220nm Si]),(70,"#cf5368",[90nm Si]),(82,"#edc24a",[N Doping]),(94,"#148bc3",[P Doping])) {
    box(289,y - 2.5,5,5,c)
    content(P(300,y),text(size:s*8.9pt,fill:white,t),anchor:"west")
  }
  label(206,164,[(a)],size:13,fill:black)
''')

save('pdf024-inp-transmitter',365,110,1.6,r'''
  poly(((29,25),(359,25),(359,81),(7,81)),"#655277")
  poly(((7,81),(359,81),(359,88),(13,89)),"#211d35")
  poly(((13,80),(359,80),(359,84),(9,84)),"#4c3c68")
  wave(((23,32),(54,32)))
  mz(54,128,36,r:4.3)
  wave(((128,36),(136,36)))
  mz(136,247,36,r:4.3)
  wave(((247,36),(257,36)))
  mz(257,324,36,r:4.3)
  wave(((324,36),(330,32),(359,32)))
  for (x,w) in ((84,28),(169,39),(278,24)) {
    box(x,28,w,4,"#8c8291")
    box(x,41,w,3,"#7c708e")
    for xx in (x - 2,x + w - 2) {box(xx,27,5,4,"#a29aa6")}
  }
  label(94,12,[P.MOD],size:11,fill:black)
  label(194,12,[PH.RAND],size:11,fill:black)
  label(291,12,[I.M],size:11,fill:black)
  label(4,10,[a],size:16,fill:black)
  // Integrated laser feeds the pulse-modulator chain.
  curve((57,36),(40,51),(38,36),(46,46))
  wave(((40,51),(51,53),(130,53)),t:1.3)
  for (x,w) in ((54,20),(78,23),(120,7)) {heater(x,52,w,9)}
  wave(((48,65),(132,65),(132,53)))
  rect(P(46,49),P(143,69),stroke:(paint:rgb("#ececf0"),thickness:.7pt,dash:"dotted"),fill:none)
  label(160,50,[PD],size:7.7)
  label(191,42,[EOPM],size:7.7)
  label(309,47,[MMI],size:6.2)
  curve((330,42),(327,51),(344,42),(344,51))
  wave(((327,51),(239,51)))
  curve((239,51),(238,60),(222,51),(222,60))
  mz(239,316,65,r:4.5)
  wave(((7,70),(239,70)))
  wave(((316,65),(326,60),(359,60)))
  wave(((316,65),(326,69),(359,69)))
  box(265,56,29,3,"#9a8d9c")
  box(265,71,29,3,"#9a8d9c")
  rect(P(233,51),P(330,78),stroke:(paint:rgb("#ececf0"),thickness:.7pt,dash:"dotted"),fill:none)
  label(89,102,[LASER],size:11,fill:black)
  label(311,102,[PH.ENC],size:11,fill:black)
  line(P(46,69),P(3,110),stroke:(paint:rgb("#b1b1b1"),thickness:.5pt,dash:"dotted"))
  line(P(143,69),P(203,110),stroke:(paint:rgb("#b1b1b1"),thickness:.5pt,dash:"dotted"))
  line(P(233,78),P(289,110),stroke:(paint:rgb("#b1b1b1"),thickness:.5pt,dash:"dotted"))
  line(P(330,78),P(365,99),stroke:(paint:rgb("#b1b1b1"),thickness:.5pt,dash:"dotted"))
''')

save('pdf025-triplex-receiver',624,145,1,r'''
  // Coordinates are relative to the cropped (3)b panel.
  poly(((21,23),(545,23),(578,118),(4,118)),"#151735")
  poly(((4,118),(578,118),(566,123),(8,123)),"#06091e")
  // Lower tunable beam splitter, then the phase decoder branches.
  wave(((7,99),(32,99)))
  wave(((12,82),(32,82)))
  mz(32,123,90.5,r:8.5)
  wave(((123,90.5),(137,82),(164,82)))
  wave(((123,90.5),(137,99),(571,99)))
  wave(((16,66),(164,66)))
  mz(164,250,74,r:8)
  wave(((250,74),(258,74)))
  mz(258,291,74,r:8)
  wave(((291,66),(507,66)))
  wave(((291,82),(507,82)))
  mz(507,546,74,r:8)
  wave(((546,66),(560,66)))
  wave(((546,82),(565,82)))
  heater(72,97,27,5)
  heater(197,80,26,5)
  heater(380,80,27,5)
  label(46,82,[DC],size:8.5)
  label(209,53,[L-BAL],size:8.8)
  label(300,75,[MZI],size:8.8)
  label(393,92,[TOPS],size:9.2)
  label(86,137,[TBS],size:11.5,fill:black)
  label(355,137,[PH.DEC],size:11.5,fill:black)
  // Seven serpentine delay cells. Each loop is continuous and squared.
  let pts=((279,61),(279,38),)
  for i in range(7) {
    let x=279 + i*32
    pts+=((x,37),(x + 22,37),(x + 26,40),(x + 26,56),(x + 21,57),(x + 12,57),(x + 9,54),(x + 9,48),(x + 13,45),(x + 20,45),(x + 20,42),(x + 6,42),(x + 5,46),(x + 5,59),(x + 10,61),(x + 28,61))
    if i<6 {pts+=((x + 32,61),(x + 32,38))}
  }
  pts+=((507,61),(507,66))
  wave(pts,t:1.7)
  wave(((279,66),(507,66)),t:1.3)
  for x in (277,312,377,503) {circle(P(x,62),radius:2.7,fill:rgb("#dcdcc8"),stroke:(paint:rgb("#85867b"),thickness:.5pt))}
  rect(P(373,31),P(505,71),stroke:(paint:rgb("#b6bcc5"),thickness:.65pt,dash:"dotted"),fill:none)
  line(P(373,31),P(393,17),stroke:(paint:rgb("#b6bcc5"),thickness:.65pt,dash:"dotted"))
  line(P(505,31),P(587,1),stroke:(paint:rgb("#b6bcc5"),thickness:.65pt,dash:"dotted"))
  label(463,9,[T-DEL],size:11.4,fill:black)
  label(582,29,[b],size:16,fill:black)
  // The three SPD ports leave the chip as independent waveguides.
  for (x,y) in ((579,66),(584,83),(590,100)) {
    circle(P(x + 5,y),radius:(7,7.3),fill:rgb("#171a17"),stroke:none)
    wave(((x + 10,y),(x + 25,y)),t:2,c:"#171a17")
  }
  label(585,137,[SPDs],size:11.5,fill:black)
''')
print('Selected two subpanels and wrote three standalone native CeTZ drawings.')
