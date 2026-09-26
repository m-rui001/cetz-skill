from pathlib import Path
import re
batch=Path(__file__).parent
# Copy the editable native helper definitions, without executing the older generator.
old=(batch.parent/'batch49/draw.py').read_text(encoding='utf-8')
header=old.split("header=r'''",1)[1].split("'''\n\nfig3=",1)[0]
header=header.replace('HEIGHT','894').replace('let s=.44','let s=.38').replace('size:9.5pt','size:8.1pt').replace('leading:4.4pt','leading:3.8pt')
extra=r'''
  let flatcap=(x,y,horizontal:false,lead:18,hlen:20)=>{
    if horizontal {
      wire(((x - hlen,y),(x - 3,y)));wire(((x + 3,y),(x + hlen,y)))
      for xx in (x - 3,x + 3) {wire(((xx,y - 11),(xx,y + 11)))}
    } else {
      wire(((x,y - lead),(x,y - 3)));wire(((x,y + 3),(x,y + lead)))
      for yy in (y - 3,y + 3) {wire(((x - 10,yy),(x + 10,yy)))}
    }
  }
  let ring=(x,y,c,right:false)=>{port(x,y);lab(x + (if right {12} else {-12}),y - 15,c)}
  let dotted=(x,y,w,h)=>rect(P(x,y),P(x + w,y + h),radius:3*s,fill:none,stroke:(thickness:1pt,dash:"dotted"))
  let segment-switch=(x,y)=>{
    wire(((x,y - 18),(x,y - 4),(x + 14,y + 16)))
    wire(((x,y + 21),(x,y + 37)))
  }
  let commutating=(xl,xr,top,bot,ma,mb)=>{
    wire(((xl,top),(xr,top)));wire(((xl,bot),(xr,bot)))
    rect(P(xl + 2,top + 7),P(xl + 29,top + 58),radius:7*s,fill:rgb("#ded7e6"),stroke:none)
    rect(P(xl + 2,bot - 62),P(xl + 29,bot - 11),radius:7*s,fill:rgb("#ded7e6"),stroke:none)
    rect(P(xl - 31,top + 7),P(xl - 5,top + 58),radius:7*s,fill:rgb("#fff0c9"),stroke:none)
    rect(P(xl - 31,bot - 62),P(xl - 5,bot - 11),radius:7*s,fill:rgb("#fff0c9"),stroke:none)
    wire(((xl,top),(xl,top + 21),(xl + 15,top + 43)))
    wire(((xl,top + 48),(xl,bot - 46),(xl + 15,bot - 24)))
    wire(((xl,bot - 19),(xl,bot)))
    wire(((xr,top),(xr,top + 12),(xr + 15,top + 34)))
    wire(((xr,top + 40),(xr,bot - 36),(xr + 15,bot - 14)))
    wire(((xr,bot - 9),(xr,bot)))
    // Return each small capacitor to its fixed switch contact.
    let x=xl - 17
    wire(((xl,top),(x,top),(x,top + 17)))
    cap(x,top + 35)
    wire(((x,top + 53),(x,top + 48),(xl,top + 48)))
    wire(((xl,bot - 46),(x,bot - 46),(x,bot - 50)))
    cap(x,bot - 32)
    wire(((x,bot - 14),(x,bot),(xl,bot)))
    x=xr - 17
    wire(((xr,top + 12),(x,top + 12),(x,top + 11)))
    flatcap(x,top + 22,lead:11)
    wire(((x,top + 33),(x,top + 40),(xr,top + 40)))
    wire(((xr,bot - 41),(x,bot - 41)))
    flatcap(x,bot - 25,lead:16)
    wire(((x,bot - 9),(xr,bot - 9)))
    for (x,y) in ((xl,top),(xl,bot),(xl,ma),(xr,mb)) {dot(x,y)}
  }
  let smallpaired=(x,y,h:38)=>{
    for xx in (x,x + 24) {
      for i in range(4) {bezier(P(xx,y + i*h/4),P(xx,y + (i + 1)*h/4),P(xx + 7,y + i*h/4),P(xx + 7,y + (i + 1)*h/4),stroke:.7pt)}
      for xc in (xx + 9,xx + 13) {line(P(xc,y + 1),P(xc,y + h - 1),stroke:.7pt)}
      dot(xx - 1,y - 2)
    }
  }
  let smalltrafo=(x,y,h:38)=>{
    for (xx,d) in ((x + 9,1),(x + 35,-1)) {
      for i in range(3) {bezier(P(xx,y + i*h/3),P(xx,y + (i + 1)*h/3),P(xx + 8*d,y + i*h/3),P(xx + 8*d,y + (i + 1)*h/3),stroke:.7pt)}
    }
    for xx in (x + 20,x + 24) {line(P(xx,y + 1),P(xx,y + h - 1),stroke:.7pt)}
    for yy in (y,y + h) {
      line(P(x,yy),P(x + 9,yy),stroke:.7pt)
      line(P(x + 35,yy),P(x + 44,yy),stroke:.7pt)
    }
    dot(x + 2,y + 7);dot(x + 42,y + 7)
  }
'''
body=r'''
  // (a) generic switched converter and all six resonant tank examples.
  lab(272,37,[Switch Network]);lab(456,36,[Resonant Tank\ Network]);lab(618,39,[Rectifier])
  dotted(214,61,117,129)
  wire(((170,74),(270,74),(270,135)))
  wire(((238,74),(238,88)));wire(((238,113),(238,176)))
  wire(((170,176),(270,176),(270,159)))
  wire(((238,95),(259,105)));cross(259,310,105,270)
  wire(((310,105),(310,79),(405,79)))
  wire(((270,141),(292,151),(311,151),(311,171),(405,171)))
  for (x,y) in ((238,74),(238,176),(259,105),(292,151)) {dot(x,y)}
  for (x,y) in ((238,88),(238,113),(270,135),(270,159),(370,79),(370,171)) {port(x,y)}
  bus-terminals(170,74,176,[$V_"in"$]);lab(370,101,[A]);lab(370,153,[B])
  block(405,61,102,129);winding(433,101,51);flatcap(474,124)
  block(583,61,71,129);diode(618,124);wire(((618,91),(618,102)));wire(((618,146),(618,157)))
  wire(((507,79),(583,79)));wire(((507,171),(583,171)))
  wire(((654,79),(695,79)));wire(((654,171),(695,171)))
  port(544,79);port(544,171);lab(547,101,[$A'$]);lab(547,153,[$B'$]);bus-terminals(695,79,171,[$V_"out"$],left:false)
  // Upper row: series, parallel, series-parallel.
  wire(((159,260),(177,260)));ind(177,260,n:4,pitch:9,depth:10)
  wire(((213,260),(217,260)));flatcap(237,260,horizontal:true);wire(((257,260),(264,260)))
  wire(((159,321),(264,321)))
  ring(159,260,[A]);ring(264,260,[$A'$]);port(159,321);port(264,321)
  lab(148,339,[B]);lab(278,339,[$B'$]);lab(197,240,[$L_s$]);lab(241,238,[$C_s$]);lab(216,359,[Series Tank])
  wire(((361,260),(379,260)));ind(379,260,n:4,pitch:9,depth:10);wire(((415,260),(465,260)))
  wire(((361,321),(465,321)));wire(((434,260),(434,271)));flatcap(434,289);wire(((434,307),(434,321)))
  dot(434,260);dot(434,321);ring(361,260,[A]);ring(465,260,[$A'$]);port(361,321);port(465,321)
  lab(350,339,[B]);lab(482,339,[$B'$]);lab(398,240,[$L_s$]);lab(462,294,[$C_p$]);lab(420,359,[Parallel Tank])
  wire(((552,260),(570,260)));ind(570,260,n:4,pitch:9,depth:10);wire(((606,260),(612,260)))
  flatcap(632,260,horizontal:true);wire(((652,260),(691,260)))
  wire(((552,321),(691,321)));wire(((659,260),(659,271)));flatcap(659,289);wire(((659,307),(659,321)))
  dot(659,260);dot(659,321);ring(552,260,[A]);ring(691,260,[$A'$]);port(552,321);port(691,321)
  lab(541,339,[B]);lab(704,339,[$B'$]);lab(592,240,[$L_s$]);lab(634,237,[$C_s$]);lab(689,294,[$C_p$]);lab(633,359,[Series-Parallel Tank])
  // Lower row: LLC, CLLC, LCL.
  wire(((139,437),(154,437)));flatcap(174,437,horizontal:true)
  ind(194,437,n:4,pitch:8,depth:9);wire(((226,437),(279,437)))
  wire(((139,497),(279,497)));wire(((247,437),(247,452)));winding(247,452,37);wire(((247,489),(247,497)))
  dot(247,437);dot(247,497);ring(139,437,[A]);ring(279,437,[$A'$]);port(139,497);port(279,497)
  lab(130,515,[B]);lab(289,515,[$B'$]);lab(174,413,[$C_s$]);lab(209,416,[$L_s$]);lab(270,470,[$L_p$]);lab(210,520,[LLC])
  wire(((336,437),(347,437)));flatcap(367,437,horizontal:true)
  ind(387,437,n:4,pitch:9,depth:10);wire(((423,437),(459,437)));flatcap(479,437,horizontal:true);wire(((499,437),(508,437)))
  wire(((336,497),(508,497)));wire(((443,437),(443,452)));winding(443,452,37);wire(((443,489),(443,497)))
  dot(443,437);dot(443,497);ring(336,437,[A]);ring(508,437,[$A'$]);port(336,497);port(508,497)
  lab(326,515,[B]);lab(518,515,[$B'$]);lab(367,413,[$C_(s 1)$]);lab(407,416,[$L_s$]);lab(468,470,[$L_p$]);lab(481,413,[$C_(s 2)$]);lab(428,520,[CLLC])
  wire(((562,437),(577,437)));ind(577,437,n:4,pitch:9,depth:10)
  wire(((613,437),(650,437)));ind(650,437,n:4,pitch:9,depth:10);wire(((686,437),(702,437)))
  wire(((562,497),(702,497)));wire(((634,437),(634,446)));flatcap(634,464);wire(((634,482),(634,497)))
  dot(634,437);dot(634,497);ring(562,437,[A]);ring(702,437,[$A'$]);port(562,497);port(702,497)
  lab(552,515,[B]);lab(713,515,[$B'$]);lab(592,416,[$L_(s 1)$]);lab(670,416,[$L_(s 2)$]);lab(662,469,[$C_p$]);lab(633,520,[LCL]);lab(430,559,[(a)])
  // (b) generic switch-cell placement.
  lab(1122,27,[Switch Cell]);dotted(1057,45,128,128)
  battery(955,109);wire(((955,61),(987,61)));ind(987,61,n:4,pitch:13,depth:12);wire(((1039,61),(1085,61)))
  wire(((955,61),(955,87)));wire(((955,131),(955,158),(1085,158)))
  wire(((1154,61),(1312,61),(1312,95)));wire(((1154,158),(1312,158),(1312,127)))
  wire(((1245,61),(1245,94)));cap(1245,112);wire(((1245,130),(1245,158)))
  res(1312,111);dot(1245,61);dot(1245,158);port(1245,85)
  for (x,y) in ((1085,61),(1085,158),(1154,61),(1154,158)) {port(x,y)}
  lab(1087,82,[A]);lab(1087,140,[B]);lab(1160,82,[$A'$]);lab(1160,140,[$B'$]);lab(1230,86,[a])
  lab(1010,38,[$L_"in"$]);lab(915,112,[$V_"in"$]);lab(1216,112,[$C_o$]);lab(1293,112,[$R_o$]);lab(1350,112,[$V_"out"$])
  // Three ZVS/ZCS quasi-resonant cells, all open switches preserved.
  wire(((912,215),(983,215)));wire(((912,318),(983,318)))
  wire(((947,215),(947,227)));winding(947,227,28);wire(((947,255),(947,273),(962,296)));wire(((947,301),(947,318)))
  wire(((947,268),(929,268),(929,266)));flatcap(929,284);wire(((929,302),(947,302)))
  dot(947,215);dot(947,318);ring(912,215,[A]);ring(983,215,[$A'$]);port(912,318);port(983,318)
  lab(901,336,[B]);lab(998,336,[$B'$]);lab(970,242,[$L_r$]);lab(905,284,[$C_r$]);lab(970,287,[$S$])
  wire(((1071,211),(1158,211)));wire(((1071,321),(1158,321)))
  wire(((1117,211),(1117,227)));winding(1117,227,30);wire(((1117,257),(1117,277),(1132,295)));wire(((1117,300),(1117,321)))
  wire(((1117,223),(1077,223),(1077,248)));flatcap(1077,266);wire(((1077,284),(1077,308),(1117,308)))
  dot(1117,211);dot(1117,321);ring(1071,211,[A]);ring(1158,211,[$A'$]);port(1071,321);port(1158,321)
  lab(1060,339,[B]);lab(1175,339,[$B'$]);lab(1140,244,[$L_r$]);lab(1055,266,[$C_r$]);lab(1139,290,[$S$])
  wire(((1232,209),(1322,209)));diode-h(1343,209);wire(((1366,209),(1365,209)))
  wire(((1232,322),(1365,322)))
  wire(((1255,209),(1255,223)));winding(1255,223,30);wire(((1255,253),(1255,276),(1270,298)));wire(((1255,302),(1255,322)))
  wire(((1322,209),(1322,217)));flatcap(1322,235);wire(((1322,253),(1322,276),(1337,298)));wire(((1322,302),(1322,322)))
  for x in (1255,1322) {dot(x,209);dot(x,322)}
  ring(1232,209,[A]);ring(1365,209,[$A'$]);port(1232,322);port(1365,322)
  lab(1221,340,[B]);lab(1380,340,[$B'$]);lab(1275,239,[$L_r$]);lab(1346,235,[$C_r$]);lab(1280,286,[$S_1$]);lab(1348,286,[$S_2$]);lab(1344,190,[$D$])
  lab(1126,359,[ZVS/ZCS Quasi-Resonant Switch Cells])
  // Active snubber: diode directions and junctions differ from ZCT/ZVT.
  tinted(889,418,100,67)
  wire(((854,409),(897,409)));diode-h(920,409);wire(((943,409),(988,409)))
  wire(((854,544),(988,544)))
  wire(((886,409),(886,509),(901,531)));wire(((886,535),(886,544)))
  wire(((886,449),(904,449),(924,434)));wire(((926,449),(953,449)))
  wire(((886,491),(895,491)));diode-h(918,491);wire(((941,491),(953,491)))
  diode(953,429);wire(((953,451),(953,453)));winding(953,453,38)
  wire(((953,491),(953,501)));flatcap(953,519);wire(((953,537),(953,544)))
  for (x,y) in ((886,409),(886,449),(886,491),(886,544),(953,409),(953,449),(953,491),(953,544)) {dot(x,y)}
  ring(854,409,[A]);ring(988,409,[$A'$]);port(854,544);port(988,544)
  lab(842,561,[B]);lab(1005,561,[$B'$]);lab(925,392,[$D_1$]);lab(976,432,[$D_3$]);lab(979,470,[$L_s$]);lab(929,511,[$D_2$]);lab(976,521,[$C_s$]);lab(923,464,[$S_a$]);lab(874,521,[$S$])
  bezier(P(992,460),P(985,560),P(1031,465),P(997,531),stroke:.8pt)
  line(P(982,570),P(982,558),P(991,562),close:true,fill:black,stroke:none)
  lab(952,577,[active snubber cell],size:7.5pt)
  // Zero-current transition cell.
  wire(((1067,418),(1113,418)));ind(1113,418,n:3,pitch:8,depth:8);wire(((1137,418),(1152,418)))
  diode-h(1175,418);wire(((1198,418),(1200,418)));wire(((1067,531),(1200,531)))
  wire(((1089,418),(1089,486),(1104,507)));wire(((1089,511),(1089,531)))
  wire(((1089,468),(1108,468),(1127,453)));wire(((1133,468),(1158,468)))
  wire(((1158,418),(1158,424)));flatcap(1158,442);wire(((1158,460),(1158,475)));diode(1158,497,up:false);wire(((1158,519),(1158,531)))
  for (x,y) in ((1089,418),(1089,531),(1158,418),(1158,531)) {dot(x,y)}
  ring(1067,418,[A]);ring(1200,418,[$A'$]);port(1067,531);port(1200,531)
  lab(1055,549,[B]);lab(1216,549,[$B'$]);lab(1127,398,[$L_r$]);lab(1179,398,[$D$]);lab(1181,444,[$C_r$]);lab(1183,498,[$D_a$]);lab(1137,480,[$S_a$]);lab(1072,501,[$S$]);lab(1135,563,[ZCT Cell])
  // Zero-voltage transition: the middle diode chain crosses the S leg.
  wire(((1276,412),(1316,412)));ind(1316,412,n:3,pitch:8,depth:8);wire(((1340,412),(1370,412)))
  diode-h(1393,412);wire(((1416,412),(1410,412)));wire(((1276,536),(1410,536)))
  wire(((1296,412),(1296,492),(1311,513)));wire(((1296,517),(1296,536)))
  wire(((1365,412),(1365,492),(1380,513)));wire(((1365,517),(1365,536)))
  wire(((1296,460),(1296,460)));diode-h(1319,460);cross(1342,1368,460,1365);diode-h(1391,460);wire(((1414,460),(1410,460)))
  wire(((1335,460),(1335,483)));flatcap(1346,483,horizontal:true,hlen:11);wire(((1357,483),(1365,483)))
  for (x,y) in ((1296,412),(1296,460),(1296,536),(1335,460),(1365,412),(1365,536)) {dot(x,y)}
  ring(1276,412,[A]);ring(1410,412,[$A'$]);port(1276,536);port(1410,536);port(1410,460)
  lab(1264,554,[B]);lab(1426,554,[$B'$]);lab(1430,460,[a]);lab(1333,394,[$L_r$]);lab(1394,394,[$D$]);lab(1319,443,[$D_1$]);lab(1390,443,[$D_2$]);lab(1346,500,[$C_r$]);lab(1281,502,[$S_a$]);lab(1380,502,[$S$]);lab(1343,563,[ZVT Cell]);lab(1152,600,[(b)])
  // (c) primary-side auxiliary circuit and detailed implementation options.
  commutating(240,307,603,749,670,689)
  wire(((180,603),(240,603)));wire(((180,749),(240,749)))
  bus-terminals(180,603,749,[$V_"in"$])
  cross(240,350,670,307);wire(((350,670),(350,647),(406,647)))
  ind(406,647,n:3,pitch:7,depth:5);wire(((427,647),(480,647)))
  wire(((307,689),(350,689),(350,706),(372,706)))
  block(372,679,87,55,c:"#dceef1");lab(416,707,[Auxiliary\ Circuit],size:8.1pt)
  wire(((459,706),(480,706)));trafo(480,519,647,59)
  wire(((519,647),(550,647)));wire(((519,706),(550,706)))
  block(550,613,101,128);diode(601,681)
  wire(((651,631),(703,631)));wire(((651,724),(703,724)))
  bus-terminals(703,631,724,[$V_"out"$],left:false);lab(419,630,[$L_k$])
  arrow((410,740),(383,758),w:9);arrow((421,740),(448,758),w:9)
  dotted(308,767,110,60);smallpaired(321,780);smalltrafo(365,780)
  dotted(445,768,51,51);wire(((462,776),(462,785),(453,803)));wire(((462,806),(462,813)))
  diode(481,795,leads:false);wire(((481,776),(481,813)))
  lab(430,853,[(c)])
  // (d) secondary-side auxiliary circuit, placed in parallel with the output.
  commutating(918,985,636,783,703,723)
  wire(((860,636),(918,636)));wire(((860,783),(918,783)))
  bus-terminals(860,636,783,[$V_"in"$])
  cross(918,1020,703,985);wire(((1020,703),(1020,679),(1041,679)))
  ind(1041,679,n:3,pitch:7,depth:5);wire(((1062,679),(1081,679)))
  wire(((985,723),(1024,723),(1024,740),(1081,740)))
  trafo(1081,1124,679,61)
  wire(((1124,679),(1141,679)));wire(((1124,740),(1141,740)))
  block(1141,646,101,127);diode(1191,710)
  wire(((1242,664),(1391,664)));wire(((1242,757),(1391,757)))
  block(1268,683,86,53,c:"#dceef1");lab(1311,709,[Auxiliary\ Circuit],size:8.1pt)
  wire(((1311,664),(1311,683)));wire(((1311,736),(1311,757)))
  dot(1311,664);dot(1311,757)
  bus-terminals(1391,664,757,[$V_"out"$],left:false);lab(1053,662,[$L_k$])
  arrow((1296,742),(1276,781),w:9);arrow((1330,742),(1363,781),w:9)
  dotted(1218,787,113,60);smallpaired(1230,799);smalltrafo(1281,799)
  dotted(1356,787,51,51);wire(((1373,795),(1373,804),(1364,822)));wire(((1373,825),(1373,832)))
  diode(1392,814,leads:false);wire(((1392,795),(1392,832)))
  lab(1162,853,[(d)])
'''
body=re.sub(r"ring\((\d+),(\d+),\[\$A'\$\]\)",r"ring(\1,\2,[$A'$],right:true)",body)
(batch/'typ/pdf033-soft-switching-networks.typ').write_text(header+extra+body+'\n})\n',encoding='utf-8')
print('Wrote full native Fig.5 with all four panels.')
