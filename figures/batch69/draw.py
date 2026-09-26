from pathlib import Path
b=Path(__file__).parent
base=(b.parent/'batch67/typ/pdf042-voltage-lift-cells.typ').read_text(encoding='utf-8').split('  // General position',1)[0].replace('(600 - y)','(635 - y)').replace('#canvas(', '#let textrotate=rotate\n#canvas(')
extra=r'''
  let dh=(x,y,left:false)=>{
    wire(((x - 12,y),(x + 12,y)))
    let d=if left {-1} else {1}
    line(P(x + 5*d,y),P(x - 5*d,y - 5),P(x - 5*d,y + 5),close:true,fill:black,stroke:none)
    wire(((x + 6*d,y - 6),(x + 6*d,y + 6)))
  }
  let dv=(x,y,up:true)=>{
    wire(((x,y - 12),(x,y + 12)))
    let d=if up {-1} else {1}
    line(P(x,y + 5*d),P(x - 5,y - 5*d),P(x + 5,y - 5*d),close:true,fill:black,stroke:none)
    wire(((x - 6,y + 6*d),(x + 6,y + 6*d)))
  }
  let hc=(x,y,left,right,reverse:false)=>{
    let d=if reverse {-1} else {1}
    let mid=x - 2.75*d
    bezier(P(x - 8*d,y - 8),P(x - 8*d,y + 8),P(x - 1*d,y - 7),P(x - 1*d,y + 7),stroke:.7pt)
    wire(((x + 2*d,y - 8),(x + 2*d,y + 8)))
    if reverse {wire(((left,y),(x - 2,y)));wire(((mid,y),(right,y)))} else {wire(((left,y),(mid,y)));wire(((x + 2,y),(right,y)))}
  }
  let wind=(a,b,side:1,core:false,dotted:0)=>{
    let dx=b.at(0) - a.at(0);let dy=b.at(1) - a.at(1)
    let r=calc.sqrt(dx*dx + dy*dy);let ux=dx/r;let uy=dy/r
    let q=(t,k)=>(a.at(0) + t*dx - k*uy,a.at(1) + t*dy + k*ux)
    for i in range(4) {bezier(P(..q(i/4,0)),P(..q((i + 1)/4,0)),P(..q(i/4,7*side)),P(..q((i + 1)/4,7*side)),stroke:.7pt)}
    if core {for k in (-8*side,-11*side) {wire((q(0,k),q(1,k)))}}
    if dotted == 1 {let z=q(-.12,-5*side);dot(..z)}
    if dotted == 2 {let z=q(1.12,-5*side);dot(..z)}
  }
  let arrtip=(a,b)=>{
    let dx=b.at(0) - a.at(0);let dy=b.at(1) - a.at(1);let r=calc.sqrt(dx*dx + dy*dy);let ux=dx/r;let uy=dy/r
    line(P(..a),P(a.at(0) + 5*ux - 2*uy,a.at(1) + 5*uy + 2*ux),P(a.at(0) + 5*ux + 2*uy,a.at(1) + 5*uy - 2*ux),close:true,fill:black,stroke:none)
  }
  let ratio=(a,b,c,d,p,angle:0deg)=>{
    bezier(P(..a),P(..b),P(..c),P(..d),stroke:.4pt);arrtip(a,c);arrtip(b,d)
    content(P(..p),textrotate(angle,[$1:n$]))
  }
  let ds=(a,b,c)=>{
    wire((a,b));let dx=b.at(0) - a.at(0);let dy=b.at(1) - a.at(1);let r=calc.sqrt(dx*dx + dy*dy);let ux=dx/r;let uy=dy/r
    let q=(t,k)=>(c.at(0) + t*ux - k*uy,c.at(1) + t*uy + k*ux)
    line(P(..q(5,0)),P(..q(-5,5)),P(..q(-5,-5)),close:true,fill:black,stroke:none);wire((q(6,-6),q(6,6)))
  }
  let crossline=(a,b,c)=>{
    let dx=b.at(0) - a.at(0);let dy=b.at(1) - a.at(1);let r=calc.sqrt(dx*dx + dy*dy);let ux=dx/r;let uy=dy/r
    let q=(t,k)=>(c.at(0) + t*ux - k*uy,c.at(1) + t*uy + k*ux)
    wire((a,q(-4,0)));bezier(P(..q(-4,0)),P(..q(4,0)),P(..q(-4,-6)),P(..q(4,-6)),stroke:.7pt);wire((q(4,0),b))
  }
  let xs=(tl,tr,bl,br,c)=>{
    let x=tl.at(0);let xr=tr.at(0);let y=tl.at(1)
    wire((tl,(x + 20,y + 23),(x + 32,y + 28)))
    wire((tr,(xr - 20,y + 23),(xr - 32,y + 28)))
    let ax=x + 28;let bx=xr - 28;let yy=y + 34
    let t=(bx - ax)/(br.at(0) - ax + bx - bl.at(0))
    let crossing=(ax + (br.at(0) - ax)*t,yy + (br.at(1) - yy)*t)
    crossline((ax,yy),br,crossing);wire(((bx,yy),bl))
    lab(x + 13,y + 33,[$S_1$]);lab(xr - 11,y + 33,[$S_2$])
  }
  let fourports=(l,r,top,bot)=>{
    for (x,y) in ((l,top),(l,bot),(r,top),(r,bot)) {port(x,y)}
    lab(l,top - 11,[A]);lab(l,bot + 12,[B]);lab(r,top - 11,[A′]);lab(r + 2,bot + 12,[B′])
  }
'''
a=r'''
  // (a) A-SL.
  wire(((210,192),(255,192)));wind((255,192),(283,192),side:-1);wire(((283,192),(331,192)))
  wire(((210,283),(254,283)));wind((254,283),(282,283));wire(((282,283),(331,283)))
  xs((230,192),(312,192),(236,283),(303,283),(274,244))
  for (x,y) in ((230,192),(312,192),(236,283),(303,283)) {dot(x,y)}
  fourports(210,331,192,283);lab(270,178,[$L_1$]);lab(270,298,[$L_2$]);lab(271,335,[A-SL]);lab(271,367,[(a)])
  // (b) improved A-SL, diodes wrap around the central capacitor buses.
  wire(((392,192),(438,192)));wind((438,192),(466,192),side:-1);hc(508,192,466,547)
  wire(((392,283),(435,283)));wind((435,283),(463,283));hc(508,283,463,547,reverse:true)
  wire(((412,192),(412,159),(522,159),(522,192)));dh(470,159)
  wire(((419,283),(419,314),(522,314),(522,283)));dh(470,314,left:true)
  xs((412,192),(494,192),(419,283),(487,283),(455,244))
  for (x,y) in ((412,192),(494,192),(522,192),(419,283),(487,283),(522,283)) {dot(x,y)}
  fourports(392,547,192,283);lab(453,179,[$L_1$]);lab(453,300,[$L_2$]);lab(470,146,[$D_1$]);lab(470,328,[$D_2$]);lab(514,211,[$C_1$]);lab(514,267,[$C_2$]);lab(470,346,[Improved A-SL]);lab(469,367,[(b)])
  // (c) hybrid, lower diodes mirror the upper group.
  wire(((600,192),(639,192)));wind((639,192),(667,192),side:-1);wire(((667,192),(762,192)));dh(714,192)
  wire(((619,192),(619,155),(698,155)));dh(653,155);wind((698,155),(726,155),side:-1);wire(((726,155),(743,155),(743,192)))
  wire(((682,155),(682,162)));dv(682,174);wire(((682,186),(682,192)))
  wire(((600,283),(687,283)));dh(653,283,left:true);wind((699,283),(727,283));wire(((687,283),(699,283)));wire(((727,283),(762,283)))
  wire(((619,283),(619,322),(635,322)));wind((635,322),(663,322));wire(((663,322),(743,322),(743,283)));dh(714,322,left:true)
  wire(((682,283),(682,290)));dv(682,302,up:false);wire(((682,314),(682,322)))
  xs((619,192),(743,192),(619,283),(743,283),(681,238))
  for (x,y) in ((619,192),(682,155),(682,192),(743,192),(619,283),(682,283),(682,322),(743,283)) {dot(x,y)}
  fourports(600,762,192,283);lab(653,178,[$L_1$]);lab(714,140,[$L_2$]);lab(653,140,[$D_1$]);lab(697,169,[$D_3$]);lab(714,179,[$D_2$]);lab(654,270,[$D_4$]);lab(714,269,[$L_4$]);lab(653,340,[$L_3$]);lab(697,301,[$D_6$]);lab(714,308,[$D_5$]);lab(679,346,[Hybrid A-SL]);lab(673,367,[(c)])
  // (d) QA-SL diagonal primary windings and paired horizontal windings.
  wire(((819,193),(913,193)));wind((913,193),(941,193),side:-1,core:true,dotted:1);wire(((941,193),(963,193)))
  wire(((819,284),(909,284)));wind((909,284),(937,284),core:true,dotted:2);wire(((937,284),(963,284)))
  wire(((891,193),(886,201)));wind((886,201),(872,229),side:-1,core:true,dotted:1)
  wire(((872,229),(865,251)));crossline((865,228),(879,255),(869.54,236.75));wind((879,255),(893,281),side:-1,core:true,dotted:1);wire(((893,281),(895,284)))
  wire(((844,193),(855,214),(855,230)));wire(((847,284),(857,265),(857,247)))
  for (x,y) in ((844,193),(891,193),(847,284),(895,284)) {dot(x,y)}
  fourports(819,963,193,284);lab(865,205,[$L_1$]);lab(858,269,[$L_3$]);lab(929,179,[$L_2$]);lab(929,304,[$L_4$]);lab(843,219,[$S_1$]);lab(843,253,[$S_2$])
  ratio((882,188),(913,184),(887,177),(907,177),(891,175),angle:25deg)
  ratio((882,290),(913,298),(889,300),(906,300),(892,302),angle:-25deg)
  lab(882,336,[QA-SL]);lab(883,367,[(d)])
  // (e) improved QA-SL, sloped diode branches and reversed lower capacitor.
  wire(((247,438),(323,438)));hc(337,438,323,367);wind((367,438),(395,438),side:-1,core:true,dotted:1);wire(((395,438),(416,438)))
  wire(((247,540),(323,540)));hc(337,540,323,367,reverse:true);wind((367,540),(395,540),core:true,dotted:2);wire(((395,540),(416,540)))
  wire(((323,438),(318,447)));wind((318,447),(304,475),side:-1,core:true,dotted:1)
  wire(((304,475),(304,480),(289,517)));crossline((289,466),(307,495),(301.5,486.15));wire(((307,495),(307,503)));wind((307,503),(321,533),side:-1,core:true,dotted:1);wire(((321,533),(325,540)))
  wire(((270,438),(283,456),(283,468)));wire(((271,540),(283,523),(283,508)))
  wire(((304,480),(332,480)));ds((332,480),(356,438),(341,464))
  wire(((307,495),(331,495)));ds((331,495),(356,540),(342,515))
  for (x,y) in ((270,438),(323,438),(356,438),(271,540),(325,540),(356,540),(304,480),(307,495)) {dot(x,y)}
  fourports(247,416,438,540);lab(304,453,[$L_1$]);lab(299,523,[$L_3$]);lab(383,424,[$L_2$]);lab(383,560,[$L_4$]);lab(271,460,[$S_1$]);lab(271,513,[$S_2$]);lab(327,456,[$C_1$]);lab(327,521,[$C_2$]);lab(359,468,[$D_1$]);lab(359,511,[$D_2$])
  ratio((311,429),(367,419),(328,411),(351,411),(336,412),angle:15deg)
  ratio((311,548),(367,553),(328,563),(351,563),(336,565),angle:-15deg)
  lab(339,595,[Improved QA-SL]);lab(337,624,[(e)])
  // (f) clamp capacitor returns to an actual switch contact, not the crossing.
  wire(((488,443),(537,443)));wind((537,443),(565,443),side:-1,core:true,dotted:1);wire(((565,443),(650,443)));dh(613,443);wind((650,443),(678,443),side:-1,core:true,dotted:1);wire(((678,443),(709,443)))
  wire(((488,538),(536,538)));wind((536,538),(564,538),core:true,dotted:2);wire(((564,538),(650,538)));wind((650,538),(678,538),core:true,dotted:2);wire(((678,538),(709,538)))
  xs((508,443),(589,443),(508,538),(590,538),(551,492))
  cap(636,466,443,484);wire(((557,484),(636,484)))
  for (x,y) in ((508,443),(589,443),(636,443),(557,484),(508,538),(590,538)) {dot(x,y)}
  fourports(488,709,443,538);lab(551,429,[$L_1$]);lab(665,429,[$L_2$]);lab(551,558,[$L_3$]);lab(665,558,[$L_4$]);lab(613,428,[$D_c$]);lab(655,472,[$C_c$])
  ratio((566,426),(645,427),(586,408),(625,408),(608,408))
  ratio((574,555),(645,555),(592,576),(625,576),(610,580))
  lab(601,600,[A-CL with clamp]);lab(603,624,[(f)])
  // (g) coupled-inductor A-SL, small lower diode is deliberately unlabeled.
  wire(((776,445),(822,445)));wind((822,445),(850,445),side:-1,core:true,dotted:1);wire(((850,445),(948,445)));dh(895,445)
  wire(((866,445),(866,406),(881,406)));wind((881,406),(909,406),side:-1,core:true,dotted:1);wire(((909,406),(923,406),(923,445)));dv(866,424)
  wire(((776,537),(875,537)));dh(837,537,left:true);wind((875,537),(903,537),core:true,dotted:2);wire(((903,537),(948,537)))
  wire(((800,537),(800,574),(821,574)));wind((821,574),(849,574),core:true,dotted:2);wire(((849,574),(866,574),(866,537)));dv(866,554,up:false)
  xs((800,445),(923,445),(800,537),(923,537),(862,491))
  for (x,y) in ((800,445),(866,445),(923,445),(800,537),(866,537),(923,537)) {dot(x,y)}
  fourports(776,948,445,537);lab(837,431,[$L_1$]);lab(897,424,[$L_2$]);lab(881,449,[$D_2$]);lab(837,523,[$D_3$]);lab(838,559,[$L_3$]);lab(890,559,[$L_4$])
  ratio((848,428),(873,397),(850,410),(861,400),(849,405),angle:40deg)
  ratio((865,580),(880,563),(876,577),(879,571),(882,580),angle:45deg)
  lab(862,602,[CL-A-SL]);lab(865,624,[(g)])
})
'''
(b/'typ/pdf044-active-switched-inductor-circuits.typ').write_text(base+extra+a,encoding='utf-8')
