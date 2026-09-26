from pathlib import Path
b=Path(__file__).parent
old=(b.parent/'batch55/typ/pdf037-switched-capacitor-converters.typ').read_text(encoding='utf-8')
head=old.split('  // (a) two charge-transfer',1)[0]
head=head.replace('let s=.5','let s=.68').replace('x - 112','x - 648').replace('1408 - y','890 - y').replace('size:7.2pt','size:7.8pt').replace('.7pt','.9pt')
extra=r'''
  let cellport=(x,y,c,below:false)=>{
    circle(P(x,y),radius:1.3,fill:white,stroke:.9pt)
    lab(x,y + (if below {12} else {-12}),c)
  }
  let hc2=(x,y,left,right,rev:false)=>{
    let d=if rev {-1} else {1}
    wire(((x + 3*d,y - 8),(x + 3*d,y + 8)))
    bezier(P(x - 7*d,y - 8),P(x - 7*d,y + 8),P(x,y - 7),P(x,y + 7),stroke:.9pt)
    wire(((left,y),(x + (if rev {-3} else {-1.75}),y)))
    wire(((x + (if rev {1.75} else {3}),y),(right,y)))
  }
  let coil=(x,y,c:black,pitch:5)=>{
    for i in range(4) {bezier(P(x + i*pitch,y),P(x + (i + 1)*pitch,y),P(x + i*pitch,y - 7),P(x + (i + 1)*pitch,y - 7),stroke:(paint:c,thickness:.9pt))}
  }
  let winding2=(x,y,h,d:1)=>{
    for i in range(4) {bezier(P(x,y + i*h/4),P(x,y + (i + 1)*h/4),P(x + 7*d,y + i*h/4),P(x + 7*d,y + (i + 1)*h/4),stroke:.9pt)}
  }
  let diagonal=(xl,xr,top,mid)=>{
    let xm=(xl + xr)/2
    wire(((xl,top),(xm - 3,(top + mid)/2 - 2)))
    bezier(P(xm - 3,(top + mid)/2 - 2),P(xm + 3,(top + mid)/2 + 2),P(xm - 2,(top + mid)/2 - 7),P(xm + 5,(top + mid)/2 - 2),stroke:.9pt)
    wire(((xm + 3,(top + mid)/2 + 2),(xr,mid)))
  }
'''
body=r'''
  // (a) general placement of a voltage multiplier cell.
  rect(P(824,497),P(888,585),radius:4*.68,fill:rgb("#dceef1"),stroke:.9pt)
  content(P(856,541),text(size:13pt,[VMC]))
  wire(((746,506),(763,506)));coil(763,506);wire(((783,506),(824,506)))
  wire(((888,506),(911,506)));coil(911,506);wire(((931,506),(972,506)))
  wire(((746,578),(824,578)));wire(((888,578),(972,578)))
  battery(746,542);wire(((746,506),(746,529)));wire(((746,555),(746,578)))
  wire(((798,506),(798,533),(806,545)));wire(((798,547),(798,578)))
  vc(943,540,506,578)
  wire(((972,506),(972,534)))
  let rpts=((972,534),)
  for i in range(1,7) {rpts.push((972 + (if calc.rem(i,2)==1 {3} else {-3}),534 + i*16/7))}
  rpts.push((972,550));wire(rpts);wire(((972,550),(972,578)))
  for (x,y) in ((798,506),(798,578),(943,506),(943,578)) {dot(x,y)}
  cellport(811,506,[A],below:true);cellport(811,578,[B]);cellport(901,506,[$A'$],below:true);cellport(901,578,[$B'$])
  lab(727,542,[$V_"in"$]);lab(791,541,[$S$]);lab(774,493,[$L_"in"$]);lab(923,493,[$L_o$]);lab(926,544,[$C_o$]);lab(960,544,[$R_o$]);lab(989,544,[$V_"out"$]);lab(856,597,[(a)])
  // (b) diode/capacitor cell with crossed branches.
  wire(((665,641),(702,641)));diode-h(718,641);wire(((734,641),(765,641)))
  wire(((665,716),(702,716)));diode-h(718,716,left:true);wire(((734,716),(765,716)))
  diagonal(686,743,641,678);wire(((745,641),(687,678)))
  vc(687,689,678,716);vc(743,689,678,716)
  for (x,y) in ((686,641),(745,641),(687,716),(743,716)) {dot(x,y)}
  cellport(665,641,[A]);cellport(765,641,[$A'$]);cellport(665,716,[B],below:true);cellport(765,716,[$B'$],below:true)
  lab(718,628,[$D_1$]);lab(718,703,[$D_2$]);lab(672,699,[$C_1$]);lab(759,699,[$C_2$]);lab(715,739,[(b)])
  // (c) capacitor/diode form; the lower capacitor's curved plate faces right.
  hc2(855,641,804,904);hc2(855,716,804,904,rev:true)
  diagonal(825,881,641,678);wire(((884,641),(826,678)))
  wire(((826,678),(826,680)));diode(826,695);wire(((826,710),(826,716)))
  wire(((881,678),(881,680)));diode(881,695);wire(((881,710),(881,716)))
  for (x,y) in ((825,641),(884,641),(826,716),(881,716)) {dot(x,y)}
  cellport(804,641,[A]);cellport(904,641,[$A'$]);cellport(804,716,[B],below:true);cellport(904,716,[$B'$],below:true)
  lab(855,628,[$C_1$]);lab(855,703,[$C_2$]);lab(813,699,[$D_1$]);lab(894,699,[$D_2$]);lab(855,739,[(c)])
  // (d) two diode branches and a gray resonant-inductance annotation.
  wire(((938,641),(991,641)));hc2(1006,641,991,1038)
  coil(966,641,c:gray,pitch:4.5)
  wire(((953,641),(953,666),(954,666)));diode-h(970,666)
  wire(((986,666),(988,666)));diode-h(1004,666);wire(((1020,666),(1022,666),(1022,641)))
  vc(987,688,666,716);wire(((938,716),(1038,716)))
  for (x,y) in ((953,641),(1022,641),(987,666),(987,716)) {dot(x,y)}
  cellport(938,641,[A]);cellport(1038,641,[$A'$]);cellport(938,716,[B],below:true);cellport(1038,716,[$B'$],below:true)
  content(P(980,628),text(fill:gray,[$L_r$]));lab(1006,628,[$C_1$]);lab(970,678,[$D_1$]);lab(1004,678,[$D_2$]);lab(974,704,[$C_2$]);lab(987,739,[(d)])
  // (e) auxiliary switch and two crossed capacitor returns.
  wire(((667,778),(703,778)));diode-h(719,778);wire(((735,778),(767,778)))
  wire(((667,853),(703,853)));diode-h(719,853,left:true);wire(((735,853),(767,853)))
  wire(((689,778),(713,813)))
  bezier(P(713,813),P(718,818),P(715,809),P(721,814),stroke:.9pt)
  wire(((718,818),(723,830),(741,830)));wire(((689,853),(723,801),(741,801)))
  vc(741,790,778,801);vc(741,837,830,853)
  wire(((741,801),(741,811),(749,821)));wire(((741,823),(741,830)))
  for (x,y) in ((689,778),(741,778),(741,801),(741,830),(741,853),(689,853)) {dot(x,y)}
  cellport(667,778,[A]);cellport(767,778,[$A'$]);cellport(667,853,[B],below:true);cellport(767,853,[$B'$],below:true)
  lab(719,765,[$D_1$]);lab(719,840,[$D_2$]);lab(759,796,[$C_1$]);lab(759,843,[$C_2$]);lab(733,816,[$S_a$]);lab(716,876,[(e)])
  // (f) two inductors, two downward diodes and a reverse horizontal capacitor.
  wire(((810,778),(904,778)));wire(((810,853),(904,853)))
  wire(((832,778),(832,782)));diode(832,797,up:false);wire(((832,812),(832,815)))
  winding2(832,820,30);wire(((832,815),(832,820)));wire(((832,850),(832,853)))
  winding2(879,784,30);wire(((879,778),(879,784)));wire(((879,814),(879,815)))
  wire(((879,815),(879,819)));diode(879,834,up:false);wire(((879,849),(879,853)))
  hc2(855,815,832,879,rev:true)
  for (x,y) in ((832,778),(879,778),(832,815),(879,815),(832,853),(879,853)) {dot(x,y)}
  cellport(810,778,[A]);cellport(904,778,[$A'$]);cellport(810,853,[B],below:true);cellport(904,853,[$B'$],below:true)
  lab(820,798,[$D_1$]);lab(891,837,[$D_2$]);lab(892,800,[$L_1$]);lab(820,837,[$L_2$]);lab(855,802,[$C$]);lab(856,876,[(f)])
  // (g) parallel diode path above the inductor-capacitor branch.
  wire(((939,795),(950,795),(950,770),(971,770)));diode-h(987,770);wire(((1003,770),(1026,770),(1026,795),(1038,795)))
  wire(((939,795),(950,795)));diode-h(966,795);wire(((982,795),(992,795)));coil(992,795,pitch:6.5)
  wire(((1018,795),(1038,795)));wire(((939,853),(1038,853)));vc(984,821,795,853)
  for (x,y) in ((950,795),(984,795),(1026,795),(984,853)) {dot(x,y)}
  cellport(939,795,[A]);cellport(1038,795,[$A'$]);cellport(939,853,[B],below:true);cellport(1038,853,[$B'$],below:true)
  lab(987,784,[$D_2$]);lab(966,807,[$D_1$]);lab(1005,808,[$L$]);lab(997,835,[$C$]);lab(987,876,[(g)])
})
'''
(b/'typ/pdf038-voltage-multiplier-cells.typ').write_text(head+extra+body,encoding='utf-8')
