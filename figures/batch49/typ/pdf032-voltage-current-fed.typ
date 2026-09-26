#set page(width:auto,height:auto,margin:2pt)
#import "@preview/cetz:0.4.2":canvas,draw
#set text(font:"Times New Roman",size:9.5pt)
#set par(leading:4.4pt)
#canvas(length:1pt,{
  import draw:*
  let s=.44
  let P=(x,y)=>(s*x,s*(1326 - y))
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

})
