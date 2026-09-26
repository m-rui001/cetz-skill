#set page(width:auto,height:auto,margin:2pt)
#import "@preview/cetz:0.4.2":canvas,draw
#set text(font:"Times New Roman",size:9.5pt)
#set par(leading:4.4pt)
#canvas(length:1pt,{
  import draw:*
  let s=.44
  let P=(x,y)=>(s*x,s*(1650 - y))
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

})
