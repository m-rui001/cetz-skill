from pathlib import Path
b=Path(__file__).parent
old=(b.parent/'batch55/typ/pdf037-switched-capacitor-converters.typ').read_text(encoding='utf-8')
head=old.split('  // (a) two charge-transfer',1)[0]
head=head.replace('x - 112','x - 90').replace('1408 - y','638 - y').replace('size:7.2pt','size:8pt')
extra=r'''
  let diode=(x,y,up:true)=>{
    wire(((x,y - 15),(x,y + 15)))
    let d=if up {-1} else {1}
    line(P(x,y + 6*d),P(x - 6,y - 6*d),P(x + 6,y - 6*d),close:true,fill:black,stroke:none)
    wire(((x - 7,y + 7*d),(x + 7,y + 7*d)))
  }
  let diode-h=(x,y,left:false)=>{
    wire(((x - 16,y),(x + 16,y)))
    let d=if left {-1} else {1}
    line(P(x + 6*d,y),P(x - 6*d,y - 6),P(x - 6*d,y + 6),close:true,fill:black,stroke:none)
    wire(((x + 7*d,y - 7),(x + 7*d,y + 7)))
  }
  let port=(x,y)=>circle(P(x,y),radius:1.35,fill:white,stroke:.7pt)
  let ground=(x,y)=>{
    wire(((x,y),(x,y + 11)))
    for (w,dy) in ((8,11),(5,15),(2.5,19)) {wire(((x - w,y + dy),(x + w,y + dy)))}
  }
  let signal=(x,y)=>{
    rect(P(x - 14,y - 23),P(x + 14,y + 23),radius:6*.5,fill:rgb("#dfd7e7"),stroke:none)
    bezier(P(x - 10,y - 10),P(x,y - 10),P(x - 11,y - 20),P(x,y - 20),stroke:.7pt)
    bezier(P(x,y - 10),P(x + 10,y - 10),P(x,y),P(x + 11,y),stroke:.7pt)
    wire(((x - 10,y + 15),(x - 10,y + 3),(x,y + 3),(x,y + 17),(x + 10,y + 17),(x + 10,y + 7)))
  }
  let ds=(a,b,c)=>{
    wire((a,b))
    let dx=b.at(0) - a.at(0);let dy=b.at(1) - a.at(1)
    let len=calc.sqrt(dx*dx + dy*dy);let ux=dx/len;let uy=dy/len
    let x=c.at(0);let y=c.at(1)
    line(P(x + 7*ux,y + 7*uy),P(x - 6*ux - 6*uy,y - 6*uy + 6*ux),P(x - 6*ux + 6*uy,y - 6*uy - 6*ux),close:true,fill:black,stroke:none)
    wire(((x + 8*ux - 7*uy,y + 8*uy + 7*ux),(x + 8*ux + 7*uy,y + 8*uy - 7*ux)))
  }
  let vout=(x,y,n)=>lab(x,y,[$V_"out" = #n V_"in"$])
'''
body=r'''
  // (a) Greinacher doubler.
  hcap(177,220,137,204);wire(((204,220),(233,220)));diode-h(249,220);wire(((265,220),(321,220)))
  wire(((137,298),(321,298)));wire(((204,220),(204,245)));diode(204,260);wire(((204,275),(204,298)))
  vc(284,253,220,298);ground(172,298);signal(138,261)
  for (x,y) in ((204,220),(204,298),(284,220),(284,298)) {dot(x,y)}
  for (x,y) in ((137,220),(137,298),(321,220),(321,298)) {port(x,y)}
  lab(108,261,[$V_"in"$]);vout(346,261,[2]);lab(177,202,[$C_1$]);lab(249,202,[$D_2$]);lab(188,259,[$D_1$]);lab(261,263,[$C_2$])
  lab(210,344,[Greinacher Voltage Doubler]);lab(210,384,[(a)])
  // (b) improved doubler, split output capacitors.
  hcap(496,163,453,530);wire(((530,163),(556,163)));diode-h(572,163);wire(((588,163),(648,163)))
  wire(((453,317),(556,317)));diode-h(572,317,left:true);wire(((588,317),(648,317)))
  wire(((530,163),(530,185)));diode(530,200);wire(((530,215),(530,240),(609,240)))
  wire(((530,240),(530,262)));diode(530,277);wire(((530,292),(530,317)))
  vc(609,197,163,240);vc(609,274,240,317);ground(491,317);signal(456,243)
  for (x,y) in ((530,163),(530,240),(530,317),(609,163),(609,240),(609,317)) {dot(x,y)}
  for (x,y) in ((453,163),(453,317),(648,163),(648,317)) {port(x,y)}
  lab(426,243,[$V_"in"$]);vout(661,243,[2]);lab(496,142,[$C_1$]);lab(572,144,[$D_1$]);lab(514,200,[$D_2$]);lab(514,277,[$D_3$]);lab(572,337,[$D_4$]);lab(585,202,[$C_2$]);lab(585,279,[$C_3$])
  lab(551,360,[Improved Greinacher Voltage Doubler]);lab(551,384,[(b)])
  // (c) quadrupler; neutral-point line crosses the return lead without a node.
  wire(((764,163),(795,163),(795,317)))
  hcap(837,163,795,874);wire(((874,163),(900,163)));diode-h(916,163);wire(((932,163),(991,163)))
  hcap(837,317,795,874);wire(((874,317),(900,317)));diode-h(916,317,left:true);wire(((932,317),(991,317)))
  wire(((874,163),(874,185)));diode(874,200);wire(((874,215),(874,240),(874,262)))
  diode(874,277);wire(((874,292),(874,317)))
  hump(795,764,983,240)
  vc(953,197,163,240);vc(953,274,240,317);ground(835,240);signal(768,199)
  for (x,y) in ((795,163),(874,163),(874,240),(874,317),(953,163),(953,240),(953,317),(983,240)) {dot(x,y)}
  for (x,y) in ((764,163),(764,240),(991,163),(991,317)) {port(x,y)}
  lab(742,193,[$V_"in"$]);lab(837,142,[$C_1$]);lab(837,340,[$C_3$]);lab(916,144,[$D_2$]);lab(916,337,[$D_4$]);lab(858,201,[$D_1$]);lab(858,278,[$D_3$]);lab(929,202,[$C_2$]);lab(929,279,[$C_4$])
  lab(1020,157,[$+2V_"in"$]);lab(1020,329,[$-2V_"in"$]);vout(1042,240,[4])
  content(P(980,225),text(size:6pt,[Neutral]));content(P(980,254),text(size:6pt,[Point]))
  lab(891,360,[Greinacher Voltage Quadrupler]);lab(891,384,[(c)])
  // (d) Cockcroft–Walton doubler with actual sloping semiconductor symbols.
  hcap(267,456,225,312);hcap(312,545,225,387)
  ds((262,545),(312,456),(287,499));ds((312,456),(363,545),(337,499))
  ground(245,545);signal(228,500)
  for (x,y) in ((312,456),(262,545),(363,545)) {dot(x,y)}
  for (x,y) in ((225,456),(225,545),(387,545)) {port(x,y)}
  lab(195,501,[$V_"in"$]);lab(267,439,[$C_1$]);lab(312,567,[$C_2$]);lab(265,504,[$D_1$]);lab(322,504,[$D_2$]);vout(399,532,[2])
  lab(304,597,[Cockcroft–Walton Voltage Doubler]);lab(290,623,[(d)])
  // (e) generalized CW multiplier, retaining the parity bands and ellipsis.
  shade(588,415,340,61,c:"#ffffce");shade(628,522,324,61,c:"#ffffce")
  hcap(607,456,564,716);hcap(782,456,753,845)
  hcap(650,545,564,716);hcap(821,545,753,894)
  ds((600,545),(651,456),(626,499));ds((651,456),(703,545),(677,499))
  ds((770,545),(822,456),(796,499));ds((822,456),(873,545),(848,499))
  lab(734,456,[$dots.h$]);lab(734,545,[$dots.h$]);ground(583,545);signal(566,500)
  for (x,y) in ((651,456),(600,545),(703,545),(822,456),(770,545),(873,545)) {dot(x,y)}
  for (x,y) in ((564,456),(564,545),(845,456),(894,545)) {port(x,y)}
  lab(534,501,[$V_"in"$]);lab(607,433,[$C_1$]);lab(782,433,[$C_(n - 1)$]);lab(650,566,[$C_2$]);lab(821,566,[$C_n$])
  lab(604,504,[$D_1$]);lab(662,504,[$D_2$]);lab(773,504,[$D_(n - 1)$]);lab(833,504,[$D_n$])
  lab(731,442,[Odd ratio]);lab(737,559,[Even ratio]);lab(873,439,[$V_"out" = n - 1 V_"in"$]);lab(907,565,[$V_"out" = n V_"in"$])
  lab(738,598,[Cockcroft–Walton Voltage Multiplier]);lab(738,623,[(e)])
})
'''
(b/'typ/pdf040-half-wave-multiplier-rectifiers.typ').write_text(head+extra+body,encoding='utf-8')
