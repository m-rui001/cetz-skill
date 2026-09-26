#set page(width:auto,height:auto,margin:2pt)
#set text(font:"Times New Roman",size:7.5pt)
#import "@preview/cetz:0.4.2":canvas,draw
#canvas(length:1pt,{
  import draw:*
  let P=(x,y)=>(x*.5,(600 - y)*.5)
  let wire=(pts)=>line(..pts.map(p=>P(..p)),stroke:.7pt)
  let lab=(x,y,c)=>content(P(x,y),c)
  let dot=(x,y)=>circle(P(x,y),radius:1,fill:black,stroke:none)
  let port=(x,y)=>circle(P(x,y),radius:1.35,fill:white,stroke:.7pt)
  let dh=(x,y)=>{
    wire(((x - 12,y),(x + 12,y)))
    line(P(x + 5,y),P(x - 5,y - 5),P(x - 5,y + 5),close:true,fill:black,stroke:none)
    wire(((x + 6,y - 6),(x + 6,y + 6)))
  }
  let dv=(x,y)=>{
    wire(((x,y - 12),(x,y + 12)))
    line(P(x,y - 5),P(x - 5,y + 5),P(x + 5,y + 5),close:true,fill:black,stroke:none)
    wire(((x - 6,y - 6),(x + 6,y - 6)))
  }
  let cap=(x,y,top,bot)=>{
    wire(((x,top),(x,y)));wire(((x - 8,y),(x + 8,y)))
    bezier(P(x - 8,y + 8),P(x + 8,y + 8),P(x - 7,y + 1),P(x + 7,y + 1),stroke:.7pt)
    wire(((x,y + 2.75),(x,bot)))
  }
  let coil=(x,y,n:4,gray:false)=>{
    let pitch=if gray {5} else {7}
    for i in range(n) {bezier(P(x + i*pitch,y),P(x + (i + 1)*pitch,y),P(x + i*pitch,y - 7),P(x + (i + 1)*pitch,y - 7),stroke:(paint:if gray {rgb("#999999")} else {black},thickness:.7pt))}
  }
  let winding=(x,y)=>{
    for i in range(4) {bezier(P(x,y + i*7),P(x,y + (i + 1)*7),P(x + 7,y + i*7),P(x + 7,y + (i + 1)*7),stroke:.7pt)}
  }
  let battery=(x,y,top,bot)=>{
    wire(((x,top),(x,y - 3)));wire(((x,y + 3),(x,bot)))
    wire(((x - 11,y - 3),(x + 11,y - 3)));wire(((x - 5,y + 3),(x + 5,y + 3)))
    lab(x - 22,y,[$V_"in"$])
  }
  let res=(x,y,top,bot)=>{
    wire(((x,top),(x,y - 10),(x + 4,y - 7),(x - 4,y - 3),(x + 4,y + 1),(x - 4,y + 5),(x + 4,y + 8),(x,y + 11),(x,bot)))
  }
  let block=(x,y,w,h,c)=>{
    rect(P(x,y),P(x + w,y + h),radius:2.5pt,fill:rgb("#dcedf0"),stroke:.7pt)
    content(P(x + w/2,y + h/2),text(size:10pt,c))
  }

  // General position, original top panel (a).
  wire(((216,160),(241,160)));wire(((340,160),(445,160)))
  wire(((216,244),(445,244)));battery(216,201,160,244)
  wire(((370,160),(370,192),(380,206)));wire(((370,211),(370,244)))
  dh(391,160);cap(413,201,160,244);res(445,201,160,244)
  block(241,135,99,50,[VL-SL Cell])
  for (x,y) in ((231,160),(351,160)) {port(x,y)}
  for (x,y) in ((370,160),(370,244),(413,160),(413,244)) {dot(x,y)}
  lab(231,173,[A]);lab(351,173,[B]);lab(390,146,[$D_o$]);lab(361,204,[$S$]);content(P(394,202),text(size:6.5pt,[$C_o$]));content(P(432,202),text(size:6.5pt,[$R_o$]));lab(464,205,[$V_"out"$]);lab(340,260,[(a)])
  // Basic SL cell.
  wire(((160,320),(180,320),(180,293),(252,293)));coil(252,293);wire(((280,293),(295,293),(295,346),(251,346)))
  wire(((160,320),(180,320),(180,346),(193,346)));coil(193,346);wire(((221,346),(251,346)))
  dh(208,293);dh(268,346);wire(((238,293),(238,305)));dv(238,317);wire(((238,329),(238,346)))
  wire(((295,320),(317,320)))
  for (x,y) in ((180,320),(238,293),(238,346),(295,320)) {dot(x,y)}
  for (x,y) in ((160,320),(317,320)) {port(x,y)}
  lab(160,309,[A]);lab(317,309,[B]);lab(208,279,[$D_2$]);lab(267,277,[$L_2$]);lab(252,314,[$D_0$]);lab(208,358,[$L_1$]);lab(269,360,[$D_1$]);lab(237,384,[Basic SL Cell]);lab(237,406,[(a)])
  // Elementary lift, gray resonant inductance.
  wire(((367,302),(444,302)));dh(418,302);coil(444,302,gray:true);wire(((464,302),(475,302)))
  wire(((394,302),(394,314)));winding(394,314);wire(((394,342),(394,352),(501,352)))
  cap(475,325,302,352)
  for (x,y) in ((394,302),(475,352)) {dot(x,y)}
  for (x,y) in ((367,302),(501,352)) {port(x,y)}
  lab(367,292,[A]);lab(501,343,[B]);lab(418,290,[$D_1$]);content(P(456,288),text(fill:rgb("#999999"),[$L_r$]));lab(383,330,[$L_1$]);lab(458,330,[$C_1$]);lab(435,384,[Elementary-Lift Cell]);lab(435,406,[(b)])
  // Self-lift cell.
  wire(((160,493),(180,493),(180,458),(252,458)));dh(208,458);coil(252,458);wire(((280,458),(295,458),(295,530),(251,530)))
  wire(((180,493),(238,493)));dh(208,493);wire(((238,458),(238,465)));dv(238,477);wire(((238,489),(238,493)))
  cap(238,506,493,530)
  wire(((180,493),(180,530),(193,530)));coil(193,530);wire(((221,530),(251,530)));dh(268,530);wire(((295,493),(317,493)))
  for (x,y) in ((180,493),(238,458),(238,493),(238,530),(295,493)) {dot(x,y)}
  for (x,y) in ((160,493),(317,493)) {port(x,y)}
  lab(160,481,[A]);lab(317,481,[B]);lab(208,442,[$D_2$]);lab(267,442,[$L_2$]);lab(208,480,[$D_3$]);lab(255,477,[$D_0$]);lab(259,511,[$C_1$]);lab(209,542,[$L_1$]);lab(270,543,[$D_1$]);lab(241,563,[Self-Lift SL Cell]);lab(237,586,[(c)])
  // Double self-lift cell, central open switch and intermediate right branch.
  wire(((353,489),(373,489),(373,445),(444,445)));dh(401,445);coil(444,445);wire(((472,445),(488,445),(488,535),(443,535)))
  wire(((373,489),(373,535),(387,535)));coil(387,535);wire(((415,535),(443,535)));dh(459,535)
  cap(430,458,445,476);wire(((430,476),(488,476)));dh(459,476)
  wire(((373,503),(430,503)));dh(401,503)
  wire(((430,476),(430,484),(439,496)));wire(((430,499),(430,508)));cap(430,516,508,535)
  wire(((488,489),(510,489)))
  for (x,y) in ((373,489),(373,503),(430,445),(430,476),(430,503),(430,535),(488,476),(488,489)) {dot(x,y)}
  for (x,y) in ((353,489),(510,489)) {port(x,y)}
  lab(353,478,[A]);lab(510,478,[B]);lab(401,432,[$D_2$]);lab(459,430,[$L_2$]);lab(447,461,[$C_2$]);lab(452,495,[$S_0$]);lab(470,490,[$D_4$]);lab(401,490,[$D_3$]);lab(447,520,[$C_1$]);lab(401,548,[$L_1$]);lab(459,549,[$D_1$]);lab(434,568,[Double Self-Lift SL Cell]);lab(435,588,[(d)])
})
