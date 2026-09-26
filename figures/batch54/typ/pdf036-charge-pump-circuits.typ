#set page(width:auto,height:auto,margin:2pt)
#set text(font:"Times New Roman",size:6.6pt)
#set par(leading:2pt)
#import "@preview/cetz:0.4.2":canvas,draw
#canvas(length:1pt,{
  import draw:*
  let s=.47
  let P=(x,y)=>(s*(x - 104),s*(922 - y))
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

  let ground=(x,y)=>{
    wire(((x - 7,y),(x + 7,y)));wire(((x - 4.5,y + 3),(x + 4.5,y + 3)));wire(((x - 2,y + 6),(x + 2,y + 6)))
  }
  let port=(x,y,c:none,below:16)=>{
    circle(P(x,y),radius:1.3,fill:white,stroke:.7pt)
    if c!=none {lab(x,y + below,c)}
  }
  let open-h=(x,y)=>{
    wire(((x - 20,y),(x - 7,y)));wire(((x + 7,y),(x + 20,y)))
    wire(((x + 7,y),(x - 7,y - 10)))
  }
  let open-v=(x,y,bot:none)=>{
    wire(((x,y - 20),(x,y - 7)));wire(((x,y + 7),(x,if bot==none {y + 20} else {bot})))
    wire(((x,y + 7),(x + 9,y - 7)))
  }
  let cap-ground=(x,y,bot,c)=>{
    cap(x,y);wire(((x,y + 15),(x,bot)));ground(x,bot);lab(x - 21,y,c)
  }
  let highlight=(x,y,w,h)=>rect(P(x,y),P(x + w,y + h),radius:5*s,fill:rgb("#fff2cb"),stroke:none)

  // (a) two-phase basic charge pump.
  wire(((138,578),(148,578)));open-h(168,578);wire(((188,578),(206,578)))
  open-h(226,578);wire(((246,578),(285,578)))
  battery(138,616);wire(((138,578),(138,603)));wire(((138,629),(138,658)));ground(138,658)
  wire(((196,578),(196,603)));cap-ground(196,618,658,[$C_1$])
  wire(((252,578),(252,604)));cap-ground(252,619,658,[$C_2$])
  dot(196,578);dot(252,578);port(285,578,c:[$V_"out"$])
  lab(116,616,[$V_"in"$]);lab(173,564,[I]);lab(235,564,[II])
  lab(210,686,[Basic Charge Pump]);lab(210,710,[(a)])
  // (b) double-position selector; four open fixed contacts.
  wire(((335,574),(398,574)));wire(((335,574),(335,600)));battery(335,613)
  wire(((335,626),(335,651),(398,651)));wire(((335,651),(335,662)));ground(335,662)
  wire(((398,574),(410,585),(410,598)));cap(410,613)
  wire(((410,628),(410,640),(398,651)))
  wire(((421,574),(499,574)));wire(((421,651),(421,663),(362,663),(362,656)))
  // Non-connection hump around the lower wire at x=362.
  wire(((362,574),(362,647)))
  bezier(P(362,647),P(362,655),P(369,647),P(369,655),stroke:.7pt)
  wire(((362,655),(362,656)))
  wire(((466,574),(466,600)));cap-ground(466,615,662,[$C_2$])
  for (x,y) in ((362,574),(335,651),(398,574),(398,651),(466,574)) {dot(x,y)}
  port(421,574);port(421,651);port(499,574,c:[$V_"out"$])
  lab(390,613,[$C_1$]);lab(313,613,[$V_"in"$]);lab(398,563,[I]);lab(422,563,[II]);lab(398,641,[I]);lab(422,641,[II])
  lab(416,690,[Basic Switched Capacitor]);lab(416,710,[(b)])
  // (c) doubler with highlighted first cell, then an additional cell.
  highlight(553,547,122,129)
  wire(((537,571),(568,571)));open-h(588,571);wire(((608,571),(616,571),(616,580)))
  open-h(635,571);wire(((655,571),(664,571),(664,603)))
  wire(((655,571),(690,571)));open-h(710,571);wire(((730,571),(735,571),(735,580)))
  open-h(754,571);wire(((774,571),(811,571)))
  battery(537,625);wire(((537,571),(537,612)));wire(((537,638),(537,666)));ground(537,666)
  wire(((572,571),(572,580)));open-v(572,598,bot:615);wire(((572,615),(616,615)))
  cap(616,595);wire(((616,610),(616,625)));open-v(616,645,bot:666);ground(616,666)
  cap-ground(664,619,666,[$C_2$])
  wire(((690,571),(690,580)));open-v(690,598,bot:615);wire(((690,615),(735,615)))
  cap(735,595);wire(((735,610),(735,625)));open-v(735,645,bot:666);ground(735,666)
  wire(((779,571),(779,605)));cap(779,620);wire(((779,635),(779,666)));ground(779,666)
  for (x,y) in ((572,571),(616,571),(616,615),(664,571),(690,571),(735,571),(735,615),(779,571)) {dot(x,y)}
  port(811,571,c:[$V_"out"$]);lab(515,625,[$V_"in"$]);lab(603,595,[$C_1$]);lab(719,595,[$C_3$]);lab(801,620,[$C_o$])
  for (x,y,c) in ((595,556,[I]),(645,556,[II]),(721,556,[I]),(765,556,[II]),(563,597,[II]),(608,640,[I]),(680,597,[II]),(726,640,[I])) {lab(x,y,c)}
  lab(670,690,[Doubler]);lab(670,710,[(c)])
  // (d) series-parallel cell and a second stage.
  highlight(944,553,69,129)
  wire(((858,559),(1000,559)));wire(((858,559),(858,617)));battery(858,630)
  wire(((858,643),(858,674)));ground(858,674)
  wire(((925,559),(925,570)));open-v(925,590,bot:601);cap(925,616)
  wire(((925,631),(925,644)));open-v(925,654,bot:675);ground(925,675)
  wire(((1000,559),(1000,570)));open-v(1000,590,bot:601);cap(1000,616)
  wire(((1000,631),(1000,644)));open-v(1000,654,bot:675);ground(1000,675)
  wire(((858,597),(878,597),(878,630),(888,630)));open-h(908,630);wire(((928,630),(925,630)))
  wire(((925,597),(953,597),(953,630),(963,630)));open-h(983,630);wire(((1003,630),(1000,630)))
  wire(((1000,597),(1017,597)));open-h(1037,597);wire(((1057,597),(1074,597)))
  wire(((1046,597),(1046,635)));cap(1046,650);wire(((1046,665),(1046,674)));ground(1046,674)
  for (x,y) in ((858,597),(925,559),(925,597),(925,630),(1000,597),(1000,630),(1046,597)) {dot(x,y)}
  port(1074,597,c:[$V_"out"$]);lab(836,630,[$V_"in"$]);lab(908,614,[$C_1$]);lab(982,614,[$C_2$]);lab(1069,649,[$C_o$])
  for (x,y,c) in ((920,577,[I]),(994,577,[I]),(919,650,[I]),(994,650,[I]),(899,639,[II]),(974,640,[II]),(1033,584,[II])) {lab(x,y,c)}
  lab(939,690,[Series-Parallel]);lab(939,711,[(d)])
  // (e) ladder, including three capacitors and both input ports.
  line(P(302,742),P(385,742),P(385,818),P(331,818),P(331,863),P(259,863),P(259,822),P(301,822),close:true,fill:rgb("#fff2cb"),stroke:none)
  wire(((146,805),(151,805)));open-h(171,805);wire(((191,805),(191,770),(213,770)))
  open-h(211,805);wire(((231,805),(233,805)))
  open-h(252,805);wire(((272,805),(273,805)))
  open-h(293,805);wire(((313,805),(314,805)))
  open-h(334,805);wire(((354,805),(354,770),(328,770)))
  open-h(375,805);wire(((395,805),(400,805)))
  cap-h(228,770);wire(((243,770),(299,770)));cap-h(314,770)
  wire(((273,770),(273,805)));wire(((233,805),(233,853)))
  wire(((233,838),(255,838)));cap-h(270,838);wire(((285,838),(314,838),(314,805)))
  wire(((314,838),(314,849)),)
  wire(((146,805),(146,864)));ground(146,864)
  for (x,y) in ((191,805),(233,805),(233,838),(273,770),(273,805),(314,805),(314,838),(354,805)) {dot(x,y)}
  port(233,853,c:[$V_"in"$]);port(400,805,c:[$V_"out"$])
  line(P(314,840),P(314,853),stroke:(paint:gray,thickness:.7pt,dash:"dotted"))
  circle(P(314,853),radius:1.3,fill:white,stroke:gray);content(P(314,869),text(fill:gray,[$V_"in"$]))
  lab(228,754,[$C_1$]);lab(314,754,[$C_3$]);lab(270,855,[$C_2$])
  for (x,c) in ((174,[I]),(214,[II]),(255,[I]),(296,[II]),(336,[I]),(378,[II])) {lab(x,793,c)}
  lab(257,887,[Ladder]);lab(257,910,[(e)])
  // (f) Dickson with four lower switches and the non-connection crossing.
  highlight(565,748,51,83)
  wire(((441,772),(507,772)));open-h(527,772);wire(((547,772),(562,772)))
  open-h(582,772);wire(((602,772),(613,772)));open-h(633,772);wire(((653,772),(663,772)))
  open-h(683,772);wire(((703,772),(727,772)))
  wire(((550,772),(550,784)));cap(550,799);wire(((550,814),(550,855)))
  wire(((603,772),(603,784)));cap(603,799);wire(((603,814),(603,824),(516,824)))
  wire(((652,772),(652,784)));cap(652,799);wire(((652,814),(652,855),(516,855)))
  wire(((699,772),(699,805)));cap(699,820);wire(((699,835),(699,863)));ground(699,863)
  wire(((467,772),(467,856),(487,856)));wire(((467,809),(487,809)))
  wire(((450,839),(450,824),(487,824)));wire(((450,839),(487,839)))
  wire(((450,839),(450,863)));ground(450,863)
  // Lower bank: I, II, I, II; branch wires meet each selected capacitor return.
  for (y,c) in ((809,[I]),(824,[II]),(839,[I]),(856,[II])) {
    wire(((487,y),(493,y),(507,y - 8)));wire(((509,y),(516,y)))
    lab(491,y - 7,c)
  }
  wire(((516,809),(516,824)));wire(((516,839),(516,855)))
  wire(((516,824),(546,824)));wire(((554,824),(603,824)))
  bezier(P(546,824),P(554,824),P(546,817),P(554,817),stroke:.7pt)
  for (x,y) in ((467,772),(550,772),(603,772),(652,772),(550,855),(516,824),(516,855),(450,839)) {dot(x,y)}
  port(441,772,c:[$V_"in"$]);port(727,772,c:[$V_"out"$])
  lab(532,799,[$C_1$]);lab(582,799,[$C_2$]);lab(634,799,[$C_3$]);lab(680,820,[$C_o$])
  for (x,c) in ((528,[I]),(584,[II]),(635,[I]),(684,[II])) {lab(x,758,c)}
  lab(586,887,[Dickson]);lab(586,910,[(f)])
  // (g) Makowski/Fibonacci cell with independently switched capacitor returns.
  highlight(899,745,89,129)
  wire(((795,769),(831,769)));open-h(851,769);wire(((871,769),(883,769),(883,782)))
  open-h(943,769);wire(((963,769),(974,769),(974,782)))
  wire(((883,769),(923,769)));wire(((974,769),(979,769)));open-h(999,769);wire(((1019,769),(1054,769)))
  wire(((795,769),(795,804)));battery(795,817);wire(((795,830),(795,864)));ground(795,864)
  wire(((827,769),(827,787)));open-v(827,807,bot:814);wire(((827,814),(883,814)))
  cap(883,797);wire(((883,812),(883,829)));open-v(883,849,bot:864);ground(883,864)
  wire(((918,769),(918,787)));open-v(918,807,bot:814);wire(((918,814),(974,814)))
  cap(974,797);wire(((974,812),(974,829)));open-v(974,849,bot:864);ground(974,864)
  wire(((1019,769),(1019,800)));cap(1019,815);wire(((1019,830),(1019,864)));ground(1019,864)
  for (x,y) in ((827,769),(883,769),(883,814),(918,769),(974,769),(974,814),(1019,769)) {dot(x,y)}
  port(1054,769,c:[$V_"out"$]);lab(772,817,[$V_"in"$]);lab(862,797,[$C_1$]);lab(953,797,[$C_2$]);lab(1042,815,[$C_o$])
  for (x,y,c) in ((859,756,[I]),(952,756,[II]),(1007,756,[I]),(816,800,[II]),(909,800,[I]),(874,838,[I]),(965,838,[II])) {lab(x,y,c)}
  lab(941,887,[Makowski or Fibonacci]);lab(941,910,[(g)])
})
