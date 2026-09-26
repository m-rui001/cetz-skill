#set page(width:auto,height:auto,margin:10pt)
#import "@preview/cetz:0.4.2":canvas,draw
#set text(font:"Calibri",size:10.5pt)
#set par(leading:0pt)
#let turn-text=rotate
#canvas(length:1pt,{
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
