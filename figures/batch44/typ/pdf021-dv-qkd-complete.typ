#set page(width:auto,height:auto,margin:5pt)
#import "@preview/cetz:0.4.2":canvas,draw
// Native panel copied from batch40/pdf019-dv-qkd-benches.typ
#let panel-0() = {
set text(font:"Calibri",size:11pt)
set par(leading:0pt)
let turn-text=rotate
canvas(length:1pt,{
  import draw:*
  let P=(x,y)=>(.45*x,.45*(534 - y))
  let label=(x,y,c,size:11pt,fill:black,weight:"bold")=>content(P(x,y),turn-text(4deg,text(size:size,fill:fill,weight:weight,c)))
  let path=(points)=>{
    line(..points.map(p=>P(..p)),stroke:(paint:rgb("#828282"),thickness:3.4pt))
    line(..points.map(p=>P(..p)),stroke:(paint:rgb("#aaaaaa"),thickness:2pt))
  }
  let curve=(a,b,c,d)=>{
    bezier(P(..a),P(..b),P(..c),P(..d),stroke:(paint:rgb("#828282"),thickness:3.4pt))
    bezier(P(..a),P(..b),P(..c),P(..d),stroke:(paint:rgb("#aaaaaa"),thickness:2pt))
  }
  let plate=(x,y,w,h,color,c,size:11pt)=>{
    let dy=.071*w
    line(P(x,y),P(x + w,y + dy),P(x + w - 3,y + h + dy),P(x - 3,y + h),close:true,fill:color,stroke:(paint:color.darken(20%),thickness:.4pt))
    line(P(x - 3,y + h),P(x + w - 3,y + h + dy),P(x + w - 3,y + h + dy + 7),P(x - 3,y + h + 7),close:true,fill:color.darken(20%),stroke:none)
    label(x + w/2,y + h/2 + dy/2,c,size:size)
  }
  let beam-splitter=(x,y,c,polar:false)=>{
    if polar {plate(x - 19,y - 7,38,8,c,[],size:1pt)} else {
      plate(x - 10,y - 14,19,21,c,[],size:1pt)
      line(P(x - 10,y - 14),P(x + 6,y + 11),stroke:(paint:c.darken(18%),thickness:.3pt))
    }
    label(x,y + 29,if polar {[PBS]} else {[BS]},size:11pt)
  }
  let adjustment=(x,y,down:false)=>{
    let d=if down {-1} else {1}
    let pts=((x - 8,y + d*33),(x - 5,y + d*10),(x - 14,y + d*9),(x + 1,y - d*5),(x + 13,y + d*10),(x + 4,y + d*11),(x + 1,y + d*34))
    line(..pts.map(p=>P(..p)),close:true,fill:rgb("#e7d7b3"),stroke:(paint:rgb("#bdb08f"),thickness:.35pt))
    for i in range(5) {let yy=y + d*(14 + i*3);line(P(x - 5,yy),P(x + 2,yy + 1),stroke:(paint:rgb("#bdb08f"),thickness:.3pt))}
  }
  line(P(105,24),P(1119,106),P(1088,284),P(77,203),close:true,fill:rgb("#f7efdd"),stroke:(paint:rgb("#c7c3b6"),thickness:.3pt))
  line(P(71,224),P(1299,309),P(1268,513),P(41,413),close:true,fill:rgb("#f7efdd"),stroke:(paint:rgb("#c7c3b6"),thickness:.3pt))
  // Bob's two detector paths and the phase/frequency arms.
  curve((310,87),(390,111),(336,106),(374,66))
  curve((390,111),(426,129),(393,125),(407,130))
  curve((310,121),(426,129),(338,139),(329,189))
  curve((426,129),(502,81),(491,145),(456,75))
  path(((502,81),(556,85)))
  curve((688,95),(806,165),(774,93),(749,151))
  curve((426,129),(524,186),(481,133),(446,185))
  path(((524,186),(702,205)))
  curve((702,205),(806,165),(770,214),(752,171))
  circle(P(702,223),radius:(10.4,7.65),stroke:(paint:rgb("#828282"),thickness:3.4pt))
  circle(P(702,223),radius:(10.4,7.65),stroke:(paint:rgb("#aaaaaa"),thickness:2pt))
  path(((806,165),(891,181),(981,188),(1139,188)))
  curve((311,48),(307,72),(333,50),(323,71))
  curve((299,145),(294,171),(318,151),(304,173))
  // Alice's encoding interferometer and monitoring branch.
  path(((148,263),(212,268)))
  curve((346,284),(478,350),(468,286),(402,344))
  curve((379,391),(478,350),(456,392),(412,349))
  curve((478,350),(606,302),(549,352),(501,291))
  curve((740,315),(858,381),(825,314),(784,380))
  curve((478,350),(580,398),(541,351),(504,390))
  path(((580,398),(751,427)))
  curve((751,427),(858,381),(823,427),(814,382))
  circle(P(751,443),radius:(10.4,7.65),stroke:(paint:rgb("#828282"),thickness:3.4pt))
  circle(P(751,443),radius:(10.4,7.65),stroke:(paint:rgb("#aaaaaa"),thickness:2pt))
  curve((858,381),(980,337),(930,389),(895,300))
  path(((980,337),(1040,350),(1135,357),(1265,371)))
  curve((1265,371),(1353,309),(1323,385),(1374,337))
  curve((1353,309),(1264,236),(1346,282),(1309,279))
  curve((1135,357),(1141,422),(1196,368),(1170,390))
  curve((1141,422),(1186,449),(1124,483),(1184,509))
  // Coiled channel: layered metal turns, then the upper spool face.
  circle(P(1204,255),radius:(32,15.3),fill:rgb("#6c62ff"),stroke:none)
  rect(P(1155,210),P(1253,265),fill:rgb("#999999"),stroke:none)
  for y in range(264,209,step:-6) {
    circle(P(1204,y),radius:(23,10.5),fill:rgb("#b6b6b6"),stroke:(paint:rgb("#787878"),thickness:.5pt))
  }
  circle(P(1204,184),radius:(31.5,21),fill:rgb("#6861f9"),stroke:none)
  circle(P(1204,184),radius:(23.8,14.4),fill:rgb("#dddddd"),stroke:none)
  for i in range(0,12,step:2) {
    let pts=(P(1204,184),)
    for j in range(13) {let a=i*30deg + j*30deg/12;pts.push(P(1204 + 53*calc.cos(a),184 + 32*calc.sin(a)))}
    line(..pts,close:true,fill:rgb("#6962f5"),stroke:none)
  }
  // Source and detectors cover the fibers at their physical ports.
  plate(159,26,152,105,rgb("#898989"),[DU],size:13pt)
  for y in (86,97,120,132) {rect(P(300,y - 6),P(314,y + 6),fill:rgb("#858585"),stroke:(paint:rgb("#5e5e5e"),thickness:.3pt))}
  rect(P(296,134),P(307,145),fill:rgb("#70e531"),stroke:.3pt)
  plate(554,64,138,27,rgb("#ff9931"),[PM])
  let fs=()
  for (x,y,a) in ((105,11,-90deg),(11,11,90deg)) {
    for i in range(17) {let t=a + i*180deg/16;let u=x + 11*calc.cos(t);let v=y + 11*calc.sin(t);fs.push(P(524 + u,174 + v + .071*u))}
  }
  line(..fs,close:true,fill:rgb("#888888"),stroke:.3pt)
  label(582,189,[FS])
  plate(942,166,81,29,rgb("#909090"),[PC])
  beam-splitter(427,129,rgb("#f6cc45"))
  beam-splitter(807,164,rgb("#ffe465"),polar:true)
  adjustment(595,154,down:true)
  adjustment(970,214)
  adjustment(329,180)
  label(1007,125,[Bob],size:24pt,fill:rgb("#9b96f4"))
  plate(100,230,50,52,rgb("#898989"),[LD],size:12pt)
  plate(213,251,135,31,rgb("#8c3718"),[IM])
  plate(607,284,135,27,rgb("#ff9a32"),[PM])
  plate(980,320,62,29,rgb("#999999"),[VA])
  beam-splitter(478,350,rgb("#f8cd44"))
  beam-splitter(859,381,rgb("#ffe465"),polar:true)
  beam-splitter(1135,353,rgb("#f6f342"))
  plate(1175,402,75,29,rgb("#999999"),[OPM])
  line(P(1172,433),P(1247,438),P(1245,455),P(1171,450),close:true,fill:rgb("#d4d4d4"),stroke:.4pt)
  circle(P(1185,443),radius:3.7,fill:rgb("#777777"),stroke:none)
  rect(P(1204,439),P(1238,448),fill:rgb("#e2e2e2"),stroke:none)
  adjustment(1003,372)
  label(154,381,[Alice],size:24pt,fill:rgb("#9b96f4"))
})
}
// Native panel copied from batch37/pdf013-three-state-bb84.typ
#let panel-1() = {
set text(font:"Calibri",size:13pt)
canvas(length:1pt,{
  import draw:*
  let P = (x,y)=>(.5*x,.5*(352 - y))
  let label = (x,y,c,size:13pt,fill:black)=>content(P(x,y),text(size:size,fill:fill,c))
  let rr = (x1,y1,x2,y2,r,stroke)=>{
    let pts=()
    for (x,y,a) in ((x2 - r,y1 + r,-90deg),(x2 - r,y2 - r,0deg),(x1 + r,y2 - r,90deg),(x1 + r,y1 + r,180deg)) {
      for i in range(9) { let t=a + 90deg*i/8; pts.push(P(x + r*calc.cos(t),y + r*calc.sin(t))) }
    }
    line(..pts,close:true,stroke:stroke)
  }
  let dotted=(paint:rgb("#b7b7b7"),thickness:.8pt,dash:(array:(.7pt,1.1pt)))
  let dashed=(paint:rgb("#555555"),thickness:1pt,dash:(array:(5pt,4pt)))
  let wire=(thickness:1.5pt)
  rr(52,1,615,337,23,dotted)
  rr(730,1,1065,337,23,dotted)
  label(119,31,[Alice],size:21pt,fill:rgb("#b7b7b7"))
  label(793,31,[Bob],size:21pt,fill:rgb("#b7b7b7"))
  rr(74,226,163,314,13,dashed)
  rr(299,22,433,134,12,dashed)
  rr(278,158,479,293,12,dashed)
  rr(842,136,975,314,12,dashed)
  line(P(117,270),P(434,270),stroke:wire)
  bezier(P(299,270),P(253,224),P(270,270),P(253,250),stroke:wire)
  line(P(253,224),P(253,113),stroke:wire)
  bezier(P(253,113),P(300,67),P(253,84),P(273,67),stroke:wire)
  line(P(300,67),P(1007,67),stroke:wire)
  bezier(P(299,270),P(344,226),P(328,270),P(344,255),stroke:wire)
  bezier(P(344,226),P(389,181),P(344,196),P(366,181),stroke:wire)
  line(P(389,181),P(434,181),stroke:wire)
  circle(P(376,253),radius:7.5,stroke:2.2pt)
  label(376,225,[Piezo],size:15pt)
  rect(P(323,46),P(411,89),fill:rgb("#ffe000"),stroke:1.5pt)
  label(366,106,[IM],size:15pt)
  rect(P(549,46),P(592,89),fill:rgb("#ad2319"),stroke:1.5pt)
  label(570,106,[VA],size:15pt)
  for (x,l) in ((490,[DCF]),(670,[ULL#linebreak()Fiber])) {
    for dx in (-10,-5,0,5,10) { circle(P(x + dx,39),radius:(11.5,12.5),stroke:1.2pt) }
    label(x,if x==490 {86} else {101},l,size:15pt)
  }
  rect(P(188,249),P(230,291),fill:rgb("#ad2319"),stroke:1.5pt)
  label(209,307,[Filter],size:15pt)
  label(117,211,[Laser],size:15pt)
  for a in range(0,360,step:45) {
    let t=a*1deg
    line(P(117 + 6*calc.cos(t),270 + 6*calc.sin(t)),P(117 + 28*calc.cos(t),270 + 28*calc.sin(t)),stroke:(paint:rgb("#b92313"),thickness:3.6pt))
  }
  circle(P(117,270),radius:4,fill:rgb("#b92313"),stroke:none)
  for y in (181,270) { rect(P(412,y - 7),P(456,y + 7),fill:rgb("#a0a0a0"),stroke:none) }
  label(436,205,[FM],size:15pt)
  label(436,251,[FM],size:15pt)
  bezier(P(815,67),P(863,114),P(843,67),P(863,88),stroke:wire)
  line(P(863,114),P(863,270),stroke:wire)
  bezier(P(907,112),P(863,157),P(881,112),P(863,133),stroke:wire)
  line(P(907,112),P(1007,112),stroke:wire)
  bezier(P(863,157),P(907,203),P(863,187),P(885,203),stroke:wire)
  bezier(P(907,203),P(953,251),P(936,203),P(953,224),stroke:wire)
  for x in (863,953) { rect(P(x - 7,248),P(x + 7,292),fill:rgb("#a0a0a0"),stroke:none) }
  label(898,259,[FM],size:15pt)
  label(925,285,[FM],size:15pt)
  rect(P(751,61),P(815,74),fill:rgb("#a0a0a0"),stroke:none)
  label(783,92,[BS],size:15pt)
  label(990,34,[SNSPDs],size:15pt)
  for y in (67,112) {
    let pts=(P(1005,y - 16),P(1007,y - 16))
    for i in range(17) { let a=-90deg + i*180deg/16; pts.push(P(1007 + 24*calc.cos(a),y + 16*calc.sin(a))) }
    line(..pts,close:true,fill:rgb("#186b2a"),stroke:1.6pt)
    circle(P(1006,y),radius:(3,8),fill:rgb("#676767"),stroke:1pt)
  }
})
}
// Native panel copied from batch37/pdf014-dps-system.typ
#let panel-2() = {
set text(font:"Calibri",size:15pt)
let turn-text=rotate
canvas(length:1pt,{
  import draw:*
  let P=(x,y)=>(.4*x,.4*(697 - y))
  let cyan=rgb("#75d7f3")
  let pale=rgb("#b9e0e5")
  let blue=rgb("#0000ff")
  let red=rgb("#ff0000")
  let label=(x,y,c,size:15pt)=>content(P(x,y),text(size:size,c))
  let cube=(x,y,w,h,d,color,c,size:15pt)=>{
    rect(P(x,y),P(x + w,y + h),fill:color,stroke:none)
    line(P(x,y),P(x + d,y - d),P(x + w + d,y - d),P(x + w,y),close:true,fill:color.lighten(18%),stroke:none)
    line(P(x + w,y),P(x + w + d,y - d),P(x + w + d,y + h - d),P(x + w,y + h),close:true,fill:color.darken(16%),stroke:none)
    label(x + w/2,y + h/2,c,size:size)
  }
  let edge=(paint:rgb("#71d5a2"),thickness:1.8pt,dash:(array:(2.6pt,2.6pt)))
  rect(P(5,115),P(548,692),stroke:edge)
  rect(P(807,115),P(1494,692),stroke:edge)
  label(267,69,[Alice],size:38pt)
  label(1142,69,[Bob],size:38pt)
  cube(171,183,280,117,42,cyan,[PG],size:36pt)
  cube(32,518,145,71,19,pale,[Laser],size:18pt)
  cube(201,443,97,44,15,rgb("#69d6d6"),[Amp],size:17pt)
  cube(321,443,99,44,14,rgb("#69d6d6"),[Amp],size:17pt)
  cube(207,532,78,35,13,rgb("#888888"),[IM],size:18pt)
  cube(322,532,75,35,13,cyan,[PM],size:18pt)
  cube(435,499,30,87,10,rgb("#888888"),[V#linebreak()A],size:18pt)
  label(111,479,[CW],size:18pt)
  label(179,369,[2 GHz],size:18pt)
  label(423,369,[Data],size:18pt)
  line(P(252,300),P(252,428),stroke:(paint:blue,thickness:2.2pt))
  line(P(371,300),P(371,428),stroke:(paint:blue,thickness:2.2pt))
  line(P(252,487),P(252,519),stroke:(paint:blue,thickness:2.2pt))
  line(P(371,487),P(371,519),stroke:(paint:blue,thickness:2.2pt))
  line(P(192,544),P(207,544),stroke:(paint:red,thickness:2.2pt))
  line(P(299,543),P(322,543),stroke:(paint:red,thickness:2.2pt))
  line(P(411,541),P(435,541),stroke:(paint:red,thickness:2.2pt))
  line(P(477,545),P(632,545),stroke:(paint:red,thickness:2.2pt))
  label(370,612,$lr({ -pi/2,pi/2 })$,size:13pt)
  label(668,442,[STF],size:30pt)
  circle(P(670,625),radius:(32,10),fill:rgb("#888888"),stroke:(paint:rgb("#aaaaaa"),thickness:1.4pt))
  rect(P(628,503),P(716,625),fill:rgb("#bad8d9"),stroke:none)
  for y in range(536,597,step:7) { circle(P(672,y),radius:(17.5,5.5),stroke:(paint:rgb("#69bfb0"),thickness:1pt)) }
  circle(P(672,503),radius:(30.5,8.5),fill:rgb("#888888"),stroke:(paint:rgb("#aaaaaa"),thickness:1.3pt))
  line(P(716,589),P(875,589),stroke:(paint:red,thickness:2.2pt))
  // The TDC perspective projects leftward; its top face lies above the front.
  line(P(1281,194),P(1281,643),P(1331,692),P(1331,194),close:true,fill:rgb("#a5d5df"),stroke:none)
  rect(P(1331,194),P(1478,692),fill:pale,stroke:none)
  line(P(1281,194),P(1281,143),P(1430,143),P(1478,194),close:true,fill:pale.lighten(12%),stroke:none)
  label(1397,395,[TDC],size:36pt)
  label(1394,229,[Com],size:18pt)
  label(1380,519,[CH1],size:18pt)
  label(1380,598,[CH2],size:18pt)
  line(P(478,224),P(1300,224),stroke:(paint:blue,thickness:2.2pt))
  circle(P(1300,224),radius:3.8,stroke:(paint:cyan,thickness:1pt))
  label(672,184,[Sync],size:25pt)
  label(672,261,[0.5 MHz],size:20pt)
  rect(P(865,242),P(1016,486),fill:rgb("#eeeeee"),stroke:none)
  rect(P(1009,303),P(1073,454),fill:rgb("#eeeeee"),stroke:none)
  content(P(1041,380),turn-text(90deg,text(size:27pt,[FMI])))
  cube(879,271,48,29,8,rgb("#cccccc"),[FM],size:15pt)
  cube(949,271,50,29,8,rgb("#cccccc"),[FM],size:15pt)
  line(P(909,300),P(909,422),stroke:(paint:red,thickness:2.2pt))
  line(P(970,300),P(970,422),stroke:(paint:red,thickness:2.2pt))
  circle(P(945,361),radius:8.5,stroke:(paint:red,thickness:2.2pt))
  cube(884,437,85,48,18,pale,[BS],size:18pt)
  line(P(909,484),P(909,555),stroke:(paint:red,thickness:2.2pt))
  line(P(945,484),P(945,513),P(1118,513),stroke:(paint:red,thickness:2.2pt))
  circle(P(913,590),radius:13.5,fill:rgb("#a4c0c6"),stroke:none)
  let pts=range(33).map(i=>{let a=135deg + i*270deg/32;P(913 + 22*calc.cos(a),590 + 22*calc.sin(a))})
  line(..pts,stroke:(paint:blue,thickness:2.5pt))
  line(P(938,601),P(939,582),P(922,590),close:true,fill:blue,stroke:none)
  label(880,572,[1],size:15pt)
  label(895,536,[2],size:15pt)
  label(960,571,[3],size:15pt)
  label(909,654,[CIR],size:23pt)
  rect(P(1078,422),P(1203,637),fill:rgb("#d5e2bb"),stroke:none)
  label(1141,440,[SSPD],size:19pt)
  for (y,l) in ((513,[D0]),(591,[D1])) {
    line(P(945,y),P(1120,y),stroke:(paint:red,thickness:2.2pt))
    rect(P(1120,y - 35),P(1146,y + 36),fill:rgb("#1ac6c7"),stroke:none)
    circle(P(1146,y),radius:(9,14.2),fill:rgb("#1ac6c7"),stroke:none)
    circle(P(1120,y),radius:(5.4,14.2),fill:rgb("#00a1a5"),stroke:none)
    line(P(1170,y),P(1302,y),stroke:(paint:blue,thickness:2.2pt))
    circle(P(1302,y),radius:3.8,stroke:(paint:cyan,thickness:1pt))
    label(1206,y + 33,l,size:20pt)
  }
})
}
// Native panel copied from batch39/pdf018-cow-experiment.typ
#let panel-3() = {
set text(font:"Calibri",size:10pt,style:"italic")
set par(leading:0pt)
let hidden-text = hide
canvas(length:1pt,{
  import draw:*
  let P=(x,y)=>(.4*x,.4*(464 - y))
  let fiber=(paint:rgb("#b8ad17"),thickness:.55pt)
  let label=(x,y,c,size:8.2pt)=>content(P(x,y),hidden-text(text(size:size,c)))
  let metal=(x,y,w,h:14)=>{
    line(P(x,y),P(x + w,y),P(x + w - 3,y + h),P(x - 3,y + h),close:true,fill:rgb("#777777"),stroke:none)
    line(P(x + 1,y + 2),P(x + w - 2,y + 2),P(x + w - 4,y + h - 3),P(x - 1,y + h - 3),close:true,fill:rgb("#aaaaaa"),stroke:none)
    line(P(x + 3,y + 3),P(x + w - 4,y + 3),stroke:(paint:rgb("#cfcfcf"),thickness:.6pt))
  }
  // Thin fibers first; each optical component will cover its physical segment.
  line(P(120,356),P(191,356),stroke:fiber)
  line(P(398,356),P(478,356),stroke:fiber)
  bezier(P(585,356),P(585,312),P(650,356),P(654,312),stroke:fiber)
  bezier(P(510,313),P(520,272),P(441,323),P(459,274),stroke:fiber)
  bezier(P(523,272),P(444,262),P(477,277),P(507,262),stroke:fiber)
  bezier(P(592,272),P(632,225),P(695,273),P(688,232),stroke:fiber)
  bezier(P(593,272),P(721,330),P(725,272),P(731,302),stroke:fiber)
  bezier(P(521,226),P(594,101),P(458,192),P(492,124),stroke:fiber)
  bezier(P(594,101),P(1208,85),P(728,72),P(1036,76),stroke:fiber)
  bezier(P(1208,85),P(1240,184),P(1325,93),P(1315,176),stroke:fiber)
  line(P(1240,184),P(1170,184),stroke:fiber)
  bezier(P(1172,185),P(1036,229),P(963,184),P(963,219),stroke:fiber)
  line(P(937,230),P(1146,230),stroke:fiber)
  bezier(P(1146,230),P(1340,250),P(1231,231),P(1232,250),stroke:fiber)
  bezier(P(1146,230),P(1196,377),P(1263,227),P(1291,377),stroke:fiber)
  bezier(P(1196,377),P(1341,277),P(1258,377),P(1287,287),stroke:fiber)
  line(P(946,377),P(1196,377),stroke:fiber)
  bezier(P(957,352),P(1064,279),P(1028,352),P(1021,279),stroke:fiber)
  bezier(P(1064,279),P(1130,377),P(1104,277),P(1066,379),stroke:fiber)
  for dx in (-18,0,18) {circle(P(932 + dx,48),radius:(17,13.5),stroke:fiber)}
  label(1040,45,[ULL SMF],size:8.2pt)
  label(912,102,[Quantum Channel],size:8.2pt)
  metal(522,219,110)
  label(585,207,[Attenuator],size:8.5pt)
  metal(523,269,74,h:7)
  label(560,258,[Coupler],size:8.5pt)
  metal(509,306,76)
  label(554,294,[Isolator],size:8.5pt)
  metal(1171,178,70)
  label(1217,165,[Isolator],size:8.5pt)
  metal(1033,226,112,h:6)
  label(1102,209,[90:10 Coupler],size:8.5pt)
  metal(931,347,46,h:11)
  metal(926,373,47,h:11)
  label(973,323,[Faraday#linebreak()Mirrors],size:8.5pt)
  metal(1123,373,74,h:7)
  label(1159,351,[50:50#linebreak()Coupler],size:8.5pt)
  label(1075,400,[Interferometer],size:8.5pt)

  // Transmitter plates and short metallic ports.
  for x in (113,175,397,462,590) {
    line(P(x - 5,349),P(x + 15,349),P(x + 15,362),P(x - 5,362),close:true,fill:rgb("#292929"),stroke:none)
    circle(P(x - 5,355.5),radius:(3,2.6),fill:rgb("#444444"),stroke:none)
    circle(P(x + 15,355.5),radius:(3,2.6),fill:rgb("#444444"),stroke:none)
  }
  line(P(29,374),P(49,345),P(145,345),P(125,374),close:true,fill:rgb("#e7c654"),stroke:none)
  line(P(50,364),P(68,337),P(119,337),P(104,364),close:true,fill:rgb("#efd05b"),stroke:none)
  line(P(104,364),P(119,337),P(119,350),P(108,376),close:true,fill:rgb("#aa912f"),stroke:none)
  label(83,351,[Laser],size:8.5pt)
  for i in range(8) {let x=48 + i*6;line(P(x,398),P(x + 11,374),stroke:(paint:rgb("#b69d35"),thickness:.3pt));line(P(x + 23,337),P(x + 33,315),stroke:(paint:rgb("#b69d35"),thickness:.3pt))}
  line(P(184,374),P(196,344),P(394,344),P(383,374),close:true,fill:rgb("#ddbd4d"),stroke:none)
  line(P(383,374),P(394,344),P(394,357),P(386,378),close:true,fill:rgb("#998634"),stroke:none)
  label(288,355,[Intensity modulator],size:8.5pt)
  for i in range(5) {let x=206 + i*5;line(P(x,399),P(x + 9,374),stroke:(paint:rgb("#b69d35"),thickness:.3pt))}
  line(P(254,426),P(271,380),P(383,380),P(363,426),close:true,fill:rgb("#aaaaaf"),stroke:none)
  line(P(254,426),P(363,426),P(363,433),P(257,433),close:true,fill:rgb("#77777b"),stroke:none)
  line(P(363,426),P(383,380),P(383,388),P(365,432),close:true,fill:rgb("#333333"),stroke:none)
  label(318,402,text(fill:white,[Pulse#linebreak()generator]),size:8pt)
  line(P(304,438),P(310,426),stroke:(paint:rgb("#aaaaaa"),thickness:1.2pt))

  line(P(453,405),P(478,335),P(585,335),P(566,405),close:true,fill:rgb("#e5c754"),stroke:none)
  line(P(453,405),P(566,405),P(566,419),P(457,419),close:true,fill:rgb("#ac963d"),stroke:none)
  line(P(566,405),P(585,335),P(589,352),P(573,419),close:true,fill:rgb("#292929"),stroke:none)
  label(525,371,[Variable#linebreak()optical#linebreak()attenuator],size:8pt)
  for i in range(8) {let y=365 + i*5;line(P(575,y),P(610 - i*.9,y),stroke:(paint:rgb("#b69d35"),thickness:.3pt))}
  line(P(643,419),P(657,330),P(760,330),P(744,394),P(758,394),P(758,419),close:true,fill:rgb("#303030"),stroke:none)
  line(P(643,395),P(744,395),P(758,419),P(643,419),close:true,fill:rgb("#252525"),stroke:none)
  line(P(744,395),P(760,330),P(760,352),P(776,356),P(758,419),close:true,fill:rgb("#171717"),stroke:none)
  label(703,363,text(fill:white,[Monitor#linebreak()PIN#linebreak()Detector]),size:8pt)

  // Cooler enclosure with the two detector ports on its circular front.
  line(P(1315,161),P(1328,34),P(1438,34),P(1429,161),close:true,fill:rgb("#b4b4b4"),stroke:none)
  line(P(1315,161),P(1429,161),P(1437,237),P(1309,237),close:true,fill:rgb("#878787"),stroke:none)
  line(P(1438,34),P(1445,166),P(1437,237),P(1429,161),close:true,fill:rgb("#2c2c2c"),stroke:none)
  line(P(1445,104),P(1454,105),P(1452,234),P(1438,237),close:true,fill:rgb("#9a9a9a"),stroke:none)
  label(1383,99,[Stirling#linebreak()cooler],size:8.5pt)
  for (y,rx,ry,color) in ((206,34,29,rgb("#252525")),(221,34,31,rgb("#777777")),(237,42,37,rgb("#999999")),(252,46,39,rgb("#6f6f6f"))) {
    circle(P(1370,y),radius:(rx*.4,ry*.4),fill:color,stroke:none)
  }
  circle(P(1370,236),radius:(12,7.2),fill:rgb("#bcbcbc"),stroke:none)
  circle(P(1370,228),radius:(8.5,2.8),fill:rgb("#dddddd"),stroke:none)
  for y in (249,277) {
    rect(P(1351,y - 5),P(1387,y + 5),fill:rgb("#222222"),stroke:none)
    circle(P(1351,y),radius:(4.5,2.8),fill:rgb("#353535"),stroke:none)
    line(P(1387,y),P(1401,y),stroke:fiber)
  }
  label(1444,253,$"SPD"_D$,size:8pt)
  label(1444,279,$"SPD"_M$,size:8pt)
  label(1450,320,[InGaAs#linebreak()NFADs],size:9pt)
})
}

// Scale native vector content, including stroke widths and text, to PDF placement.
#let panel-at(body,x,y,w,h)=context {
  let measured=measure(body)
  place(top+left,dx:x,dy:y,scale(x:w/measured.width*100%,y:h/measured.height*100%,reflow:true,body))
}
#box(width:483pt,height:192pt)[
  #panel-at(panel-0(),11.12186pt,5.65416pt,212.31499pt,79.19450pt)
  #panel-at(panel-1(),226.75000pt,1.00000pt,254.00000pt,84.75000pt)
  #panel-at(panel-2(),4.68320pt,92.61124pt,213.74399pt,94.65573pt)
  #panel-at(panel-3(),219.16779pt,102.96577pt,259.72034pt,75.91229pt)
  #place(top+left,dx:1.67460pt,dy:2.56081pt)[#text(font:"Calibri",size:8pt)[a)]]
  #place(top+left,dx:216.23859pt,dy:2.56472pt)[#text(font:"Calibri",size:8pt)[b)]]
  #place(top+left,dx:1.71359pt,dy:91.96590pt)[#text(font:"Calibri",size:8pt)[c)]]
  #place(top+left,dx:216.52359pt,dy:91.96980pt)[#text(font:"Calibri",size:8pt)[d)]]
  #place(top+left,dx:391.84799pt,dy:104.77278pt)[#text(font:"Calibri",size:8.00000pt,"ULL SMF")]
  #place(top+left,dx:345.17401pt,dy:117.35579pt)[#text(font:"Calibri",size:8.00000pt,"Quantum Channel")]
  #place(top+left,dx:362.14499pt,dy:169.74477pt)[#text(font:"Calibri",size:8.00000pt,"Faraday")]
  #place(top+left,dx:362.14499pt,dy:178.14479pt)[#text(font:"Calibri",size:8.00000pt,"Mirrors")]
  #place(top+left,dx:396.17630pt,dy:170.66859pt)[#text(font:"Calibri",size:8.00000pt,"Interferometer")]
  #place(top+left,dx:459.01300pt,dy:153.51680pt)[#text(font:"Calibri",size:8.00000pt,"SPDs")]
  #place(top+left,dx:258.52301pt,dy:135.53078pt)[#text(font:"Calibri",size:8.00000pt,"Attenuator")]
  #place(top+left,dx:344.27100pt,dy:139.80977pt)[#text(font:"Calibri",size:8.00000pt,"Coupler")]
  #place(top+left,dx:344.34015pt,dy:148.38515pt)[#text(font:"Calibri",size:8.00000pt,"Isolator")]
  #place(top+left,dx:219.14716pt,dy:172.53438pt)[#text(font:"Calibri",size:8.00000pt,"Laser")]
  #place(top+left,dx:249.12299pt,dy:146.03877pt)[#text(font:"Calibri",size:8.00000pt,"Intensity")]
  #place(top+left,dx:246.34174pt,dy:154.43880pt)[#text(font:"Calibri",size:8.00000pt,"Modulator")]
  #place(top+left,dx:410.13800pt,dy:124.62379pt)[#text(font:"Calibri",size:8.00000pt,"Isolator")]
  #place(top+left,dx:290.94000pt,dy:175.79079pt)[#text(font:"Calibri",size:8.00000pt,"Variable")]
  #place(top+left,dx:285.67438pt,dy:182.99080pt)[#text(font:"Calibri",size:8.00000pt,"Attenuator")]
  #place(top+left,dx:447.16101pt,dy:91.50777pt)[#text(font:"Calibri",size:8.00000pt,"Stirling")]
  #place(top+left,dx:447.16101pt,dy:99.50777pt)[#text(font:"Calibri",size:8.00000pt,"Cooler")]
  #place(top+left,dx:325.71799pt,dy:175.78780pt)[#text(font:"Calibri",size:8.00000pt,"Monitor")]
  #place(top+left)[#canvas(length:1pt,{
  import draw:*
  let P=(x,y)=>(x - 66,244 - y)
  rect((0,0),(483,192),fill:none,stroke:none)
  bezier(P(409.524017,195.345032),P(389.825012,199.606018),P(409.238983,195.297974),P(389.825012,199.606018),stroke:0.751181pt)
  line(P(392.759003,198.953979),P(393.899017,197.160950),P(389.091003,199.770020),P(394.552002,200.095032),P(392.759003,198.953979),close:true,fill:black,stroke:none)
  line(P(392.759003,198.954956),P(393.899994,197.160950),P(389.091003,199.770996),P(394.552002,200.095032),P(392.759003,198.954956),close:false,fill:none,stroke:0.400630pt)
  line(P(409.052002,203.583008),P(385.997009,206.035950),close:false,fill:none,stroke:0.750000pt)
  line(P(388.977997,205.720032),P(390.310028,204.066956),P(385.251007,206.117981),P(390.630005,207.052002),P(388.977997,205.720032),close:true,fill:black,stroke:none)
  line(P(388.977020,205.720032),P(390.309021,204.067993),P(385.250000,206.117981),P(390.630005,207.052002),P(388.977020,205.720032),close:false,fill:none,stroke:0.400000pt)
  line(P(442.579010,195.927002),P(466.485016,194.922974),close:false,fill:none,stroke:0.750000pt)
  line(P(463.489014,195.047974),P(462.052002,196.609985),P(467.235016,194.888000),P(461.927002,193.609985),P(463.489014,195.047974),close:true,fill:black,stroke:none)
  line(P(463.489014,195.047974),P(462.050995,196.609985),P(467.235016,194.888000),P(461.925995,193.609985),P(463.489014,195.047974),close:false,fill:none,stroke:0.400000pt)
  line(P(327.470001,238.504944),P(331.485016,238.504944),P(331.485016,231.851990),P(335.841003,231.851990),P(335.841003,238.523987),P(339.899017,238.523987),close:false,fill:none,stroke:0.750000pt)
})]
]
