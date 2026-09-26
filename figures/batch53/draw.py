from pathlib import Path
b=Path(__file__).parent
header=r'''#set page(width:auto,height:auto,margin:2pt)
#set text(font:"Times New Roman",size:7.2pt)
#set par(leading:2pt)
#import "@preview/cetz:0.4.2":canvas,draw
#canvas(length:1pt,{
  import draw:*
  let s=.5
  let P=(x,y)=>(s*(x - 160),s*(564 - y))
  let wire=(pts)=>line(..pts.map(p=>P(..p)),stroke:.7pt)
  let lab=(x,y,c)=>content(P(x,y),align(center,c))
  let dot=(x,y)=>circle(P(x,y),radius:1.05,fill:black,stroke:none)
  let battery=(x,y)=>{
    wire(((x,y - 13),(x,y - 3)));wire(((x,y + 3),(x,y + 13)))
    wire(((x - 10,y - 3),(x + 10,y - 3)));wire(((x - 5,y + 3),(x + 5,y + 3)))
  }
  let cap=(x,y,flat:false)=>{
    wire(((x,y - 15),(x,y - 3)));wire(((x,y + (if flat {3} else {1.75})),(x,y + 15)))
    wire(((x - 8,y - 3),(x + 8,y - 3)))
    if flat {wire(((x - 8,y + 3),(x + 8,y + 3)))} else {
      bezier(P(x - 8,y + 7),P(x + 8,y + 7),P(x - 7,y),P(x + 7,y),stroke:.7pt)
    }
  }
  let cap-h=(x,y,rev:false)=>{
    wire(((x - 15,y),(x - 3,y)));wire(((x + 3,y),(x + 15,y)))
    let d=if rev {-1} else {1}
    wire(((x + 3*d,y - 8),(x + 3*d,y + 8)))
    bezier(P(x - 7*d,y - 8),P(x - 7*d,y + 8),P(x,y - 7),P(x,y + 7),stroke:.7pt)
  }
  let ind=(x,y,core:false,dots:false)=>{
    for i in range(4) {bezier(P(x + i*7,y),P(x + (i + 1)*7,y),P(x + i*7,y - 8),P(x + (i + 1)*7,y - 8),stroke:.7pt)}
    if core {for yy in (y - 10,y - 13) {wire(((x,y + yy - y),(x + 28,yy)))}}
    if dots {dot(x - 4,y - 5)}
  }
  let resistor=(x,y)=>{
    let pts=((x,y - 12),)
    for i in range(1,7) {pts.push((x + (if calc.rem(i,2)==1 {4} else {-4}),y - 12 + i*24/7))}
    pts.push((x,y + 12));wire(pts)
  }
  let diode-h=(x,y,left:false)=>{
    let d=if left {-1} else {1}
    wire(((x - 16,y),(x + 16,y)))
    line(P(x + 5*d,y),P(x - 5*d,y - 4),P(x - 5*d,y + 4),close:true,fill:black,stroke:none)
    wire(((x + 6*d,y - 5),(x + 6*d,y + 5)))
  }
  let diode=(x,y)=>{
    wire(((x,y - 15),(x,y + 15)))
    line(P(x,y - 5),P(x - 4,y + 5),P(x + 4,y + 5),close:true,fill:black,stroke:none)
    wire(((x - 5,y - 6),(x + 5,y - 6)))
  }
  let sw=(x,y)=>{
    wire(((x,y - 15),(x,y - 5),(x + 9,y + 8)))
    wire(((x,y + 11),(x,y + 24)))
  }
  let sw-h=(x,y)=>{
    wire(((x - 15,y),(x - 5,y),(x + 8,y - 9)))
    wire(((x + 11,y),(x + 24,y)))
  }
  let output=(xc,xr,top,bot)=>{
    let y=(top + bot)/2
    wire(((xc,top),(xc,y - 15)));cap(xc,y);wire(((xc,y + 15),(xc,bot)))
    wire(((xr,top),(xr,y - 12)));resistor(xr,y);wire(((xr,y + 12),(xr,bot)))
    dot(xc,top);dot(xc,bot)
    lab(xc - 17,y + 2,[$C_o$]);lab(xr - 12,y + 2,[$R_o$]);lab(xr + 21,y + 2,[$V_"out"$])
  }
  let input=(x,y,top,bot)=>{
    battery(x,y);wire(((x,top),(x,y - 13)));wire(((x,y + 13),(x,bot)))
    lab(x - 22,y,[$V_"in"$])
  }
'''
body=r'''
  // (a) PWM boost, with two derivation arrows.
  wire(((196,228),(224,228)));ind(224,228);wire(((252,228),(294,228)))
  diode-h(310,228);wire(((326,228),(374,228)));wire(((196,307),(374,307)))
  input(196,268,228,307);wire(((280,228),(280,247)));sw(280,262);wire(((280,286),(280,307)))
  dot(280,228);dot(280,307);output(341,374,228,307)
  lab(239,215,[$L$]);lab(309,215,[$D$]);lab(267,268,[$S$]);lab(289,327,[(a)])
  line(P(418,244),P(457,244),P(457,214),P(496,269),P(457,324),P(457,294),P(418,294),close:true,fill:rgb("#e8b6b2"),stroke:none)
  lab(453,269,[Two Active\ Switch])
  line(P(273,350),P(330,350),P(330,382),P(366,382),P(303,413),P(240,382),P(273,382),close:true,fill:rgb("#e8b6b2"),stroke:none)
  lab(302,378,[Magnetic\ Coupling])
  // (b) auxiliary switch in series with a reversed diode.
  input(504,195,152,231);wire(((504,152),(551,152)));ind(551,152)
  wire(((579,152),(627,152)));diode-h(643,152);wire(((659,152),(708,152)))
  wire(((504,231),(708,231)));output(674,708,152,231)
  wire(((523,152),(523,190),(530,190)));diode-h(546,190,left:true)
  wire(((562,190),(563,190)));sw-h(578,190);wire(((602,190),(615,190)))
  wire(((615,152),(615,190),(615,191)));sw(615,206);wire(((615,230),(615,231)))
  for (x,y) in ((523,152),(615,152),(615,190),(615,231)) {dot(x,y)}
  lab(565,138,[$L$]);lab(643,139,[$D$]);lab(546,179,[$D_f$]);lab(584,179,[$S_f$]);lab(604,209,[$S_m$]);lab(605,251,[(b)])
  // (c) auxiliary switch at the upper shunt contact.
  input(781,197,154,233);wire(((781,154),(828,154)));ind(828,154)
  wire(((856,154),(903,154)));diode-h(919,154);wire(((935,154),(986,154)))
  wire(((781,233),(986,233)));output(952,986,154,233)
  wire(((801,154),(801,192),(821,192)));diode-h(837,192,left:true);wire(((853,192),(890,192)))
  wire(((890,154),(890,166),(899,179)));wire(((890,181),(890,203)))
  // The lower switch shares the middle contact, but has its own open gap.
  wire(((890,192),(890,203),(899,216)));wire(((890,218),(890,233)))
  for (x,y) in ((801,154),(890,154),(890,192),(890,233)) {dot(x,y)}
  lab(842,140,[$L$]);lab(919,140,[$D$]);lab(838,181,[$D_f$]);lab(879,174,[$S_f$]);lab(877,215,[$S_m$]);lab(882,251,[(c)])
  // (d) two active series switches and an intermediate capacitor.
  input(512,339,300,379);wire(((512,300),(553,300)));diode-h(570,300)
  wire(((586,300),(623,300)));ind(623,300);wire(((651,300),(698,300)));wire(((512,379),(698,379)))
  output(664,698,300,379)
  wire(((548,300),(548,313),(557,326)));wire(((548,329),(548,354),(557,367)))
  wire(((548,369),(548,379)))
  wire(((548,338),(603,338),(603,333)));cap(603,318);wire(((603,303),(603,300)))
  for (x,y) in ((548,300),(548,338),(548,379),(603,300)) {dot(x,y)}
  lab(570,286,[$D$]);lab(637,286,[$L$]);lab(539,319,[$S_1$]);lab(539,360,[$S_2$]);lab(606,401,[(d)])
  // (e) crossing branches remain unconnected; bridge hump on one diagonal.
  input(767,338,297,379);wire(((767,297),(772,297)));sw-h(787,297)
  wire(((811,297),(870,297)));cap-h(885,297);wire(((900,297),(925,297)));ind(925,297)
  wire(((953,297),(1000,297)));wire(((767,379),(870,379)));cap-h(885,379,rev:true);wire(((900,379),(1000,379)))
  output(966,1000,297,379)
  wire(((823,297),(823,315)));sw(823,330);wire(((823,354),(823,379)))
  wire(((919,297),(853,338),(853,344)));diode(853,359);wire(((853,374),(853,379)))
  wire(((851,297),(880,315)))
  bezier(P(880,315),P(889,321),P(882,309),P(891,315),stroke:.7pt)
  wire(((889,321),(916,338),(916,344)));diode(916,359);wire(((916,374),(916,379)))
  for (x,y) in ((823,297),(851,297),(919,297),(823,379),(853,379),(916,379)) {dot(x,y)}
  lab(790,307,[$S_1$]);lab(812,335,[$S_2$]);lab(839,358,[$D_1$]);lab(932,358,[$D_2$]);lab(885,282,[$C_1$]);lab(885,365,[$C_2$]);lab(939,285,[$L$]);lab(883,402,[(e)])
  // (f) magnetically coupled two winding boost.
  input(205,510,453,533);wire(((205,453),(226,453)));diode-h(242,453);wire(((258,453),(301,453)))
  ind(301,453,core:true,dots:true);wire(((329,453),(398,453)));wire(((205,533),(398,533)))
  wire(((205,489),(220,489)));sw-h(235,489);wire(((259,489),(301,489)))
  ind(301,489,core:true,dots:true);wire(((329,489),(335,489),(335,533)))
  wire(((277,453),(277,456)));cap(277,471);wire(((277,486),(277,489)))
  output(364,398,453,533)
  for (x,y) in ((205,489),(277,453),(277,489),(335,533)) {dot(x,y)}
  lab(242,440,[$D$]);lab(259,470,[$C$]);lab(241,501,[$S$]);lab(315,434,[$L_2$]);lab(315,472,[$L_1$]);lab(301,551,[(f)])
  // (g) input and output filter magnetic coupling.
  input(472,496,453,533);wire(((472,453),(497,453)));ind(497,453,core:true,dots:true)
  wire(((525,453),(554,453)));diode-h(570,453);wire(((586,453),(611,453)))
  ind(611,453,core:true,dots:true);wire(((639,453),(694,453)));wire(((472,533),(694,533)))
  wire(((543,453),(543,477)));sw(543,492);wire(((543,516),(543,533)))
  wire(((594,453),(594,480)));cap(594,495);wire(((594,510),(594,533)))
  output(660,694,453,533)
  for (x,y) in ((543,453),(543,533),(594,453),(594,533)) {dot(x,y)}
  lab(511,434,[$L_1$]);lab(625,434,[$L_2$]);lab(570,440,[$D$]);lab(531,496,[$S$]);lab(578,495,[$C$]);lab(583,551,[(g)])
  // (h) extra ripple-cancellation winding and flat capacitor.
  input(766,496,453,533);wire(((766,453),(794,453)));ind(794,453,core:true,dots:true)
  wire(((822,453),(858,453)));diode-h(874,453);wire(((890,453),(914,453)))
  ind(914,453,core:true,dots:true);wire(((942,453),(993,453)));wire(((766,533),(993,533)))
  wire(((778,453),(778,482),(794,482)));ind(794,482,core:true,dots:true)
  wire(((822,482),(833,482),(833,494)));cap(833,509,flat:true);wire(((833,524),(833,533)))
  wire(((851,453),(851,477)));sw(851,492);wire(((851,516),(851,533)))
  wire(((893,453),(893,480)));cap(893,495);wire(((893,510),(893,533)))
  output(959,993,453,533)
  for (x,y) in ((778,453),(833,533),(851,453),(851,533),(893,453),(893,533)) {dot(x,y)}
  lab(808,435,[$L_A$]);lab(808,465,[$L_B$]);lab(928,435,[$L_C$]);lab(874,440,[$D$]);lab(867,496,[$S$]);lab(810,510,[$C_r$]);lab(909,495,[$C$]);lab(882,551,[(h)])
})
'''
(b/'typ/pdf034-minimum-phase-boost.typ').write_text(header+body,encoding='utf-8')
