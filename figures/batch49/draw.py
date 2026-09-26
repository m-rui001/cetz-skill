from pathlib import Path
batch=Path(__file__).parent
header=r'''#set page(width:auto,height:auto,margin:2pt)
#import "@preview/cetz:0.4.2":canvas,draw
#set text(font:"Times New Roman",size:9.5pt)
#set par(leading:4.4pt)
#canvas(length:1pt,{
  import draw:*
  let s=.44
  let P=(x,y)=>(s*x,s*(HEIGHT - y))
  let wire=(pts)=>line(..pts.map(p=>P(..p)),stroke:1pt)
  let lab=(x,y,c,size:9.5pt,weight:"regular")=>content(P(x,y),align(center,text(size:size,weight:weight,c)))
  let dot=(x,y)=>circle(P(x,y),radius:1.2,fill:black,stroke:none)
  let port=(x,y)=>circle(P(x,y),radius:1.45,fill:white,stroke:1pt)
  let tinted=(x,y,w,h)=>rect(P(x,y),P(x + w,y + h),radius:7*s,fill:rgb("#ffffcf"),stroke:none)
  let block=(x,y,w,h,c:"#f1dcda")=>rect(P(x,y),P(x + w,y + h),fill:rgb(c),stroke:1pt)
  let dc=(x,y,w,h,left:[DC],right:[DC])=>{
    block(x,y,w,h,c:"#dceef1")
    wire(((x,y + h),(x + w,y)))
    lab(x + w*.25,y + h*.24,left,size:10pt)
    lab(x + w*.74,y + h*.80,right,size:10pt)
  }
  let battery=(x,y)=>{
    wire(((x,y - 22),(x,y - 4)));wire(((x,y + 4),(x,y + 22)))
    wire(((x - 18,y - 4),(x + 18,y - 4)));wire(((x - 8,y + 4),(x + 8,y + 4)))
  }
  let cap=(x,y)=>{
    wire(((x,y - 18),(x,y - 3)));wire(((x,y + 1.25),(x,y + 18)))
    wire(((x - 12,y - 3),(x + 12,y - 3)))
    bezier(P(x - 12,y + 8),P(x + 12,y + 8),P(x - 11,y - 1),P(x + 11,y - 1),stroke:1pt)
  }
  let cap-h=(x,y)=>{
    wire(((x - 22,y),(x - 1.25,y)));wire(((x + 3,y),(x + 22,y)))
    wire(((x + 3,y - 12),(x + 3,y + 12)))
    bezier(P(x - 8,y - 12),P(x - 8,y + 12),P(x + 1,y - 11),P(x + 1,y + 11),stroke:1pt)
  }
  let ind=(x,y,n:4,d:-1,pitch:11,depth:12)=>{
    for i in range(n) {bezier(P(x + i*pitch,y),P(x + (i + 1)*pitch,y),P(x + i*pitch,y + depth*d),P(x + (i + 1)*pitch,y + depth*d),stroke:1pt)}
  }
  let winding=(x,y,h,n:4,d:1)=>{
    let a=h/n
    for i in range(n) {bezier(P(x,y + i*a),P(x,y + (i + 1)*a),P(x + 10*d,y + i*a),P(x + 10*d,y + (i + 1)*a),stroke:1pt)}
  }
  let trafo=(px,sx,y,h,ratio:true,lead:0)=>{
    winding(px,y + lead,h - 2*lead)
    winding(sx,y + lead,h - 2*lead,d:-1)
    if lead > 0 {
      wire(((px,y),(px,y + lead)));wire(((px,y + h - lead),(px,y + h)))
      wire(((sx,y),(sx,y + lead)));wire(((sx,y + h - lead),(sx,y + h)))
    }
    for x in ((px + sx)/2 - 2,(px + sx)/2 + 2) {wire(((x,y + 5),(x,y + h - 5)))}
    dot(px - 5,y + lead + 7);dot(sx + 5,y + lead + 7)
    if ratio {lab((px + sx)/2,y - 10,[1 : n])}
  }
  let res=(x,y,h:32)=>{
    let pts=((x,y - h/2),)
    for i in range(1,7) {pts.push((x + (if calc.rem(i,2)==1 {5} else {-5}),y - h/2 + i*h/7))}
    pts.push((x,y + h/2));wire(pts)
  }
  let diode=(x,y,up:true,leads:true)=>{
    if leads {wire(((x,y - 22),(x,y + 22)))}
    let d=if up {-1} else {1}
    line(P(x,y + 8*d),P(x - 7,y - 7*d),P(x + 7,y - 7*d),close:true,fill:black,stroke:none)
    wire(((x - 8,y + 9*d),(x + 8,y + 9*d)))
  }
  let diode-h=(x,y)=>{
    wire(((x - 23,y),(x + 23,y)))
    line(P(x + 6,y),P(x - 7,y - 7),P(x - 7,y + 7),close:true,fill:black,stroke:none)
    wire(((x + 9,y - 8),(x + 9,y + 8)))
  }
  let mos=(x,y,body:false)=>{
    wire(((x,y - 28),(x,y - 18),(x + 14,y - 18)))
    wire(((x,y + 28),(x,y + 12),(x + 14,y + 12)))
    for dy in (-18,-4,10) {wire(((x + 14,y + dy),(x + 14,y + dy + 5)))}
    wire(((x + 20,y - 17),(x + 20,y + 11),(x + 34,y + 11)))
    wire(((x,y - 3),(x + 11,y - 3)))
    line(P(x + 15,y - 3),P(x + 8,y - 6),P(x + 8,y),close:true,fill:black,stroke:none)
    if body {
      wire(((x,y - 18),(x - 17,y - 18),(x - 17,y + 12),(x,y + 12)))
      diode(x - 17,y - 2,leads:false)
    }
  }
  let cross=(x1,x2,y,x)=>{
    wire(((x1,y),(x - 4,y)))
    bezier(P(x - 4,y),P(x + 4,y),P(x - 4,y - 7),P(x + 4,y - 7),stroke:1pt)
    wire(((x + 4,y),(x2,y)))
  }
  let bridge=(xl,xr,top,bot,ma,mb,labels,highlight:true)=>{
    if highlight {tinted(xl - 30,top - 12,xr - xl + 47,bot - top + 22)}
    wire(((xl,top),(xr,top)));wire(((xl,bot),(xr,bot)))
    let upper=top + 18
    let lower=bot - 41
    for (x,m) in ((xl,ma),(xr,mb)) {
      wire(((x,top),(x,upper),(x + 15,upper + 22)))
      wire(((x,upper + 26),(x,lower),(x + 15,lower + 22)))
      wire(((x,lower + 26),(x,bot)))
      dot(x,top);dot(x,bot);dot(x,m)
    }
    lab(xl - 18,upper + 9,labels.at(0))
    lab(xr - 17,upper + 9,labels.at(1))
    lab(xl - 18,lower + 9,labels.at(2))
    lab(xr - 17,lower + 9,labels.at(3))
  }
  let arrow=(a,b,c:black,t:1pt,w:8)=>{
    let dx=b.at(0) - a.at(0);let dy=b.at(1) - a.at(1)
    let r=calc.sqrt(dx*dx + dy*dy);let ux=dx/r;let uy=dy/r
    line(P(..a),P(b.at(0) - ux*w,b.at(1) - uy*w),stroke:(paint:c,thickness:t))
    line(P(..b),P(b.at(0) - ux*w - uy*w*.45,b.at(1) - uy*w + ux*w*.45),P(b.at(0) - ux*w + uy*w*.45,b.at(1) - uy*w - ux*w*.45),close:true,fill:c,stroke:none)
  }
  let input-circle=(x,y,current:false)=>{
    circle(P(x,y),radius:16*s,fill:white,stroke:1.1pt)
    if current {arrow((x,y + 10),(x,y - 10),w:7)} else {lab(x,y - 7,[$+$],size:8pt);lab(x,y + 8,[$-$],size:8pt)}
  }
  let bus-terminals=(x,y1,y2,c,left:true)=>{
    port(x,y1);port(x,y2)
    lab(x,y1 + 13,[$+$],size:8pt);lab(x,y2 - 12,[$-$],size:8pt)
    lab(x + (if left {-18} else {18}),(y1 + y2)/2,c)
  }
'''

