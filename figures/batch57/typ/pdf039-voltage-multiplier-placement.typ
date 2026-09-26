#set page(width:auto,height:auto,margin:2pt)
#set text(font:"Times New Roman",size:9.5pt)
#import "@preview/cetz:0.4.2":canvas,draw
#canvas(length:1pt,{
  import draw:*
  let s=.62
  let P=(x,y)=>(s*(x - 116),s*(588 - y))
  let wire=(pts)=>line(..pts.map(p=>P(..p)),stroke:.85pt)
  let lab=(x,y,c)=>content(P(x,y),c)
  let dot=(x,y)=>circle(P(x,y),radius:1.15,fill:black,stroke:none)
  let port=(x,y)=>circle(P(x,y),radius:1.3,fill:white,stroke:.85pt)
  let box=(x,y)=>{
    rect(P(x,y),P(x + 85,y + 73),fill:rgb("#dceef1"),stroke:.9pt)
    content(P(x + 42.5,y + 36.5),text(size:17pt,[VMR]))
  }
  let signal=(x,y)=>{
    rect(P(x - 9,y - 15),P(x + 8,y + 15),radius:5*s,fill:rgb("#e2dbe8"),stroke:none)
    // Sine and square-wave symbols indicate the kinds of input; no data curve.
    bezier(P(x - 7,y - 7),P(x,y - 7),P(x - 8,y - 14),P(x,y - 14),stroke:.85pt)
    bezier(P(x,y - 7),P(x + 6,y - 7),P(x,y),P(x + 7,y),stroke:.85pt)
    wire(((x - 6,y + 1),(x - 6,y + 10),(x,y + 10),(x,y + 4),(x + 6,y + 4)))
  }

  // (a) pulsed DC input, magnetic element, multiplier rectifier.
  box(211,488)
  wire(((147,502),(166,502)))
  for i in range(4) {bezier(P(166 + i*7.5,502),P(173.5 + i*7.5,502),P(166 + i*7.5,496),P(173.5 + i*7.5,496),stroke:.85pt)}
  wire(((196,502),(211,502)));wire(((147,550),(211,550)))
  for y in (491,495) {wire(((166,y),(196,y)))}
  dot(161,497)
  wire(((296,502),(318,502)));wire(((296,550),(318,550)))
  for (x,y) in ((147,502),(147,550),(318,502),(318,550)) {port(x,y)}
  signal(151,526);lab(128,526,[$V_"in"$]);lab(319,526,[$V_"out"$]);lab(253,578,[(a)])
  // (b) AC input with an isolated transformer ahead of the rectifier.
  box(429,489)
  wire(((362,500),(384,500)));wire(((362,553),(384,553)))
  wire(((406,500),(429,500)));wire(((406,553),(429,553)))
  for (x,dir) in ((384,1),(406,-1)) {
    for i in range(4) {bezier(P(x,507 + i*10),P(x,507 + (i + 1)*10),P(x + 7*dir,507 + i*10),P(x + 7*dir,507 + (i + 1)*10),stroke:.85pt)}
    wire(((x,500),(x,507)));wire(((x,547),(x,553)))
  }
  for x in (395,399) {wire(((x,506),(x,547)))}
  wire(((514,500),(535,500)));wire(((514,553),(535,553)))
  for (x,y) in ((362,500),(362,553),(535,500),(535,553)) {port(x,y)}
  signal(369,526);lab(348,526,[$V_"in"$]);lab(537,526,[$V_"out"$]);lab(460,578,[(b)])
})
