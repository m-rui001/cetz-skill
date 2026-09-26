#set page(width:auto,height:auto,margin:2pt)
#import "@preview/cetz:0.4.2":canvas,draw
#set text(font:"Times New Roman",size:8.1pt)
#set par(leading:4.2pt)
#canvas(length:1pt,{
  import draw:*
  let s=.38
  let P=(x,y)=>(s*x,s*(522 - y))
  let wire=(pts)=>line(..pts.map(p=>P(..p)),stroke:.85pt)
  let label=(x,y,c,size:8.1pt)=>content(P(x,y),align(center,text(size:size,c)))
  let dot=(x,y)=>circle(P(x,y),radius:1.05,fill:black,stroke:none)
  let port=(x,y)=>circle(P(x,y),radius:1.1,fill:white,stroke:.8pt)
  let ground=(x,y,earth:true)=>{
    wire(((x,y),(x,y + 10)))
    if earth {
      for (w,dy) in ((9,10),(6,14),(3,18)) {wire(((x - w,y + dy),(x + w,y + dy)))}
    } else {line(P(x - 7,y + 10),P(x + 7,y + 10),P(x,y + 21),close:true,stroke:.85pt,fill:none)}
  }
  let supply=(x,y1,y2,c:[$V_"in"$])=>{
    port(x,y1);port(x,y2)
    label(x,y1 + 12,[$+$]);label(x,y2 - 12,[$-$])
    label(x - 16,(y1 + y2)/2,c)
  }
  let output=(x,y1,y2)=>{
    port(x,y1);port(x,y2)
    label(x,y1 + 12,[$+$]);label(x,y2 - 12,[$-$])
    label(x + 16,(y1 + y2)/2,[$V_"out"$])
  }
  let dc=(x,y,w,h,isolated:false)=>{
    rect(P(x,y),P(x + w,y + h),fill:rgb("#dceef1"),stroke:.9pt)
    wire(((x,y + h),(x + w,y)))
    if isolated {wire(((x - 4,y + h),(x + w - 4,y)))}
    label(x + w*.26,y + h*.23,[DC],size:8.5pt)
    label(x + w*.73,y + h*.79,[DC],size:8.5pt)
  }
  let cap=(x,y,horizontal:false,curved:true)=>{
    if horizontal {
      wire(((x - 17,y),(x - (if curved {1.5} else {3}),y)));wire(((x + 3,y),(x + 17,y)))
      wire(((x + 3,y - 12),(x + 3,y + 12)))
      if curved {bezier(P(x - 9,y - 12),P(x - 9,y + 12),P(x + 1,y - 11),P(x + 1,y + 11),stroke:.85pt)}
      else {wire(((x - 3,y - 12),(x - 3,y + 12)))}
    } else {
      wire(((x,y - 17),(x,y - 3)));wire(((x,y + (if curved {1.5} else {3})),(x,y + 17)))
      wire(((x - 12,y - 3),(x + 12,y - 3)))
      if curved {bezier(P(x - 12,y + 9),P(x + 12,y + 9),P(x - 11,y - 1),P(x + 11,y - 1),stroke:.85pt)}
      else {wire(((x - 12,y + 3),(x + 12,y + 3)))}
    }
  }
  let inductor=(x,y,n:4)=>{
    for i in range(n) {
      bezier(P(x + i*10,y),P(x + (i + 1)*10,y),P(x + i*10,y - 11),P(x + (i + 1)*10,y - 11),stroke:.9pt)
    }
  }
  let winding=(x,y,n:4,right:false)=>{
    let d=if right {-1} else {1}
    for i in range(n) {
      bezier(P(x,y + i*11),P(x,y + (i + 1)*11),P(x + 11*d,y + i*11),P(x + 11*d,y + (i + 1)*11),stroke:.9pt)
    }
  }
  let diode=(x,y,left:false,vertical:false)=>{
    if vertical {
      wire(((x,y - 20),(x,y + 20)))
      line(P(x,y - 10),P(x - 6,y + 4),P(x + 6,y + 4),close:true,fill:black,stroke:none)
      wire(((x - 7,y - 11),(x + 7,y - 11)))
    } else {
      wire(((x - 20,y),(x + 20,y)))
      let d=if left {-1} else {1}
      line(P(x + d*6,y),P(x - d*6,y - 6),P(x - d*6,y + 6),close:true,fill:black,stroke:none)
      wire(((x + d*8,y - 7),(x + d*8,y + 7)))
    }
  }
  let sw=(x,y)=>{
    wire(((x,y - 23),(x,y - 6)))
    wire(((x,y - 6),(x + 13,y + 12)))
    wire(((x,y + 21),(x,y + 38)))
  }
  // (a) common ground, plus conventional boost topology.
  label(166,46,[Common Grounded Non-Isolated\ DC-DC Converter])
  dc(120,80,89,95)
  wire(((83,94),(120,94)));wire(((209,94),(245,94)))
  wire(((83,193),(245,193)));wire(((165,175),(165,193)))
  supply(83,94,193);output(245,94,193);dot(165,193);ground(101,193)
  label(452,63,[PWM Boost Converter])
  wire(((356,94),(387,94)));inductor(387,94)
  wire(((427,94),(481,94)));diode(502,94);wire(((522,94),(545,94)))
  wire(((356,182),(545,182)));sw(461,128)
  wire(((461,94),(461,105)));wire(((461,166),(461,182)))
  dot(461,94);dot(461,182);supply(356,94,182);output(545,94,182);ground(374,182)
  label(408,114,[$L$]);label(446,137,[$S$]);label(502,114,[$D$]);label(291,224,[(a)])
  // (b) floated-output basic block and three-level boost circuit.
  label(165,303,[Floated Output Non-Isolated\ DC-DC Converter])
  dc(120,334,89,101)
  wire(((83,349),(120,349)));wire(((209,349),(242,349)))
  wire(((83,425),(120,425)));wire(((209,425),(242,425)))
  supply(83,349,425);output(242,349,425);ground(101,425);ground(226,425,earth:false)
  label(448,290,[Three-Level Boost Converter])
  wire(((324,321),(352,321)));inductor(352,321)
  wire(((392,321),(443,321)));diode(466,321);wire(((486,321),(573,321)))
  wire(((324,449),(444,449)));diode(466,449,left:true);wire(((486,449),(573,449)))
  wire(((504,321),(504,335)));cap(504,351)
  wire(((504,368),(504,399)));cap(504,415);wire(((504,432),(504,449)))
  sw(424,344);wire(((424,321),(424,321)));wire(((424,382),(504,382)))
  sw(424,410);wire(((424,382),(424,387)));wire(((424,448),(424,449)))
  for (x,y) in ((424,321),(504,321),(424,382),(504,382),(504,449)) {dot(x,y)}
  supply(324,321,449);output(573,321,449);ground(342,449);ground(554,449,earth:false)
  label(372,343,[$L$]);label(405,351,[$S_1$]);label(405,417,[$S_2$])
  label(467,346,[$D_1$]);label(466,426,[$D_2$]);label(534,352,[$C_1$]);label(534,418,[$C_2$]);label(291,482,[(b)])
  // (c) isolated block and one-stage high-frequency switching structure.
  label(820,46,[1-Stage Isolated DC-DC Converter])
  dc(775,72,89,100,isolated:true)
  wire(((740,86),(775,86)));wire(((864,86),(902,86)))
  wire(((740,157),(775,157)));wire(((864,157),(902,157)))
  supply(740,86,157);output(902,86,157);ground(758,157);ground(882,157,earth:false)
  label(1120,30,[High Frequency Switched\ DC Module])
  label(1380,30,[Voltage Multiplier\ Rectifier Module])
  rect(P(1072,62),P(1168,199),fill:rgb("#f1dcda"),stroke:.9pt)
  rect(P(1185,58),P(1320,160),radius:8*s,fill:rgb("#ffffcf"),stroke:none)
  rect(P(1338,62),P(1418,162),fill:rgb("#f1dcda"),stroke:.9pt)
  wire(((1035,82),(1072,82)));wire(((1035,177),(1072,177)))
  supply(1035,82,177);ground(1053,177)
  wire(((1168,74),(1235,74),(1235,90)))
  wire(((1168,147),(1235,147),(1235,134)))
  wire(((1295,74),(1338,74)));wire(((1295,147),(1338,147)))
  wire(((1218,74),(1218,90)));winding(1218,90,n:4);wire(((1218,134),(1218,147)))
  winding(1235,90,n:4);winding(1295,90,n:4,right:true)
  wire(((1295,74),(1295,90)));wire(((1295,134),(1295,147)))
  for x in (1274,1279) {wire(((x,91),(x,134)))}
  line(P(1243,94),P(1287,94),stroke:(thickness:.85pt,dash:"dotted"))
  label(1266,71,[1 : n],size:8.7pt);label(1203,112,[$L_"m"$]);dot(1218,74);dot(1218,147)
  label(1250,175,[Coupled Inductor],size:8.1pt)
  inductor(1096,83);cap(1121,110,horizontal:true);diode(1121,147)
  wire(((1093,173),(1111,173)));wire(((1114,186),(1133,173),(1148,173)))
  diode(1359,112,vertical:true);cap(1392,112)
  wire(((1418,78),(1457,78)));wire(((1418,148),(1457,148)))
  output(1457,78,148);ground(1437,148,earth:false);label(986,224,[(c)])
  // (d) two-stage isolated block and the explicit switch-network examples.
  label(813,307,[2-Stage Isolated DC-DC Converter])
  dc(704,333,89,99);dc(827,333,89,99,isolated:true)
  wire(((668,346),(704,346)));wire(((793,346),(827,346)));wire(((916,346),(955,346)))
  wire(((668,418),(704,418)));wire(((793,418),(827,418)));wire(((916,418),(955,418)))
  supply(668,346,418);output(955,346,418);ground(686,418);ground(935,418,earth:false)
  label(1102,267,[Auxiliary\ Pre-Regulation])
  label(1216,267,[Switch\ Network])
  label(1398,266,[Rectification &\ Multiplication])
  dc(1059,294,89,100)
  rect(P(1177,294),P(1257,394),radius:3*s,fill:rgb("#f1dcda"),stroke:.9pt)
  rect(P(1267,282),P(1345,391),radius:8*s,fill:rgb("#ffffcf"),stroke:none)
  rect(P(1359,294),P(1439,394),fill:rgb("#f1dcda"),stroke:.9pt)
  wire(((1022,309),(1059,309)));wire(((1022,381),(1059,381)))
  supply(1022,309,381);ground(1042,381)
  wire(((1148,309),(1177,309)));wire(((1148,381),(1177,381)))
  port(1163,309);port(1163,381);label(1163,324,[$+$]);label(1163,366,[$-$])
  sw(1215,340)
  wire(((1257,309),(1289,309),(1289,322)));winding(1289,322,n:5)
  wire(((1289,377),(1289,381),(1257,381)))
  wire(((1329,309),(1359,309)));winding(1329,322,n:5,right:true)
  wire(((1329,377),(1329,381),(1359,381)))
  wire(((1329,309),(1329,322)))
  for x in (1308,1313) {wire(((x,319),(x,368)))}
  dot(1296,315);dot(1321,315);port(1289,309);port(1289,345);port(1289,381)
  label(1280,311,[a],size:6.6pt);label(1280,345,[b],size:6.6pt);label(1280,378,[c],size:6.6pt)
  label(1310,294,[1 : n],size:8.7pt);label(1306,407,[Transformer])
  diode(1381,342,vertical:true);cap(1415,342)
  wire(((1439,309),(1473,309)));wire(((1439,394),(1473,394)))
  output(1473,309,394);ground(1455,383,earth:false)
  wire(((1215,394),(1215,407)))
  line(P(1215,415),P(1210,405),P(1220,405),close:true,fill:black,stroke:none)
  rect(P(1086,419),P(1352,510),radius:3*s,stroke:(paint:rgb("#777777"),thickness:.65pt,dash:"dotted"),fill:none)
  // Three small switch-network circuits inside the dotted selection box.
  wire(((1126,432),(1105,432),(1105,472)))
  wire(((1105,496),(1126,496),(1126,482)))
  wire(((1126,454),(1126,467),(1138,482)))
  port(1126,432);port(1126,454);port(1105,472);port(1105,496)
  label(1135,432,[a],size:6pt);label(1135,453,[c],size:6pt)
  label(1095,472,[$+$],size:6pt);label(1095,496,[$-$],size:6pt)
  wire(((1149,465),(1149,443),(1154,438),(1168,438)))
  wire(((1149,465),(1149,486),(1154,491),(1168,491),(1180,500)))
  wire(((1169,430),(1180,438),(1206,438)))
  wire(((1180,491),(1206,491)))
  wire(((1172,465),(1206,465)))
  for (x,y,t) in ((1206,438,[a]),(1206,465,[b]),(1206,491,[c])) {port(x,y);label(x + 2,y - 10,t,size:6pt)}
  port(1149,465);port(1172,465)
  label(1159,476,[$-$],size:6pt);label(1167,476,[$+$],size:6pt)
  let switch-leg=(x)=>{
    wire(((x,432),(x,443),(x + 12,455)))
    wire(((x,465),(x,476),(x + 12,488)))
    wire(((x,484),(x,496)))
    port(x,465)
  }
  for x in (1224,1289) {
    wire(((x,432),(x + 43,432)))
    wire(((x,496),(x + 43,496)))
    switch-leg(x + 43)
    for yy in (432,496) {port(x,yy);dot(x + 20,yy)}
    label(x - 1,445,[$+$],size:6pt);label(x - 1,487,[$-$],size:6pt)
    label(x + 49,465,[c],size:6pt)
    label(x + 29,465,[a],size:6pt)
  }
  // Center-tapped pair of capacitors in the half-bridge example.
  wire(((1244,432),(1244,444)))
  wire(((1235,444),(1253,444)))
  bezier(P(1235,451),P(1253,451),P(1236,445),P(1252,445),stroke:.85pt)
  wire(((1244,449),(1244,479)))
  wire(((1235,479),(1253,479)))
  bezier(P(1235,486),P(1253,486),P(1236,480),P(1252,480),stroke:.85pt)
  wire(((1244,484),(1244,496)))
  port(1244,465)
  switch-leg(1309)
  label(986,482,[(d)])
})
