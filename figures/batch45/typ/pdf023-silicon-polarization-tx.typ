#set page(width:auto,height:auto,margin:2pt)
#import "@preview/cetz:0.4.2":canvas,draw
#set text(font:"Arial",size:9pt)
#set par(leading:0pt)
#canvas(length:1pt,{
  import draw:*
  let s=1.5
  let P=(x,y)=>(s*x,s*(176 - y))
  let poly=(pts,c)=>line(..pts.map(p=>P(..p)),close:true,fill:rgb(c),stroke:none)
  let wave=(pts,t:1.1,c:"#f4f3ef")=>line(..pts.map(p=>P(..p)),stroke:(paint:rgb(c),thickness:s*t*1pt))
  let curve=(a,b,c,d,t:1.1,color:"#f4f3ef")=>bezier(P(..a),P(..b),P(..c),P(..d),stroke:(paint:rgb(color),thickness:s*t*1pt))
  let label=(x,y,c,size:7,fill:white)=>content(P(x,y),text(size:s*size*1pt,fill:fill,c))
  let box=(x,y,w,h,c)=>rect(P(x,y),P(x + w,y + h),fill:rgb(c),stroke:none)
  let heater=(x,y,w,h)=>{
    box(x,y,w,h,"#b1a057")
    box(x + 1,y + .8,w - 2,h - 1.6,"#e6c24c")
  }
  let mz=(x1,x2,y,r:4)=>{
    curve((x1,y),(x1 + 12,y - r),(x1 + 5,y),(x1 + 5,y - r))
    wave(((x1 + 12,y - r),(x2 - 12,y - r)))
    curve((x2 - 12,y - r),(x2,y),(x2 - 5,y - r),(x2 - 5,y))
    curve((x1,y),(x1 + 12,y + r),(x1 + 5,y),(x1 + 5,y + r))
    wave(((x1 + 12,y + r),(x2 - 12,y + r)))
    curve((x2 - 12,y + r),(x2,y),(x2 - 5,y + r),(x2 - 5,y))
  }

  poly(((35,1),(365,1),(396,140),(2,147)),"#808181")
  poly(((2,147),(396,140),(399,148),(1,150)),"#656666")
  // Folded input bus and eight-stage attenuator routing.
  wave(((14,88),(180,88),(186,86),(259,86),(263,101),(240,101)))
  wave(((9,114),(179,114),(181,91),(196,88),(207,88)))
  wave(((193,101),(190,113),(211,113)))
  wave(((241,113),(262,113),(264,125),(243,125)))
  wave(((211,125),(188,125),(186,137),(270,137),(266,59),(37,59),(35,58),(39,24),(48,23)))
  wave(((35,25),(29,60),(53,60),(56,62),(54,66),(18,66)))
  // Colored silicon and doping layers of two racetrack ring modulators.
  for x in (49,112) {
    rect(P(x,83),P(x + 59,108),radius:6*s,fill:rgb("#cd6e77"),stroke:none)
    rect(P(x + 4,87),P(x + 56,107),radius:5*s,fill:rgb("#278ec4"),stroke:none)
    rect(P(x + 8,88),P(x + 55,103),radius:4*s,fill:rgb("#ebcb45"),stroke:none)
    rect(P(x + 11,89),P(x + 49,99),radius:3*s,fill:rgb("#7b8081"),stroke:none)
    box(x + 26,85,14,9,"#e9bc3d")
    box(x + 27,88,13,2,"#f4e094")
    curve((x + 6,88),(x + 25,89),(x + 15,85),(x + 15,89),t:.8)
    curve((x + 25,89),(x + 48,90),(x + 34,97),(x + 35,85),t:.8)
    wave(((x + 48,90),(x + 49,98),(x + 10,98)),t:.8)
    curve((x + 10,98),(x + 6,88),(x + 2,98),(x + 3,89),t:.8)
  }
  // Serpentine VOA, eight independently visible heater strips.
  for i in range(8) {
    let y=84 + i*6.2
    wave(((195,y + 3),(204,y + 3),(208,y + 1),(239,y + 1),(244,y + 3),(251,y + 3)),t:.9)
    heater(209,y,31,4.5)
    if calc.rem(i,2)==0 {curve((251,y + 3),(251,y + 9.2),(258,y + 3),(258,y + 9.2),t:.9)}
    else {curve((195,y + 3),(195,y + 9.2),(189,y + 3),(189,y + 9.2),t:.9)}
  }
  // Polarization modulation bank and the output folded arms.
  wave(((39,23),(58,23)),t:1)
  for (x,w) in ((58,110),(178,31),(225,30)) {
    box(x - 1,18,w + 2,11,"#698eb7")
    heater(x,19,w,3.5)
    heater(x,24,w,3.5)
    wave(((x + w,22),(x + w + 9,22)),t:.9)
  }
  wave(((255,22),(258,22),(258,8),(265,8),(265,18),(285,18),(330,18),(330,20),(287,20),(287,24),(336,24),(367,23)),t:1)
  wave(((255,25),(258,25),(258,36),(265,36),(265,28),(338,28)),t:1)
  label(166,10,[Polarization Modulator],size:8.8)
  label(119,75,[Ring Modulators],size:8.8)
  label(225,76,[VOA],size:9)
  label(29,96,[Input],size:9)
  label(356,29,[Output],size:8.6)
  for (y,c,t) in ((58,"#ffffff",[220nm Si]),(70,"#cf5368",[90nm Si]),(82,"#edc24a",[N Doping]),(94,"#148bc3",[P Doping])) {
    box(289,y - 2.5,5,5,c)
    content(P(300,y),text(size:s*8.9pt,fill:white,t),anchor:"west")
  }
  label(206,164,[(a)],size:13,fill:black)

})
