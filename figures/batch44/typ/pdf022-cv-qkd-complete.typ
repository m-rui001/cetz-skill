#set page(width:auto,height:auto,margin:5pt)
#import "@preview/cetz:0.4.2":canvas,draw
// Native panel copied from batch40/pdf020-transmitted-lo-cv-qkd.typ
#let panel-0() = {
set text(font:"Calibri",size:10.5pt)
set par(leading:0pt)
let turn-text=rotate
canvas(length:1pt,{
  import draw:*
  let P=(x,y)=>(.4*x,.4*(837 - y))
  let red=rgb("#ee0015")
  let green=rgb("#00ef00")
  let thin=(thickness:.9pt)
  let label=(x,y,c,size:10.5pt,angle:-34deg,fill:black,weight:"bold")=>content(P(x,y),turn-text(angle,text(size:size,fill:fill,weight:weight,c)))
  let path=(pts,color)=>line(..pts.map(p=>P(..p)),stroke:(paint:color,thickness:.85pt))
  let curve=(a,b,c,d,color)=>bezier(P(..a),P(..b),P(..c),P(..d),stroke:(paint:color,thickness:.85pt))
  let arrow=(a,b,width:.9pt)=>{
    line(P(..a),P(..b),stroke:width)
    let dx=b.at(0) - a.at(0)
    let dy=b.at(1) - a.at(1)
    let n=calc.sqrt(dx*dx + dy*dy)
    let ux=dx/n
    let uy=dy/n
    let x=b.at(0) - 29*ux
    let y=b.at(1) - 29*uy
    line(P(..b),P(x - uy*8,y + ux*8),P(x + uy*8,y - ux*8),close:true,fill:black,stroke:none)
    line(P(x + 10*ux,y + 10*uy),P(x + 18*ux - uy*6,y + 18*uy + ux*6),P(x + 18*ux + uy*6,y + 18*uy - ux*6),close:true,fill:white,stroke:none)
  }
  let box=(a,b,c,d,h,l,size:10.5pt)=>{
    let lower=p=>(p.at(0),p.at(1) + h)
    line(P(..a),P(..d),P(..lower(d)),P(..lower(a)),close:true,fill:rgb("#606060"),stroke:.35pt)
    line(P(..d),P(..c),P(..lower(c)),P(..lower(d)),close:true,fill:rgb("#242424"),stroke:.35pt)
    // A few grey bands approximate the lit top face while remaining native vectors.
    for i in range(12) {
      let t=i/12
      let t2=(i + 1)/12
      let at=(p,q,s)=>(p.at(0) + (q.at(0) - p.at(0))*s,p.at(1) + (q.at(1) - p.at(1))*s)
      let shade=int(90 + 74*calc.sin(180deg*(t + t2)/2))
      line(P(..at(a,d,t)),P(..at(b,c,t)),P(..at(b,c,t2)),P(..at(a,d,t2)),close:true,fill:rgb(shade,shade,shade),stroke:none)
    }
    line(P(..a),P(..b),P(..c),P(..d),close:true,stroke:.35pt)
    let x=(a.at(0) + b.at(0) + c.at(0) + d.at(0))/4
    let y=(a.at(1) + b.at(1) + c.at(1) + d.at(1))/4
    label(x,y,l,size:size,fill:white)
  }
  let cylinder=(a,b,r)=>{
    let dx=b.at(0) - a.at(0)
    let dy=b.at(1) - a.at(1)
    let n=calc.sqrt(dx*dx + dy*dy)
    let ux=dx/n
    let uy=dy/n
    let vx=-uy
    let vy=ux
    let Q=(p,s)=>(p.at(0) + vx*r*s,p.at(1) + vy*r*s)
    for i in range(20) {
      let s=-1 + i/10
      let s2=s + .1
      let shade=int(43 + 130*calc.sin(180deg*(s + s2 + 2)/4))
      line(P(..Q(a,s)),P(..Q(b,s)),P(..Q(b,s2)),P(..Q(a,s2)),close:true,fill:rgb(shade,shade,shade),stroke:none)
    }
    line(P(..Q(a,-1)),P(..Q(b,-1)),stroke:.35pt)
    line(P(..Q(a,1)),P(..Q(b,1)),stroke:.35pt)
    for (p,shade) in ((b,112),(a,110)) {
      let pts=range(49).map(i=>{let t=i*360deg/48;P(p.at(0) + ux*r*.5*calc.cos(t) + vx*r*calc.sin(t),p.at(1) + uy*r*.5*calc.cos(t) + vy*r*calc.sin(t))})
      line(..pts,close:true,fill:rgb(shade,shade,shade),stroke:.35pt)
    }
  }
  let photodiode=(x,y)=>{
    circle(P(x - 5,y - 3),radius:(7.5,11.5),fill:rgb("#4b4b4b"),stroke:.35pt)
    circle(P(x,y),radius:(6.8,10.8),fill:rgb("#888888"),stroke:.35pt)
  }
  let coil=(a,b)=>{
    let dx=b.at(0) - a.at(0)
    let dy=b.at(1) - a.at(1)
    for t in (0,.5,1) {circle(P(a.at(0) + dx*t,a.at(1) + dy*t),radius:(6.1,4.1),stroke:.85pt)}
  }
  // Rounded outline of the two diagonally oriented benches.
  line(P(80,601),P(910,36),stroke:1.3pt)
  bezier(P(910,36),P(1025,35),P(955,2),P(990,13),stroke:1.3pt)
  line(P(1025,35),P(1182,140),stroke:1.3pt)
  bezier(P(1182,140),P(1186,218),P(1233,166),P(1223,191),stroke:1.3pt)
  line(P(1186,218),P(363,783),stroke:1.3pt)
  bezier(P(363,783),P(270,804),P(323,811),P(306,817),stroke:1.3pt)
  line(P(270,804),P(80,682),stroke:1.3pt)
  bezier(P(80,682),P(80,601),P(34,654),P(50,627),stroke:1.3pt)
  line(P(665,593),P(1406,87),stroke:1.3pt)
  bezier(P(1406,87),P(1528,79),P(1452,53),P(1487,64),stroke:1.3pt)
  line(P(1528,79),P(1708,199),stroke:1.3pt)
  bezier(P(1708,199),P(1691,276),P(1748,226),P(1724,257),stroke:1.3pt)
  line(P(1691,276),P(950,791),stroke:1.3pt)
  bezier(P(950,791),P(857,805),P(908,820),P(891,815),stroke:1.3pt)
  line(P(857,805),P(659,676),stroke:1.3pt)
  bezier(P(659,676),P(665,593),P(622,650),P(634,619),stroke:1.3pt)
  label(348,758,[Alice],size:19pt)
  label(928,756,[Bob],size:19pt)

  // Signal and local oscillator on Alice's bench.
  path(((199,639),(243,608)),black)
  curve((304,559),(342,486),(354,525),(259,522),red)
  path(((342,486),(418,435),(462,401)),red)
  path(((567,341),(612,309)),red)
  curve((717,231),(833,213),(756,211),(746,263),red)
  curve((833,213),(765,320),(756,257),(851,262),red)
  path(((469,521),(554,464),(628,411),(711,356)),red)
  curve((711,356),(791,402),(650,399),(730,457),red)
  path(((884,179),(1042,71)),red)
  curve((304,559),(354,558),(332,544),(334,546),green)
  curve((354,558),(476,484),(385,566),(443,491),green)
  curve((476,484),(469,521),(511,471),(500,506),green)
  curve((417,557),(506,710),(328,605),(411,650),black)
  bezier(P(506,710),P(751,764),P(619,795),P(654,837),stroke:(thickness:1pt,dash:(array:(1pt,2pt))))
  path(((751,764),(820,714),(869,683),(967,613)),black)
  curve((869,683),(879,499),(1042,603),(716,574),black)
  arrow((879,499),(966,438))
  arrow((797,400),(884,340))
  // Multiplexed path, phase randomization and homodyne branches on Bob's bench.
  path(((1079,580),(1103,518),(1155,485)),black)
  curve((1155,485),(1295,475),(1222,439),(1228,526),green)
  curve((1155,485),(1197,385),(1241,448),(1123,442),green)
  curve((1248,351),(1446,359),(1313,303),(1387,414),green)
  path(((1397,405),(1446,359),(1495,324),(1679,210)),green)
  curve((1248,351),(1301,263),(1332,302),(1220,307),black)
  curve((1248,351),(1376,315),(1323,298),(1311,366),black)
  curve((1301,263),(1431,224),(1397,190),(1352,283),black)
  curve((1376,315),(1431,224),(1459,282),(1367,265),black)

  // Devices preserve every component in the original image.
  line(P(140,624),P(233,637),P(157,685),close:true,fill:rgb("#fff200"),stroke:1.2pt)
  circle(P(176,650),radius:3.3,fill:black,stroke:none)
  for i in range(16) {let a=i*360deg/16;line(P(176 + 8*calc.cos(a),650 + 8*calc.sin(a)),P(176 + 22*calc.cos(a),650 + 22*calc.sin(a)),stroke:.45pt)}
  label(217,674,[L])
  for (a,b,r,x,y,l) in (
    ((243,601),(300,563),16,300,610,[1/99]),
    ((342,480),(418,427),23,408,501,[VATT]),
    ((417,557),(469,521),17,475,567,[PBS]),
    ((554,464),(628,411),24,624,485,[VATT]),
    ((711,356),(765,320),17,710,311,[50/50]),
    ((833,213),(884,179),17,869,237,[PBS]),
    ((820,714),(869,683),17,879,737,[10/90]),
    ((1103,518),(1155,485),17,1144,548,[PBS]),
    ((1197,385),(1248,351),17,1195,328,[50/50]),
    ((1446,359),(1495,324),17,1500,389,[PBS])
  ) {cylinder(a,b,r);label(x,y,l)}
  box((447,366),(535,307),(566,328),(477,389),41,[AM],size:12pt)
  box((597,264),(686,205),(717,226),(627,286),40,[PM],size:12pt)
  box((944,589),(1034,531),(1079,557),(989,619),22,[DPC],size:12pt)
  box((1279,440),(1369,380),(1399,402),(1310,460),40,[PM],size:12pt)
  box((1025,40),(1041,28),(1071,49),(1054,60),40,[],size:1pt)
  box((1663,180),(1677,166),(1709,188),(1692,199),38,[],size:1pt)
  path(((1007,95),(1042,71)),red)
  path(((1643,233),(1679,210)),green)
  for (x,y) in ((797,400),(879,499),(1301,263),(1376,315)) {photodiode(x,y)}
  path(((785,408),(797,400)),red)
  path(((865,509),(879,499)),black)
  path(((1287,273),(1301,263)),black)
  path(((1363,324),(1376,315)),black)
  for (x,y) in ((828,452),(920,544),(1265,237),(1353,286)) {label(x,y,[PIN])}
  coil((955,126),(992,103))
  coil((1577,279),(1614,255))
  label(1004,136,[20m])
  label(1627,291,[20m])
  label(992,62,[FM])
  label(1630,198,[FM])
  label(914,274,[Feedback],size:13pt)
  label(952,313,[control],size:13pt)
  label(993,390,[Clock],size:13pt)
  label(1060,430,[generation],size:13pt)
  circle(P(1446,214),radius:(12.4,8),fill:white,stroke:1pt)
  line(P(1440,216),P(1454,206),stroke:1.3pt)
  arrow((1470,199),(1539,149))
  label(1403,134,[Homodyne],size:13pt)
  label(1442,175,[Detection],size:13pt)

  // Unrotated legend uses the same colour meanings as the source.
  for (y,color,c) in ((50,red,[Signal]),(100,green,[Local Oscillator]),(150,black,[Signal + LO])) {
    line(P(103,y),P(141,y),stroke:(paint:color,thickness:.9pt))
    content(P(152,y),text(size:13pt,c),anchor:"west")
  }
  for (y,c) in ((466,[L: Laser]),(515,[FM: Faraday Mirror]),(565,[PIN: PIN photodiode]),(613,[PM: Phase Modulator]),(663,[AM: Amplitude Modulator]),(711,[VATT: Variable Attenuator]),(761,[PBS: Polarization Beam Splitter]),(809,[DPC: Dynamic Polarization Controller])) {
    content(P(1782,y),text(size:12.5pt,c),anchor:"east")
  }
})
}
// Native panel copied from batch37/pdf015-local-lo-cv-qkd.typ
#let panel-1() = {
set text(font:"Calibri",size:9pt)
canvas(length:1pt,{
  import draw:*
  let P=(x,y)=>(.5*x,.5*(584 - y))
  let red=rgb("#ff0000")
  let green=rgb("#053a08")
  let orange=rgb("#f4a147")
  let cyan=rgb("#53d4f5")
  let label=(x,y,c,size:9pt,weight:"bold",fill:black)=>content(P(x,y),text(size:size,weight:weight,fill:fill,c))
  let wire=(paint:red,thickness:.9pt)
  let dashed=(thickness:.55pt,dash:(array:(2pt,1.4pt)))
  let arrow=(a,b,color:black,width:.6pt,dash:none,head:8)=>{
    line(P(..a),P(..b),stroke:(paint:color,thickness:width,dash:dash))
    let dx=b.at(0) - a.at(0)
    let dy=b.at(1) - a.at(1)
    let n=calc.sqrt(dx*dx + dy*dy)
    let ux=dx/n
    let uy=dy/n
    let x=b.at(0) - ux*head
    let y=b.at(1) - uy*head
    line(P(..b),P(x - uy*head*.4,y + ux*head*.4),P(x + uy*head*.4,y - ux*head*.4),close:true,fill:color,stroke:none)
  }
  let rr=(x,y,w,h,r,color)=>{
    let pts=()
    for (cx,cy,a) in ((x + w - r,y + r,-90deg),(x + w - r,y + h - r,0deg),(x + r,y + h - r,90deg),(x + r,y + r,180deg)) {
      for i in range(7) {let t=a + i*90deg/6;pts.push(P(cx + r*calc.cos(t),cy + r*calc.sin(t)))}
    }
    line(..pts,close:true,fill:color,stroke:.4pt)
  }
  let laser=(x,y,color)=>{
    rr(x,y,93,41,9,color)
    label(x + 46.5,y + 21,[CW Laser],size:9pt,fill:white)
  }
  let mod=(x,y,w,c)=>{
    rect(P(x,y),P(x + w,y + 44),fill:cyan,stroke:(thickness:.4pt,dash:(array:(.6pt,.7pt))))
    line(P(x + 15,y + 22),P(x + 30,y + 10),P(x + w - 20,y + 10),P(x + w - 6,y + 22),P(x + w - 20,y + 35),P(x + 30,y + 35),close:true,fill:orange,stroke:none)
    label(x + w/2 + 4,y + 22,c,size:9pt)
  }
  let iso=(x,y)=>{
    rect(P(x,y),P(x + 40,y + 13),fill:white,stroke:1pt)
    arrow((x + 6,y + 6.5),(x + 30,y + 6.5),color:red,width:.7pt)
    label(x + 20,y + 27,[Isolator],size:8pt)
  }
  rect(P(49,25),P(548,303),stroke:dashed)
  rect(P(660,25),P(1155,303),stroke:dashed)
  label(96,45,[Alice],size:12pt,fill:red)
  label(704,45,[Bob],size:12pt,fill:red)
  line(P(147,133),P(1049,133),stroke:wire)
  line(P(762,209),P(1049,209),P(1049,133),stroke:wire)
  laser(54,113,red)
  laser(669,189,rgb("#003bd3"))
  mod(159,110,87,[AM])
  rect(P(258,110),P(406,154),fill:cyan,stroke:(thickness:.4pt,dash:(array:(.6pt,.7pt))))
  for (x,l) in ((297,[PM]),(371,[AM])) {
    line(P(x - 35,132),P(x - 22,120),P(x + 22,120),P(x + 35,132),P(x + 22,145),P(x - 22,145),close:true,fill:orange,stroke:none)
    label(x,133,l,size:9pt)
  }
  line(P(332,133),P(336,133),stroke:wire)
  mod(774,186,87,[AM])
  mod(876,186,79,[PM])
  arrow((148,133),(174,133),color:red,width:.9pt)
  arrow((762,209),(790,209),color:red,width:.9pt)
  rect(P(416,116),P(450,150),fill:rgb("#00f400"),stroke:.6pt)
  line(P(416,116),P(450,150),stroke:.5pt)
  label(433,99,[BS],size:9pt)
  rect(P(462,122),P(493,145),fill:black,stroke:none)
  label(478,107,[VOA],size:9pt)
  iso(500,127)
  for dx in (-9,0,9) {circle(P(603 + dx,107),radius:(14,13.5),stroke:(paint:red,thickness:.6pt))}
  label(602,63,[SM Fiber],size:9pt)
  line(P(433,133),P(433,206),P(474,206),stroke:wire)
  let pts=(P(472,192),P(481,192))
  for i in range(17) {let a=-90deg + i*180deg/16;pts.push(P(481 + 12*calc.cos(a),206 + 14*calc.sin(a)))}
  pts.push(P(472,220))
  line(..pts,close:true,fill:rgb("#ffc600"),stroke:.6pt)
  label(512,207,[PD],size:9pt)
  arrow((337,86),(372,86),color:red)
  label(307,86,[Signal],size:9pt)
  arrow((882,111),(919,111),color:red)
  label(852,111,[Signal],size:9pt)
  arrow((882,171),(919,171),color:red)
  label(866,171,[LO],size:9pt)
  for x in (750,774,798) {circle(P(x,123),radius:5.2,stroke:(paint:red,thickness:.6pt));circle(P(x,123),radius:.7,stroke:(paint:red,thickness:.4pt))}
  line(P(725,134),P(819,134),stroke:(paint:red,thickness:2pt))
  label(774,99,[PC],size:9pt)
  for x in (972,980,988) {circle(P(x,199),radius:5.5,stroke:(paint:red,thickness:.6pt))}
  label(978,170,[Delay line],size:9pt)
  iso(1007,203)
  rect(P(1026,53),P(1132,158),fill:cyan,stroke:(thickness:.5pt,dash:(array:(.7pt,.6pt))))
  line(P(1050,71),P(1050,133),P(1113,133),P(1113,71),P(1050,71),stroke:.7pt)
  rect(P(1033,116),P(1067,150),fill:rgb("#00f400"),stroke:.7pt)
  line(P(1033,116),P(1067,150),stroke:.5pt)
  line(P(1049,133),P(1113,133),stroke:wire)
  line(P(1049,209),P(1049,133),stroke:wire)
  label(1075,107,[BS],size:9pt)
  for (x,y,angle) in ((1050,71,-90deg),(1113,133,0deg)) {
    circle(P(x,y),radius:6,fill:rgb("#fbe9d5"),stroke:.6pt)
    let pts=range(3).map(i=>{let a=angle + i*120deg;P(x + 10*calc.cos(a),y + 10*calc.sin(a))})
    line(..pts,close:true,fill:black,stroke:none)
  }
  circle(P(1113,71),radius:5.5,fill:white,stroke:(paint:rgb("#2f4386"),thickness:.8pt))
  line(P(1108,71),P(1118,71),stroke:(paint:rgb("#2f4386"),thickness:.8pt))
  arrow((1119,71),(1150,71),color:rgb("#00296d"))
  label(1101,187,[Homodyne#linebreak()detector],size:9pt)
  let note=(x,y,c,b)=>{
    label(x,y,c,size:9pt)
    let a=(x + 33,y + 5)
    line(P(..a),P(b.at(0),a.at(1)),stroke:(thickness:.65pt,dash:(array:(.8pt,1.2pt))))
    arrow((b.at(0),a.at(1)),b,dash:(array:(.8pt,1.2pt)))
  }
  note(123,276,[Pulse#linebreak()modulation],(202,160))
  label(421,276,[Gaussian#linebreak()modulation],size:9pt)
  line(P(365,277),P(335,277),P(335,161),stroke:(thickness:.65pt,dash:(array:(.8pt,1.2pt))))
  arrow((335,169),(335,160))
  note(741,276,[Pulse#linebreak()modulation],(818,231))
  label(1008,276,[Randomly#linebreak()choose X or P],size:9pt)
  line(P(941,277),P(915,277),P(915,231),stroke:(thickness:.65pt,dash:(array:(.8pt,1.2pt))))
  arrow((915,239),(915,230))
  circle(P(650,133),radius:(3.8,6.5),stroke:(thickness:.6pt,dash:(array:(.8pt,.8pt))))
  arrow((650,147),(604,326),width:.9pt,head:17)

  // Three conceptual timing patterns; these are not measured-data plots.
  for (x1,x2,l) in ((30,378,[(a)]),(431,777,[(b)]),(827,1173,[(c)])) {
    rect(P(x1,340),P(x2,567),stroke:dashed)
    label(x1 + 42,369,l,size:12pt,fill:red)
    arrow((x1 + 11,495),(x2 - 12,495))
  }
  for (x,y) in ((55,404),(90,430),(127,397),(164,411)) {rect(P(x,y),P(x + 18,495),fill:green,stroke:none)}
  for (x,y) in ((201,490),(239,492),(277,489),(315,492)) {rect(P(x,y),P(x + 19,495),fill:red,stroke:none)}
  line(P(184,501),P(184,555),stroke:(thickness:.6pt,dash:(array:(1pt,1pt))))
  label(124,527,[Stabilization#linebreak()pulses],size:9pt)
  label(270,518,[Quantum signals],size:9pt)
  label(307,416,[100 MHz#linebreak()Rep. rate],size:9pt)
  for x in (286,326) {line(P(x,441),P(x,491),stroke:(thickness:.6pt,dash:(array:(1pt,1pt))))}
  arrow((250,452),(286,452))
  arrow((361,452),(326,452))
  for (x,y) in ((454,405),(527,398),(601,411),(677,377),(850,404),(958,357),(1034,445),(1073,404)) {rect(P(x,y),P(x + 18,495),fill:green,stroke:none)}
  for (x,y) in ((489,488),(562,492),(638,492),(714,492),(885,489),(923,485),(996,490),(1111,492)) {rect(P(x,y),P(x + 19,495),fill:red,stroke:none)}
  // The c-panel has a taller red pulse at its second quantum-signal position.
  rect(P(923,486),P(942,495),fill:red,stroke:none)
  label(589,363,[Stabilization pulses],size:9pt)
  label(1081,363,[Stabilization pulses],size:9pt)
  label(607,539,[Quantum signals],size:9pt)
  label(1004,539,[Quantum signals],size:9pt)
  for (a,b) in (((505,378),(480,400)),((563,378),(546,392)),((600,378),(609,405)),((646,378),(673,398)),((1025,378),(985,405)),((1047,385),(1042,439)),((1073,378),(1085,400)),((520,526),(508,506)),((566,526),(572,505)),((639,526),(647,506)),((677,526),(720,505)),((940,526),(914,505)),((980,526),(949,505)),((1000,526),(1008,505)),((1080,526),(1117,505))) {arrow(a,b,width:.4pt)}
})
}
// Native panel copied from batch39/pdf017-software-defined-qkd.typ
#let panel-2() = {
set text(font:"Cambria",size:11pt)
let turn-text=rotate
canvas(length:1pt,{
  import draw:*
  let P=(x,y)=>(.5*x,.5*(300 - y))
  let wire=(thickness:.85pt)
  let dashed=(thickness:.85pt,dash:(array:(1.6pt,1.6pt)))
  let yellow=rgb("#ffc400")
  let green=rgb("#00aa48")
  let blue=rgb("#151aff")
  let label=(x,y,c,size:11pt)=>content(P(x,y),text(size:size,c))
  let arrow=(a,b,color:black,width:.85pt,head:17)=>{
    line(P(..a),P(..b),stroke:(paint:color,thickness:width))
    let dx=b.at(0) - a.at(0)
    let dy=b.at(1) - a.at(1)
    let n=calc.sqrt(dx*dx + dy*dy)
    let ux=dx/n
    let uy=dy/n
    let x=b.at(0) - head*ux
    let y=b.at(1) - head*uy
    line(P(..b),P(x - head*.3*uy,y + head*.3*ux),P(x + head*.3*uy,y - head*.3*ux),close:true,fill:color,stroke:none)
  }
  let axes=(x,y,w:120)=>{
    arrow((x,y),(x,y - 44))
    arrow((x,y),(x + w,y))
  }
  let pulse=(x,y,c,w:17,h:29)=>rect(P(x,y - h),P(x + w,y),fill:c,stroke:.8pt)
  let rotate-label=(x,y,c)=>content(P(x,y),turn-text(-90deg,text(size:11.5pt,c)))
  let control=(x,y)=>{
    rect(P(x,y),P(x + 35,y + 31),fill:white,stroke:.8pt)
    for dx in (9,25) {
      arrow((x + dx - 5,y + 6),(x + dx + 2,y + 13),width:.6pt,head:5)
      arrow((x + dx + 1,y + 13),(x + dx + 1,y + 23),width:.6pt,head:6)
      arrow((x + dx - 5,y + 16),(x + dx + 2,y + 23),width:.6pt,head:5)
    }
  }
  rect(P(10,17),P(323,254),stroke:dashed)
  rect(P(1136,34),P(1372,282),stroke:dashed)
  label(1270,11,[Software Defined Receiver],size:11.5pt)
  label(176,277,[Software Defined Transmitter],size:11.5pt)
  rect(P(27,61),P(62,211),stroke:wire)
  rect(P(62,61),P(97,121),stroke:wire)
  rect(P(62,151),P(97,211),stroke:wire)
  rotate-label(44,136,[DSP])
  rotate-label(79,91,[DAC])
  rotate-label(79,181,[DAC])
  line(P(97,91),P(239,91),P(239,113),stroke:wire)
  line(P(97,181),P(239,181),P(239,159),stroke:wire)
  line(P(165,135),P(200,135),stroke:wire)
  control(131,121)
  line(P(200,135),P(223,119),P(277,119),P(305,135),P(277,152),P(222,152),close:true,stroke:wire)
  for y in (120,151) {
    line(P(220,y),P(230,y - 8),P(267,y - 8),P(277,y),P(267,y + 8),P(230,y + 8),close:true,fill:white,stroke:wire)
  }
  line(P(305,135),P(340,135),stroke:wire)
  rect(P(340,121),P(409,151),fill:white,stroke:wire)
  label(374,136,[VOA],size:11.5pt)
  line(P(409,135),P(444,135),stroke:wire)
  rect(P(444,121),P(496,151),fill:white,stroke:wire)
  line(P(496,143),P(688,143),stroke:wire)
  line(P(496,127),P(531,127),P(531,77),P(566,77),stroke:wire)
  control(566,61)
  label(566,31,[Power#linebreak()Monitor],size:11.5pt)
  axes(131,76,w:50)
  pulse(132,76,green)
  axes(131,239,w:50)
  pulse(132,239,green)
  axes(340,76)
  pulse(391,76,yellow,w:35)
  label(408,63,$E_s$)

  // Receiver front end has independent signal and local-oscillator inputs.
  line(P(715,143),P(780,143),stroke:wire)
  line(P(815,143),P(884,143),P(884,151),P(905,151),stroke:wire)
  line(P(750,174),P(884,174),P(884,166),P(905,166),stroke:wire)
  control(715,158)
  for (x,y) in ((791,135),(808,135),(799,151)) {circle(P(x,y),radius:3.9,stroke:wire)}
  label(765,127,$E_s$)
  label(768,192,$E_L$)
  rect(P(905,135),P(955,174),fill:white,stroke:wire)
  line(P(955,151),P(995,151),P(995,143),P(1035,143),stroke:wire)
  line(P(955,166),P(995,166),P(995,174),P(1035,174),stroke:wire)
  rect(P(1035,127),P(1070,190),fill:white,stroke:wire)
  for y in (130,160) {control(1035,y)}
  line(P(1070,159),P(1086,159),stroke:wire)
  line(P(1086,143),P(1110,159),P(1086,174),close:true,fill:white,stroke:wire)
  line(P(1110,159),P(1187,159),stroke:wire)
  circle(P(1146,159),radius:2.2,fill:black,stroke:none)
  axes(716,96)
  pulse(767,96,yellow,w:33)
  label(783,81,$E_s$)
  axes(884,96)
  arrow((901,96),(901,50),color:blue)
  pulse(935,96,yellow,w:34)
  axes(1018,96,w:100)
  pulse(1053,96,green,w:33)
  axes(767,251)
  arrow((783,251),(783,205),color:blue)
  label(804,220,$E_L$)

  rect(P(1147,111),P(1203,205),stroke:wire)
  circle(P(1203,111),radius:8,fill:white,stroke:wire)
  circle(P(1203,205),radius:8,fill:white,stroke:wire)
  for y in (111,205) {
    line(P(1192,y - 11),P(1214,y + 11),stroke:wire)
    line(P(1192,y + 11),P(1214,y - 11),stroke:wire)
  }
  line(P(1219,111),P(1288,111),stroke:wire)
  line(P(1219,205),P(1288,205),stroke:wire)
  rect(P(1187,143),P(1220,174),fill:white,stroke:wire)
  line(P(1187,174),P(1220,143),stroke:wire)
  label(1198,151,[0],size:8pt)
  label(1211,166,[90],size:8pt)
  line(P(1203,143),P(1203,127),stroke:wire)
  line(P(1203,174),P(1203,189),stroke:wire)
  circle(P(1255,159),radius:8,stroke:wire)
  line(P(1239,159),P(1220,159),stroke:wire)
  let sine=range(33).map(i=>P(1243 + i*.75,159 - 5*calc.sin(i*360deg/32)))
  line(..sine,stroke:.7pt)
  rect(P(1288,82),P(1320,143),stroke:wire)
  rect(P(1288,174),P(1320,236),stroke:wire)
  rect(P(1320,82),P(1355,236),stroke:wire)
  rotate-label(1304,112,[ADC])
  rotate-label(1304,205,[ADC])
  rotate-label(1338,159,[DSP])
  // Small waveforms use separate compact axes to avoid entering the ADC block.
  arrow((1229,96),(1229,52))
  arrow((1229,96),(1279,96))
  pulse(1230,96,green)
  arrow((1229,266),(1229,222))
  arrow((1229,266),(1279,266))
  pulse(1230,266,green)
})
}

// Scale native vector content, including stroke widths and text, to PDF placement.
#let panel-at(body,x,y,w,h)=context {
  let measured=measure(body)
  place(top+left,dx:x,dy:y,scale(x:w/measured.width*100%,y:h/measured.height*100%,reflow:true,body))
}
#box(width:359pt,height:363pt)[
  #panel-at(panel-0(),32.17477pt,4.81094pt,309.35300pt,116.77380pt)
  #panel-at(panel-1(),42.50000pt,135.00000pt,286.00000pt,136.00000pt)
  #panel-at(panel-2(),12.00000pt,287.75000pt,344.25000pt,70.50000pt)
  #place(top+left,dx:3.03101pt,dy:8.54036pt)[#text(font:"Calibri",size:8.5pt)[a)]]
  #place(top+left,dx:2.77592pt,dy:134.57039pt)[#text(font:"Calibri",size:8.5pt)[b)]]
  #place(top+left,dx:1.71342pt,dy:293.95239pt)[#text(font:"Calibri",size:8.5pt)[c)]]
]
