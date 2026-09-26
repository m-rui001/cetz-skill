#set page(width:auto,height:auto,margin:10pt)
#import "@preview/cetz:0.4.2":canvas,draw
#set text(font:"Calibri",size:9pt)
#canvas(length:1pt,{
  import draw:*
  let P=(x,y)=>(.5*x,.5*(584 - y))
  let red=rgb("#ff0000")
  let green=rgb("#053a08")
  let orange=rgb("#f4a147")
  let cyan=rgb("#53d4f5")
  let label=(x,y,c,size:9pt,weight:"bold",fill:black)=>content(P(x,y),text(size:size,weight:weight,fill:fill,c))
  let wire=(paint:red,thickness:.9pt)
  let dashed=(thickness:.55pt,dash:(array:(2pt,1.4pt)))
  let arrow=(a,b,color:black,width:.6pt,dash:none,head:8)=>{
    line(P(..a),P(..b),stroke:(paint:color,thickness:width,dash:dash))
    let dx=b.at(0) - a.at(0)
    let dy=b.at(1) - a.at(1)
    let n=calc.sqrt(dx*dx + dy*dy)
    let ux=dx/n
    let uy=dy/n
    let x=b.at(0) - ux*head
    let y=b.at(1) - uy*head
    line(P(..b),P(x - uy*head*.4,y + ux*head*.4),P(x + uy*head*.4,y - ux*head*.4),close:true,fill:color,stroke:none)
  }
  let rr=(x,y,w,h,r,color)=>{
    let pts=()
    for (cx,cy,a) in ((x + w - r,y + r,-90deg),(x + w - r,y + h - r,0deg),(x + r,y + h - r,90deg),(x + r,y + r,180deg)) {
      for i in range(7) {let t=a + i*90deg/6;pts.push(P(cx + r*calc.cos(t),cy + r*calc.sin(t)))}
    }
    line(..pts,close:true,fill:color,stroke:.4pt)
  }
  let laser=(x,y,color)=>{
    rr(x,y,93,41,9,color)
    label(x + 46.5,y + 21,[CW Laser],size:9pt,fill:white)
  }
  let mod=(x,y,w,c)=>{
    rect(P(x,y),P(x + w,y + 44),fill:cyan,stroke:(thickness:.4pt,dash:(array:(.6pt,.7pt))))
    line(P(x + 15,y + 22),P(x + 30,y + 10),P(x + w - 20,y + 10),P(x + w - 6,y + 22),P(x + w - 20,y + 35),P(x + 30,y + 35),close:true,fill:orange,stroke:none)
    label(x + w/2 + 4,y + 22,c,size:9pt)
  }
  let iso=(x,y)=>{
    rect(P(x,y),P(x + 40,y + 13),fill:white,stroke:1pt)
    arrow((x + 6,y + 6.5),(x + 30,y + 6.5),color:red,width:.7pt)
    label(x + 20,y + 27,[Isolator],size:8pt)
  }
  rect(P(49,25),P(548,303),stroke:dashed)
  rect(P(660,25),P(1155,303),stroke:dashed)
  label(96,45,[Alice],size:12pt,fill:red)
  label(704,45,[Bob],size:12pt,fill:red)
  line(P(147,133),P(1049,133),stroke:wire)
  line(P(762,209),P(1049,209),P(1049,133),stroke:wire)
  laser(54,113,red)
  laser(669,189,rgb("#003bd3"))
  mod(159,110,87,[AM])
  rect(P(258,110),P(406,154),fill:cyan,stroke:(thickness:.4pt,dash:(array:(.6pt,.7pt))))
  for (x,l) in ((297,[PM]),(371,[AM])) {
    line(P(x - 35,132),P(x - 22,120),P(x + 22,120),P(x + 35,132),P(x + 22,145),P(x - 22,145),close:true,fill:orange,stroke:none)
    label(x,133,l,size:9pt)
  }
  line(P(332,133),P(336,133),stroke:wire)
  mod(774,186,87,[AM])
  mod(876,186,79,[PM])
  arrow((148,133),(174,133),color:red,width:.9pt)
  arrow((762,209),(790,209),color:red,width:.9pt)
  rect(P(416,116),P(450,150),fill:rgb("#00f400"),stroke:.6pt)
  line(P(416,116),P(450,150),stroke:.5pt)
  label(433,99,[BS],size:9pt)
  rect(P(462,122),P(493,145),fill:black,stroke:none)
  label(478,107,[VOA],size:9pt)
  iso(500,127)
  for dx in (-9,0,9) {circle(P(603 + dx,107),radius:(14,13.5),stroke:(paint:red,thickness:.6pt))}
  label(602,63,[SM Fiber],size:9pt)
  line(P(433,133),P(433,206),P(474,206),stroke:wire)
  let pts=(P(472,192),P(481,192))
  for i in range(17) {let a=-90deg + i*180deg/16;pts.push(P(481 + 12*calc.cos(a),206 + 14*calc.sin(a)))}
  pts.push(P(472,220))
  line(..pts,close:true,fill:rgb("#ffc600"),stroke:.6pt)
  label(512,207,[PD],size:9pt)
  arrow((337,86),(372,86),color:red)
  label(307,86,[Signal],size:9pt)
  arrow((882,111),(919,111),color:red)
  label(852,111,[Signal],size:9pt)
  arrow((882,171),(919,171),color:red)
  label(866,171,[LO],size:9pt)
  for x in (750,774,798) {circle(P(x,123),radius:5.2,stroke:(paint:red,thickness:.6pt));circle(P(x,123),radius:.7,stroke:(paint:red,thickness:.4pt))}
  line(P(725,134),P(819,134),stroke:(paint:red,thickness:2pt))
  label(774,99,[PC],size:9pt)
  for x in (972,980,988) {circle(P(x,199),radius:5.5,stroke:(paint:red,thickness:.6pt))}
  label(978,170,[Delay line],size:9pt)
  iso(1007,203)
  rect(P(1026,53),P(1132,158),fill:cyan,stroke:(thickness:.5pt,dash:(array:(.7pt,.6pt))))
  line(P(1050,71),P(1050,133),P(1113,133),P(1113,71),P(1050,71),stroke:.7pt)
  rect(P(1033,116),P(1067,150),fill:rgb("#00f400"),stroke:.7pt)
  line(P(1033,116),P(1067,150),stroke:.5pt)
  line(P(1049,133),P(1113,133),stroke:wire)
  line(P(1049,209),P(1049,133),stroke:wire)
  label(1075,107,[BS],size:9pt)
  for (x,y,angle) in ((1050,71,-90deg),(1113,133,0deg)) {
    circle(P(x,y),radius:6,fill:rgb("#fbe9d5"),stroke:.6pt)
    let pts=range(3).map(i=>{let a=angle + i*120deg;P(x + 10*calc.cos(a),y + 10*calc.sin(a))})
    line(..pts,close:true,fill:black,stroke:none)
  }
  circle(P(1113,71),radius:5.5,fill:white,stroke:(paint:rgb("#2f4386"),thickness:.8pt))
  line(P(1108,71),P(1118,71),stroke:(paint:rgb("#2f4386"),thickness:.8pt))
  arrow((1119,71),(1150,71),color:rgb("#00296d"))
  label(1101,187,[Homodyne#linebreak()detector],size:9pt)
  let note=(x,y,c,b)=>{
    label(x,y,c,size:9pt)
    let a=(x + 33,y + 5)
    line(P(..a),P(b.at(0),a.at(1)),stroke:(thickness:.65pt,dash:(array:(.8pt,1.2pt))))
    arrow((b.at(0),a.at(1)),b,dash:(array:(.8pt,1.2pt)))
  }
  note(123,276,[Pulse#linebreak()modulation],(202,160))
  label(421,276,[Gaussian#linebreak()modulation],size:9pt)
  line(P(365,277),P(335,277),P(335,161),stroke:(thickness:.65pt,dash:(array:(.8pt,1.2pt))))
  arrow((335,169),(335,160))
  note(741,276,[Pulse#linebreak()modulation],(818,231))
  label(1008,276,[Randomly#linebreak()choose X or P],size:9pt)
  line(P(941,277),P(915,277),P(915,231),stroke:(thickness:.65pt,dash:(array:(.8pt,1.2pt))))
  arrow((915,239),(915,230))
  circle(P(650,133),radius:(3.8,6.5),stroke:(thickness:.6pt,dash:(array:(.8pt,.8pt))))
  arrow((650,147),(604,326),width:.9pt,head:17)

  // Three conceptual timing patterns; these are not measured-data plots.
  for (x1,x2,l) in ((30,378,[(a)]),(431,777,[(b)]),(827,1173,[(c)])) {
    rect(P(x1,340),P(x2,567),stroke:dashed)
    label(x1 + 42,369,l,size:12pt,fill:red)
    arrow((x1 + 11,495),(x2 - 12,495))
  }
  for (x,y) in ((55,404),(90,430),(127,397),(164,411)) {rect(P(x,y),P(x + 18,495),fill:green,stroke:none)}
  for (x,y) in ((201,490),(239,492),(277,489),(315,492)) {rect(P(x,y),P(x + 19,495),fill:red,stroke:none)}
  line(P(184,501),P(184,555),stroke:(thickness:.6pt,dash:(array:(1pt,1pt))))
  label(124,527,[Stabilization#linebreak()pulses],size:9pt)
  label(270,518,[Quantum signals],size:9pt)
  label(307,416,[100 MHz#linebreak()Rep. rate],size:9pt)
  for x in (286,326) {line(P(x,441),P(x,491),stroke:(thickness:.6pt,dash:(array:(1pt,1pt))))}
  arrow((250,452),(286,452))
  arrow((361,452),(326,452))
  for (x,y) in ((454,405),(527,398),(601,411),(677,377),(850,404),(958,357),(1034,445),(1073,404)) {rect(P(x,y),P(x + 18,495),fill:green,stroke:none)}
  for (x,y) in ((489,488),(562,492),(638,492),(714,492),(885,489),(923,485),(996,490),(1111,492)) {rect(P(x,y),P(x + 19,495),fill:red,stroke:none)}
  // The c-panel has a taller red pulse at its second quantum-signal position.
  rect(P(923,486),P(942,495),fill:red,stroke:none)
  label(589,363,[Stabilization pulses],size:9pt)
  label(1081,363,[Stabilization pulses],size:9pt)
  label(607,539,[Quantum signals],size:9pt)
  label(1004,539,[Quantum signals],size:9pt)
  for (a,b) in (((505,378),(480,400)),((563,378),(546,392)),((600,378),(609,405)),((646,378),(673,398)),((1025,378),(985,405)),((1047,385),(1042,439)),((1073,378),(1085,400)),((520,526),(508,506)),((566,526),(572,505)),((639,526),(647,506)),((677,526),(720,505)),((940,526),(914,505)),((980,526),(949,505)),((1000,526),(1008,505)),((1080,526),(1117,505))) {arrow(a,b,width:.4pt)}
})