fig3=r'''
  // (a) unidirectional nonisolated DC converter.
  lab(187,23,[Power Flow],weight:"bold",size:10.3pt)
  lab(184,52,[A to B],size:8.5pt);arrow((156,71),(212,71))
  lab(70,73,[DC Bus A],size:8.5pt);lab(287,73,[DC Bus B],size:8.5pt)
  dc(134,81,99,99)
  wire(((77,95),(134,95)));wire(((233,95),(292,95)))
  wire(((77,167),(134,167)));wire(((233,167),(292,167)))
  bus-terminals(77,95,167,[$V_L$]);bus-terminals(292,95,167,[$V_H$],left:false)
  // Buck converter with a discrete freewheel diode.
  lab(266,235,[Buck Converter])
  wire(((61,227),(173,227),(173,246)))
  battery(61,303);wire(((61,227),(61,281)));wire(((61,325),(61,387),(339,387)))
  wire(((114,227),(114,285)));cap(114,303);wire(((114,321),(114,387)))
  mos(173,274);wire(((173,302),(173,319)));diode(173,345);wire(((173,367),(173,387)))
  wire(((173,306),(212,306)));ind(212,306);wire(((256,306),(339,306)))
  wire(((283,306),(283,331)));cap(283,349);wire(((283,367),(283,387)))
  wire(((339,306),(339,330)));res(339,347);wire(((339,363),(339,387)))
  for (x,y) in ((114,227),(114,387),(173,306),(173,387),(283,306),(283,387)) {dot(x,y)}
  lab(33,303,[$V_"in"$]);lab(94,284,[$C_"in"$]);lab(154,269,[$S$]);lab(153,343,[$D$]);lab(236,286,[$L$])
  lab(253,347,[$C_o$]);lab(315,350,[$R_o$]);lab(370,347,[$V_"out"$])
  // Boost converter, same independent input/output filtering.
  lab(117,427,[Boost Converter])
  wire(((65,501),(143,501)));ind(143,501);wire(((187,501),(210,501)))
  wire(((210,501),(210,482)));diode(210,459);wire(((210,437),(210,422),(333,422)))
  wire(((210,501),(210,514)));mos(210,542);wire(((210,570),(210,583)))
  battery(65,540);wire(((65,501),(65,518)));wire(((65,562),(65,583),(333,583)))
  wire(((117,501),(117,522)));cap(117,540);wire(((117,558),(117,583)))
  wire(((273,422),(273,487)));cap(273,505);wire(((273,523),(273,583)))
  wire(((333,422),(333,488)));res(333,504);wire(((333,520),(333,583)))
  for (x,y) in ((117,501),(117,583),(210,501),(210,583),(273,422),(273,583)) {dot(x,y)}
  lab(30,539,[$V_"in"$]);lab(99,521,[$C_"in"$]);lab(164,481,[$L$]);lab(190,460,[$D$]);lab(190,542,[$S$]);lab(243,505,[$C_o$]);lab(307,505,[$R_o$]);lab(365,505,[$V_"out"$]);lab(199,610,[(a)])
  // (b) bidirectional nonisolated converter and two MOSFET/body diodes.
  lab(579,20,[Power Flow],weight:"bold",size:10.3pt)
  lab(577,42,[B to A],size:8.5pt);arrow((602,56),(546,56))
  lab(577,70,[A to B],size:8.5pt);arrow((547,83),(604,83))
  lab(461,84,[DC Bus A],size:8.5pt);lab(680,84,[DC Bus B],size:8.5pt)
  dc(526,91,99,99)
  wire(((467,106),(526,106)));wire(((625,106),(684,106)))
  wire(((467,178),(526,178)));wire(((625,178),(684,178)))
  bus-terminals(467,106,178,[$V_L$]);bus-terminals(684,106,178,[$V_H$],left:false)
  lab(577,292,[Bidirectional Boost Converter])
  tinted(557,346,63,60);tinted(557,436,63,59)
  wire(((439,424),(518,424)));ind(518,424);wire(((562,424),(583,424)))
  wire(((583,319),(707,319),(707,408)))
  wire(((583,319),(583,348)));mos(583,376,body:true);wire(((583,404),(583,437)))
  mos(583,465,body:true);wire(((583,493),(583,507)))
  battery(439,467);wire(((439,424),(439,445)));wire(((439,489),(439,507),(707,507)))
  wire(((495,424),(495,449)));cap(495,467);wire(((495,485),(495,507)))
  wire(((647,319),(647,406)));cap(647,424);wire(((647,442),(647,507)))
  res(707,424);wire(((707,440),(707,507)))
  for (x,y) in ((495,424),(495,507),(583,424),(583,507),(647,319),(647,507)) {dot(x,y)}
  lab(412,470,[$V_L$]);lab(473,448,[$C_"in"$]);lab(536,405,[$L$]);lab(546,376,[$S_1$]);lab(546,466,[$S_2$]);lab(621,424,[$C_o$]);lab(682,424,[$R_o$]);lab(737,424,[$V_H$]);lab(577,610,[(b)])
  // (c) isolated unidirectional converter, with full-bridge rectifier.
  lab(387,667,[Power Flow],weight:"bold",size:10.3pt)
  lab(385,690,[A to B],size:8.5pt);arrow((350,704),(419,704))
  lab(166,704,[DC Bus A],size:8.5pt);lab(590,704,[DC Bus B],size:8.5pt)
  dc(225,714,100,99,left:[DC],right:[AC]);dc(436,714,100,99,left:[AC],right:[DC])
  wire(((162,728),(225,728)));wire(((162,800),(225,800)))
  wire(((536,728),(594,728)));wire(((536,800),(594,800)))
  wire(((325,734),(363,734)));wire(((325,793),(363,793)))
  trafo(363,400,734,59,lead:5);wire(((400,734),(436,734)));wire(((400,793),(436,793)))
  bus-terminals(162,728,800,[$V_L$]);bus-terminals(594,728,800,[$V_H$],left:false)
  lab(376,858,[Full Bridge DC-DC Converter])
  bridge(257,307,883,1051,949,995,([$S_1$],[$S_4$],[$S_3$],[$S_2$]))
  wire(((112,883),(257,883)));wire(((112,1051),(257,1051)))
  battery(112,968);wire(((112,883),(112,946)));wire(((112,990),(112,1051)))
  wire(((192,883),(192,950)));cap(192,968);wire(((192,986),(192,1051)))
  dot(192,883);dot(192,1051);lab(83,968,[$V_L$]);lab(159,968,[$C_"in"$])
  cross(257,333,949,307);ind(333,949,n:3,pitch:6,depth:4);lab(345,936,[$L_k$],size:7.8pt)
  wire(((351,949),(373,949)));wire(((307,995),(373,995)))
  trafo(373,399,949,46)
  wire(((399,949),(465,949)));cross(399,515,995,465)
  wire(((465,883),(627,883)));wire(((465,1051),(627,1051)))
  for x in (465,515) {
    wire(((x,883),(x,891)));diode(x,913);wire(((x,935),(x,998)));diode(x,1020);wire(((x,1042),(x,1051)))
  }
  wire(((568,883),(568,950)));cap(568,968);wire(((568,986),(568,1051)))
  wire(((627,883),(627,951)));res(627,968);wire(((627,984),(627,1051)))
  for (x,y) in ((465,949),(515,995),(515,883),(515,1051),(568,883),(568,1051)) {dot(x,y)}
  lab(441,904,[$D_1$]);lab(490,904,[$D_4$]);lab(441,1017,[$D_3$]);lab(490,1017,[$D_2$]);lab(540,971,[$C_o$]);lab(603,971,[$R_o$]);lab(656,971,[$V_H$]);lab(387,1080,[(c)])
  // Legend: the drawn ideal switch represents a MOSFET/body diode.
  block(479,1088,104,66,c:"#ffffcf")
  wire(((493,1099),(493,1113),(504,1128)));wire(((493,1132),(493,1144)))
  lab(519,1123,[$equiv$],size:12pt);mos(548,1122,body:true)
  // (d) dual active bridge, both sides switching.
  lab(378,1183,[Power Flow],weight:"bold",size:10.3pt)
  lab(378,1211,[B to A],size:8.5pt);arrow((412,1223),(342,1223))
  lab(378,1234,[A to B],size:8.5pt);arrow((342,1244),(412,1244))
  lab(169,1238,[DC Bus A],size:8.5pt);lab(588,1238,[DC Bus B],size:8.5pt)
  dc(225,1250,99,99,left:[DC],right:[AC]);dc(434,1250,99,99,left:[AC],right:[DC])
  wire(((164,1263),(225,1263)));wire(((164,1335),(225,1335)))
  wire(((533,1263),(592,1263)));wire(((533,1335),(592,1335)))
  bus-terminals(164,1263,1335,[$V_L$]);bus-terminals(592,1263,1335,[$V_H$],left:false)
  wire(((324,1270),(360,1270)));wire(((324,1330),(360,1330)))
  trafo(360,398,1270,60,lead:5);wire(((398,1270),(434,1270)));wire(((398,1330),(434,1330)))
  lab(388,1392,[Dual Active Bridge DC-DC Converter])
  bridge(242,293,1421,1590,1486,1533,([$S_1$],[$S_4$],[$S_3$],[$S_2$]))
  bridge(449,499,1421,1590,1486,1533,([$S_5$],[$S_8$],[$S_7$],[$S_6$]))
  wire(((111,1421),(242,1421)));wire(((111,1590),(242,1590)))
  battery(111,1510);wire(((111,1421),(111,1488)));wire(((111,1532),(111,1590)))
  wire(((186,1421),(186,1492)));cap(186,1510);wire(((186,1528),(186,1590)))
  dot(186,1421);dot(186,1590)
  cross(242,322,1486,293);ind(322,1486,n:2,pitch:7,depth:4);wire(((336,1486),(367,1486)))
  wire(((293,1533),(367,1533)));trafo(367,391,1486,47)
  wire(((391,1486),(449,1486)));cross(391,499,1533,449)
  wire(((499,1421),(624,1421)));wire(((499,1590),(624,1590)))
  wire(((560,1421),(560,1492)));cap(560,1510);wire(((560,1528),(560,1590)))
  wire(((624,1421),(624,1494)));res(624,1510);wire(((624,1526),(624,1590)))
  dot(560,1421);dot(560,1590)
  lab(80,1510,[$V_L$]);lab(157,1510,[$C_"in"$]);lab(333,1474,[$L_k$],size:7.8pt)
  lab(535,1510,[$C_o$]);lab(599,1510,[$R_o$]);lab(655,1510,[$V_H$]);lab(387,1614,[(d)])
'''

