#set page(width:auto,height:auto,margin:2pt)
#import "@preview/cetz:0.4.2":canvas,draw
#set text(font:"Arial",size:8pt)
#set par(leading:0pt)
#canvas(length:1pt,{
  import draw:*
  let s=3.6
  let P=(x,y)=>(s*x,s*(92 - y))
  let label=(x,y,c,size:6.2)=>content(P(x,y),text(size:s*size*1pt,c))
  // Conceptual Poincare-sphere control paths, not measured data.
  rect(P(.8,2),P(100,88),stroke:(paint:rgb("#777777"),thickness:1.4pt,dash:"dotted"),fill:none)
  circle(P(48,45),radius:(27*s,29*s),fill:rgb("#f8f8f8"),stroke:(paint:rgb("#d7d7d7"),thickness:.6pt))
  // Faint latitude and longitude curves behind the labeled modulation arcs.
  for y in (25,34,43,52,61,68) {
    let r=26*calc.sqrt(1 - calc.pow((y - 45)/30,2))
    circle(P(48,y),radius:(r*s,3.6*s),stroke:(paint:rgb("#e8e4e3"),thickness:.45pt))
  }
  for (dx,c) in ((-7,"#dfeadf"),(-2,"#d8e8e7"),(5,"#e8dce5"),(10,"#eee4d6")) {
    bezier(P(49 + dx/3,18),P(47 + dx/3,74),P(28 + dx,29),P(30 + dx,65),stroke:(paint:rgb(c),thickness:1.4pt))
    bezier(P(49 + dx/3,18),P(47 + dx/3,74),P(70 + dx/3,28),P(70 + dx/3,63),stroke:(paint:rgb(c),thickness:.9pt))
  }
  bezier(P(23,45),P(74,47),P(22,61),P(68,65),stroke:(paint:rgb("#4f7485"),thickness:2.7pt))
  bezier(P(49,19),P(45,74),P(33,41),P(36,73),stroke:(paint:rgb("#4f7d88"),thickness:2.6pt))
  // Two modulation directions along the surface.
  line(P(27,52),P(24,47),P(24,54),close:true,fill:rgb("#4f7485"),stroke:none)
  line(P(48,22),P(51,18),P(46,19),close:true,fill:rgb("#4f7d88"),stroke:none)
  label(10,12,[(d)],size:10)
  label(59,12,[$lr(|0⟩)$ CDM0],size:5.8)
  label(13,46,[$lr(|+⟩)$],size:6.8)
  label(10,56,[CDM2],size:5.8)
  line(P(38,67),P(35.7,62.7),P(40.5,62.5),close:true,fill:rgb("#4f7d88"),stroke:none)
  label(88,42,[CDM3],size:5.8)
  label(84,49,[$lr(|-⟩)$],size:6.8)
  label(42,79,[CDM1 $lr(|1⟩)$],size:6.2)
})
