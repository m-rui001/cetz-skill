#set page(width:auto,height:auto,margin:10pt)
#import "@preview/cetz:0.4.2":canvas,draw
#set text(font:"Calibri",size:10pt,style:"italic")
#set par(leading:0pt)
#canvas(length:1pt,{
  import draw:*
  let P=(x,y)=>(.4*x,.4*(464 - y))
  let fiber=(paint:rgb("#b8ad17"),thickness:.55pt)
  let label=(x,y,c,size:8.2pt)=>content(P(x,y),text(size:size,c))
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
