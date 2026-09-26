#set page(width:auto,height:auto,margin:2pt)
#set text(font:"Times New Roman",size:7.2pt)
#set par(leading:2pt)
#import "@preview/cetz:0.4.2":canvas,draw
#canvas(length:1pt,{
  import draw:*
  let s=.5
  let P=(x,y)=>(s*(x - 112),s*(1408 - y))
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

  let diode=(x,y,up:true)=>{
    wire(((x,y - 15),(x,y + 15)))
    let d=if up {-1} else {1}
    line(P(x,y + 5*d),P(x - 4,y - 5*d),P(x + 4,y - 5*d),close:true,fill:black,stroke:none)
    wire(((x - 5,y + 6*d),(x + 5,y + 6*d)))
  }
  // Curved lower plate: Bézier midpoint is y+4.75, the precise lead origin.
  let vc=(x,y,top,bot)=>{
    wire(((x,top),(x,y)));wire(((x - 8,y),(x + 8,y)))
    bezier(P(x - 8,y + 10),P(x + 8,y + 10),P(x - 7,y + 3),P(x + 7,y + 3),stroke:.7pt)
    wire(((x,y + 4.75),(x,bot)))
  }
  let hcap=(x,y,left,right)=>{
    bezier(P(x - 7,y - 8),P(x - 7,y + 8),P(x,y - 7),P(x,y + 7),stroke:.7pt)
    wire(((x + 3,y - 8),(x + 3,y + 8)))
    wire(((left,y),(x - 1.75,y)));wire(((x + 3,y),(right,y)))
  }
  let sv=(x,y,top,bot)=>{
    wire(((x,top),(x,y - 7),(x - 10,y + 8)))
    wire(((x,y + 10),(x,bot)))
  }
  let sh=(x,y,left,right,reverse:false)=>{
    wire(((left,y),(x - 8,y)));wire(((x + 8,y),(right,y)))
    if reverse {wire(((x + 8,y),(x - 8,y - 11)))} else {wire(((x - 8,y),(x + 8,y + 11)))}
  }
  let hump=(x,left,right,y)=>{
    wire(((left,y),(x - 4,y)))
    bezier(P(x - 4,y),P(x + 4,y),P(x - 4,y - 7),P(x + 4,y - 7),stroke:.7pt)
    wire(((x + 4,y),(right,y)))
  }
  let ports=(x,top,bot,c,left:true)=>{
    for y in (top,bot) {circle(P(x,y),radius:1.3,fill:white,stroke:.7pt)}
    lab(x,top + 11,[$+$]);lab(x,bot - 12,[$-$])
    lab(x + (if left {-6} else {0}),(top + bot)/2,c)
  }
  let shade=(x,y,w,h,c:"#fff2cb")=>rect(P(x,y),P(x + w,y + h),radius:5*s,fill:rgb(c),stroke:none)
  let faintcoil=(x,y)=>{
    for i in range(4) {bezier(P(x,y + i*6),P(x,y + (i + 1)*6),P(x - 8,y + i*6),P(x - 8,y + (i + 1)*6),stroke:(paint:gray,thickness:.9pt))}
  }

  // (a) two charge-transfer cells and diode output.
  shade(247,1037,108,122)
  wire(((130,1046),(343,1046)));wire(((130,1151),(435,1151)))
  sv(180,1068,1046,1096);sv(180,1123,1096,1151)
  hcap(214,1096,180,237);sh(264,1096,237,291)
  hcap(319,1096,291,343);sv(291,1123,1096,1151)
  diode(237,1073,up:false);wire(((237,1046),(237,1058)));wire(((237,1088),(237,1096)))
  diode(343,1073,up:false);wire(((343,1046),(343,1058)));wire(((343,1088),(343,1096),(354,1096)))
  diode-h(370,1096);wire(((386,1096),(435,1096)))
  vc(397,1119,1096,1151)
  for (x,y) in ((180,1046),(180,1096),(180,1151),(237,1046),(237,1096),(291,1096),(291,1151),(343,1096),(397,1096),(397,1151)) {dot(x,y)}
  ports(130,1046,1151,[$V_"in"$]);ports(435,1096,1151,[$V_"out"$],left:false)
  lab(163,1078,[$S_1$]);lab(163,1136,[QS#sub[1]]);lab(214,1111,[$C_1$]);lab(225,1073,[$D_1$])
  lab(263,1111,[$S_2$]);lab(273,1136,[QS#sub[2]]);lab(319,1111,[$C_2$]);lab(331,1073,[$D_2$]);lab(370,1082,[$D_o$]);lab(380,1126,[$C_o$]);lab(239,1180,[(a)])
  // (b) diode-capacitor stages, with a crossing at C1b.
  shade(661,1019,126,142)
  wire(((497,1046),(549,1046)));diode-h(566,1046);wire(((582,1046),(613,1046)))
  diode-h(630,1046);wire(((646,1046),(668,1046)));diode-h(685,1046)
  wire(((701,1046),(729,1046)));diode-h(745,1046);wire(((761,1046),(805,1046)))
  wire(((497,1151),(805,1151)));sv(530,1068,1046,1096);sv(530,1123,1096,1151)
  wire(((530,1096),(554,1096)))
  for i in range(4) {bezier(P(554 + i*6,1096),P(560 + i*6,1096),P(554 + i*6,1088),P(560 + i*6,1088),stroke:.7pt)}
  hump(654,578,713,1096)
  vc(596,1070,1046,1096);vc(713,1070,1046,1096)
  vc(654,1134,1046,1151);vc(775,1134,1046,1151)
  for (x,y) in ((530,1046),(530,1096),(530,1151),(596,1046),(596,1096),(654,1046),(654,1151),(713,1046),(775,1046),(775,1151)) {dot(x,y)}
  ports(497,1046,1151,[$V_"in"$]);ports(805,1046,1151,[$V_"out"$],left:false)
  lab(544,1071,[$S_1$]);lab(544,1125,[$S_2$]);lab(566,1030,[$D_(1 a)$]);lab(630,1030,[$D_(1 b)$]);lab(685,1030,[$D_(2 a)$]);lab(745,1030,[$D_(2 b)$])
  lab(579,1079,[$C_(1 a)$]);lab(635,1139,[$C_(1 b)$]);lab(695,1079,[$C_(2 a)$]);lab(756,1139,[$C_(2 b)$]);lab(566,1110,[$L_r$]);lab(651,1180,[(b)])
  // (c) modular capacitors, including gray stray-inductance symbols.
  shade(253,1213,101,149)
  wire(((119,1248),(164,1248)));sh(188,1248,164,224,reverse:true)
  hump(264,224,289,1248);sh(308,1248,289,349,reverse:true);sh(374,1248,349,419,reverse:true)
  wire(((119,1354),(419,1354)));wire(((156,1248),(156,1218),(264,1218),(264,1299),(286,1299)))
  wire(((156,1248),(156,1299),(177,1299)));sh(193,1299,177,224)
  sh(302,1299,286,332)
  vc(224,1284,1248,1299);vc(332,1284,1248,1299);vc(393,1298,1248,1354)
  sv(224,1324,1299,1354);sv(332,1324,1299,1354)
  faintcoil(156,1262);faintcoil(264,1262)
  content(P(173,1275),text(fill:gray,[$L_("S" 1)$]));content(P(281,1275),text(fill:gray,[$L_("S" 2)$]))
  for (x,y) in ((156,1248),(224,1248),(224,1299),(224,1354),(332,1248),(332,1299),(332,1354),(393,1248),(393,1354)) {dot(x,y)}
  ports(119,1248,1354,[$V_"in"$]);ports(419,1248,1354,[$V_"out"$],left:false)
  lab(196,1234,[$S_(1 a)$]);lab(316,1234,[$S_(1 a)$]);lab(206,1286,[$C_1$]);lab(314,1286,[$C_2$]);lab(376,1305,[$C_3$])
  lab(189,1314,[$S_(1 p)$]);lab(303,1314,[$S_(1 p)$]);lab(241,1324,[$S_(1 n)$]);lab(348,1324,[$S_(2 n)$]);lab(239,1393,[(c)])
  // Open switch = MOSFET/body diode, the original small equivalence box.
  rect(P(417,1170),P(522,1234),fill:white,stroke:.7pt)
  sv(438,1200,1181,1224);lab(460,1203,[$equiv$])
  wire(((502,1181),(502,1195),(490,1195),(490,1206),(502,1206),(502,1220)))
  wire(((477,1209),(488,1209),(488,1200)));wire(((485,1199),(485,1211)))
  for yy in (1197,1202,1207) {wire(((491,yy),(491,yy + 3)))}
  line(P(490,1203),P(499,1199),P(499,1207),close:true,fill:black,stroke:none)
  wire(((502,1187),(513,1187),(513,1216),(502,1216)));diode(513,1201)
  // (d) modular split capacitors and nested return loops.
  shade(680,1202,105,176)
  wire(((541,1241),(602,1241)));sh(611,1241,602,645,reverse:true)
  hump(701,645,725,1241);sh(733,1241,725,804,reverse:true)
  wire(((541,1346),(602,1346)));sh(611,1346,602,645)
  hump(701,645,725,1346);sh(733,1346,725,804)
  wire(((578,1241),(578,1209),(701,1209),(701,1260)))
  wire(((578,1346),(578,1372),(701,1372),(701,1329)))
  sv(578,1267,1241,1292);sv(578,1320,1292,1346)
  sv(701,1267,1260,1292);sv(701,1320,1292,1329)
  wire(((578,1292),(645,1292)));wire(((701,1292),(768,1292)))
  vc(645,1263,1241,1292);vc(645,1314,1292,1346)
  vc(768,1263,1241,1292);vc(768,1314,1292,1346)
  for (x,y) in ((578,1241),(578,1292),(578,1346),(645,1241),(645,1292),(645,1346),(701,1292),(768,1241),(768,1292),(768,1346)) {dot(x,y)}
  ports(541,1241,1346,[$V_"in"$]);ports(804,1241,1346,[$V_"out"$],left:false)
  lab(620,1229,[$S_(1 a)$]);lab(743,1229,[$S_(1 a)$]);lab(620,1358,[$S_(1 b)$]);lab(743,1358,[$S_(1 b)$])
  lab(594,1268,[$S_(1 p)$]);lab(594,1320,[$S_(1 n)$]);lab(717,1268,[$S_(2 p)$]);lab(717,1320,[$S_(2 n)$])
  lab(627,1270,[$C_(1 a)$]);lab(627,1320,[$C_(1 b)$]);lab(750,1270,[$C_(2 a)$]);lab(750,1320,[$C_(2 b)$]);lab(689,1393,[(d)])
  // (e) odd/even ratio diode-capacitor stages and a neutral midpoint.
  shade(850,1063,112,86,c:"#f2dbd8");shade(914,1106,50,44,c:"#ffffff")
  shade(850,1265,112,86,c:"#f2dbd8");shade(914,1263,50,44,c:"#ffffff")
  shade(936,1106,120,88,c:"#d8edf2");shade(934,1155,59,41,c:"#ffffff")
  shade(936,1218,120,89,c:"#d8edf2");shade(934,1216,59,41,c:"#ffffff")
  wire(((888,1072),(950,1072),(950,1080)));diode(950,1095);wire(((950,1110),(950,1125)))
  diode(950,1140);wire(((950,1155),(950,1158)))
  wire(((857,1158),(950,1158)));wire(((857,1256),(950,1256)))
  vc(888,1111,1072,1158);vc(888,1296,1256,1339)
  wire(((888,1339),(950,1339),(950,1333)));diode(950,1318)
  wire(((950,1303),(950,1296)));diode(950,1281);wire(((950,1266),(950,1256)))
  sv(950,1181,1158,1206);sv(950,1230,1206,1256)
  wire(((950,1114),(1018,1114)));vc(1018,1159,1114,1206)
  wire(((950,1206),(1018,1206)));vc(1018,1247,1206,1298)
  wire(((950,1298),(1018,1298)))
  line(P(957,1074),P(1078,1074),stroke:(thickness:.7pt,dash:"dashed"))
  line(P(957,1339),P(1078,1339),stroke:(thickness:.7pt,dash:"dashed"))
  for (x,y) in ((888,1158),(950,1158),(950,1114),(950,1206),(1018,1206),(888,1256),(950,1256),(950,1298)) {dot(x,y)}
  ports(857,1158,1256,[$V_"in"$]);ports(1078,1074,1339,[$V_"out"$],left:false)
  lab(939,1207,[0]);lab(929,1186,[$S_1$]);lab(929,1232,[$S_2$])
  lab(871,1119,[$C_(2 a)$]);lab(871,1305,[$C_(2 b)$]);lab(1038,1167,[$C_(1 a)$]);lab(1038,1255,[$C_(1 b)$])
  lab(934,1099,[$D_(2 a)$]);lab(967,1142,[$D_(1 a)$]);lab(967,1286,[$D_(1 b)$]);lab(934,1324,[$D_(2 b)$])
  content(P(901,1054),text(size:9pt,[Odd ratio]));content(P(998,1097),text(size:9pt,[Even ratio]));lab(958,1393,[(e)])
})
