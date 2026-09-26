#set page(width:auto,height:auto,margin:10pt)
#import "@preview/cetz:0.4.2":canvas,draw
#set text(font:"Calibri",size:11pt)
#set par(leading:0pt)
#let turn-text=rotate
#canvas(length:1pt,{
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
