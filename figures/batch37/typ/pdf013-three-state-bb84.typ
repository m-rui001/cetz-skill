#set page(width:auto,height:auto,margin:10pt)
#import "@preview/cetz:0.4.2":canvas,draw
#set text(font:"Calibri",size:13pt)
#canvas(length:1pt,{
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