fig4=r'''
  // (a) capacitive/inductive inputs, switch and rectifying options.
  lab(134,35,[Input Stage])
  wire(((81,68),(187,68)));wire(((81,183),(187,183)))
  wire(((129,68),(129,107)));cap(129,125);wire(((129,143),(129,183)))
  for y in (68,183) {port(81,y);port(187,y);dot(129,y)}
  lab(81,82,[$+$]);lab(81,171,[$-$]);lab(69,128,[$V_"in"$]);lab(164,128,[$C_"in"$]);lab(207,68,[A]);lab(207,183,[B])
  wire(((81,236),(111,236)));ind(111,236,n:4);wire(((155,236),(187,236)))
  wire(((81,353),(192,353)))
  for y in (236,353) {port(81,y)}
  port(187,236);port(192,353)
  lab(81,251,[$+$]);lab(81,339,[$-$]);lab(69,296,[$V_"in"$]);lab(137,259,[$L_"in"$]);lab(207,237,[A]);lab(210,353,[B])
  lab(341,110,[Switching\ Device(s)])
  block(296,143,90,141)
  wire(((262,156),(296,156)));wire(((386,156),(416,156)))
  wire(((262,271),(296,271)));wire(((386,271),(416,271)))
  for (x,y) in ((262,156),(416,156),(262,271),(416,271)) {port(x,y)}
  lab(262,140,[A]);lab(262,291,[B]);lab(420,140,[$A'$]);lab(420,291,[$B'$])
  wire(((336,190),(336,207),(351,229)));wire(((336,232),(336,250)))
  let blue=rgb("#8bccdc")
  arrow((195,142),(257,193),c:blue,t:3.5pt,w:19)
  arrow((195,292),(257,240),c:blue,t:3.5pt,w:19)
  arrow((418,193),(479,158),c:blue,t:3.5pt,w:19)
  arrow((418,231),(479,266),c:blue,t:3.5pt,w:19)
  lab(585,33,[Voltage Extension\ and Rectification])
  block(533,68,106,141)
  wire(((494,84),(533,84)));wire(((494,194),(533,194)))
  wire(((639,84),(676,84)));wire(((639,194),(676,194)))
  port(494,84);port(494,194);bus-terminals(676,84,194,[$V_"out"$],left:false)
  lab(475,84,[$A'$]);lab(475,194,[$B'$])
  for y in (97,127) {
    ind(565,y,n:4);dot(559,y - 7)
    wire(((565,y - 15),(613,y - 15)));wire(((565,y - 10),(613,y - 10)))
  }
  diode-h(584,150);cap-h(584,181)
  lab(608,241,[Rectifier\ Module])
  block(563,272,90,100)
  wire(((485,290),(511,290)));wire(((485,358),(511,358)))
  trafo(511,543,290,68,lead:6)
  wire(((543,290),(563,290)));wire(((543,358),(563,358)))
  port(485,290);port(485,358);lab(466,291,[$A'$]);lab(466,357,[$B'$])
  diode(593,322);cap(625,322)
  wire(((653,285),(681,285)));wire(((653,361),(681,361)))
  bus-terminals(681,285,361,[$V_"out"$],left:false);lab(379,386,[(a)])
  // (b) voltage fed bridge with voltage source and capacitor.
  bridge(253,308,442,630,515,566,([$S_1$],[$S_4$],[$S_3$],[$S_2$]))
  wire(((117,442),(253,442)));wire(((117,630),(253,630)))
  wire(((117,442),(117,519)));wire(((117,551),(117,630)))
  input-circle(117,535);lab(58,539,[Input\ Source])
  wire(((183,442),(183,517)));cap(183,535);wire(((183,553),(183,630)))
  dot(183,442);dot(183,630);lab(158,517,[$C_"in"$])
  cross(253,353,515,308);wire(((308,566),(353,566)));trafo(353,380,515,51)
  wire(((380,515),(418,515)));wire(((380,566),(418,566)))
  block(418,456,90,170,c:"#ffffcf");lab(465,434,[Rectifier])
  diode(463,543)
  wire(((508,470),(523,470)));ind(523,470,n:3);wire(((556,470),(634,470)))
  wire(((508,612),(634,612)))
  wire(((577,470),(577,525)));cap(577,543);wire(((577,561),(577,612)))
  wire(((634,470),(634,527)));res(634,543);wire(((634,559),(634,612)))
  dot(577,470);dot(577,612);lab(543,448,[$L_f$]);lab(551,543,[$C_f$]);lab(612,543,[$R_o$]);lab(684,543,[Output]);lab(379,656,[(b)])
  // (c) current fed bridge with a current source and input inductor.
  bridge(253,308,726,913,799,850,([$S_1$],[$S_4$],[$S_3$],[$S_2$]))
  wire(((120,726),(151,726)));ind(151,726,n:4);wire(((195,726),(253,726)))
  wire(((120,913),(253,913)))
  wire(((120,726),(120,803)));wire(((120,835),(120,913)))
  input-circle(120,819,current:true);lab(59,825,[Input\ Source]);lab(172,703,[$L_"in"$])
  cross(253,361,799,308);wire(((308,850),(361,850)));trafo(361,389,799,51)
  wire(((389,799),(418,799)));wire(((389,850),(418,850)))
  block(418,740,90,169,c:"#ffffcf");lab(466,720,[Rectifier]);diode(463,827)
  wire(((508,753),(628,753)));wire(((508,895),(628,895)))
  wire(((570,753),(570,809)));cap(570,827);wire(((570,845),(570,895)))
  wire(((628,753),(628,811)));res(628,827);wire(((628,843),(628,895)))
  dot(570,753);dot(570,895);lab(543,827,[$C_f$]);lab(604,827,[$R_o$]);lab(681,827,[Output]);lab(379,928,[(c)])
  // (d) auxiliary-transformer input with isolated/nonisolated alternatives.
  lab(109,975,[Auxiliary\ Transformer],size:8.9pt)
  rect(P(76,998),P(145,1047),radius:3*s,fill:rgb("#f1dcda"),stroke:1pt)
  ind(89,1009,n:4,d:1);ind(89,1036,n:4)
  for y in (1019,1024) {wire(((89,y),(133,y)))}
  dot(84,1015);dot(137,1030)
  wire(((59,1022),(76,1022)))
  wire(((145,1013),(235,1013),(235,1042)));winding(235,1042,44)
  wire(((145,1033),(179,1033),(179,1044)));winding(179,1044,44)
  wire(((179,1088),(179,1173),(194,1195)));wire(((179,1199),(179,1217)))
  wire(((235,1086),(235,1173),(250,1195)));wire(((235,1199),(235,1217)))
  wire(((59,1022),(59,1104)));battery(59,1126);wire(((59,1148),(59,1217),(235,1217)))
  cross(179,266,1099,235);wire(((235,1155),(266,1155)))
  port(266,1099);port(266,1155);dot(179,1099);dot(235,1155);dot(179,1217)
  lab(25,1126,[$V_"in"$]);lab(161,1065,[$L_1$]);lab(217,1065,[$L_2$]);lab(262,1083,[A]);lab(264,1174,[B]);lab(159,1184,[$S_1$]);lab(217,1184,[$S_2$])
  arrow((279,1110),(323,1070),c:blue,t:3.5pt,w:17)
  arrow((279,1139),(323,1182),c:blue,t:3.5pt,w:17)
  rect(P(354,1003),P(434,1083),radius:3*s,fill:rgb("#f1dcda"),stroke:1pt)
  wire(((335,1014),(354,1014)));wire(((335,1071),(354,1071)))
  wire(((434,1014),(452,1014)));wire(((434,1071),(452,1071)))
  trafo(378,407,1016,54,ratio:false)
  for (x,y) in ((335,1014),(335,1071),(452,1014),(452,1071)) {port(x,y)}
  lab(335,998,[A]);lab(335,1091,[B]);lab(452,998,[$A'$]);lab(452,1091,[$B'$])
  wire(((345,1170),(438,1170)));wire(((344,1226),(438,1226)))
  for (x,y) in ((345,1170),(438,1170),(344,1226),(438,1226)) {port(x,y)}
  lab(345,1156,[A]);lab(438,1156,[$A'$]);lab(344,1246,[B]);lab(438,1246,[$B'$])
  arrow((451,1046),(496,1084),c:blue,t:3.5pt,w:17)
  arrow((451,1186),(496,1150),c:blue,t:3.5pt,w:17)
  lab(578,1027,[Rectifier\ Module]);block(528,1056,100,144)
  wire(((507,1099),(528,1099)));wire(((507,1155),(528,1155)))
  port(507,1099);port(507,1155);lab(514,1079,[$A'$]);lab(514,1175,[$B'$])
  diode(559,1128);cap(597,1128)
  wire(((628,1078),(678,1078),(678,1117)));res(678,1133);wire(((678,1149),(678,1178),(628,1178)))
  lab(653,1133,[$R_o$]);lab(717,1133,[$V_"out"$]);lab(379,1287,[(d)])
'''

for name,height,body in [('pdf031-directional-converters',1650,fig3),('pdf032-voltage-current-fed',1326,fig4)]:
    (batch/f'typ/{name}.typ').write_text(header.replace('HEIGHT',str(height))+body+'\n})\n',encoding='utf-8')
print('Wrote two complete figures as standalone native CeTZ.')
