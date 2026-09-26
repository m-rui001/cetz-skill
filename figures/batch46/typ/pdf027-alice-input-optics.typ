#set page(width:auto,height:auto,margin:2pt)
#import "@preview/cetz:0.4.2":canvas,draw
#set text(font:"Arial",size:8pt)
#set par(leading:0pt)
#canvas(length:1pt,{
  import draw:*
  let s=2.5
  let P=(x,y)=>(s*x,s*(49 - y))
  let wire=(pts,c,t:1.1)=>line(..pts.map(p=>P(..p)),stroke:(paint:rgb(c),thickness:s*t*1pt))
  // Flat chain only: the adjoining perspective chip is excluded.
  wire(((31,30),(45,30)),"#becd08",t:2)
  wire(((109,30),(155,30)),"#597c9d",t:2.7)
  wire(((109,30),(155,30)),"#a9bed5",t:1)
  bezier(P(155,30),P(167,22),P(161,30),P(160,22),stroke:(paint:rgb("#becd08"),thickness:2.7pt))
  for x in (123,136,149) {
    circle(P(x,24),radius:3.9*s,fill:rgb("#91a8c7"),stroke:(paint:rgb("#547595"),thickness:.8pt))
    circle(P(x,24),radius:2.7*s,stroke:(paint:rgb("#bccbdc"),thickness:.45pt))
  }
  for (x,w,c) in ((4,29,[Laser]),(45,64,[Intensity Mod.])) {
    rect(P(x,23),P(x + w,37),fill:rgb("#ae5c71"),stroke:(paint:rgb("#724556"),thickness:.55pt))
    content(P(x + w/2,30),text(size:s*6pt,fill:white,c))
  }
  content(P(132,9),text(size:s*5.9pt,[Polarization]))
  content(P(132,16),text(size:s*5.9pt,[controller]))
})
