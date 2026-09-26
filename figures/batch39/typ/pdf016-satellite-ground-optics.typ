#set page(width:auto,height:auto,margin:10pt)
#import "@preview/cetz:0.4.2":canvas,draw
#set text(font:"Cambria",size:25pt)
#canvas(length:1pt,{
  import draw:*
  let P=(x,y)=>(.6*x,.6*(681 - y))
  let dark=rgb("#344e36")
  let light=rgb("#7ec04e")
  let arrow=(a,b,c,width:3pt,head:25)=>{
    line(P(..a),P(..b),stroke:(paint:c,thickness:width))
    let dx=b.at(0) - a.at(0)
    let dy=b.at(1) - a.at(1)
    let n=calc.sqrt(dx*dx + dy*dy)
    let ux=dx/n
    let uy=dy/n
    let x=b.at(0) - head*ux
    let y=b.at(1) - head*uy
    line(P(..b),P(x - uy*head*.36,y + ux*head*.36),P(x + uy*head*.36,y - ux*head*.36),close:true,fill:c,stroke:none)
  }
  let double=(a,b)=>{
    line(P(..a),P(..b),stroke:.9pt)
    arrow(b,a,black,width:.9pt,head:22)
    arrow(a,b,black,width:.9pt,head:22)
  }
  let label=(x,y,c,size:25pt)=>content(P(x,y),text(size:size,c))
  rect(P(0,0),P(877,681),stroke:.8pt)
  // Pulses propagate in opposite directions on the shared horizontal path.
  line(P(270,298),P(859,298),stroke:(paint:dark,thickness:5pt))
  for x in (350,524,786) {arrow((x - 37,298),(x,298),dark,width:5pt,head:31)}
  line(P(397,273),P(846,273),stroke:(paint:light,thickness:4.5pt))
  for x in (516,722) {arrow((x + 38,273),(x,273),light,width:4.5pt,head:30)}
  line(P(397,110),P(397,273),stroke:(paint:light,thickness:4.5pt))
  arrow((397,202),(397,161),light,width:4.5pt,head:30)
  line(P(647,110),P(647,273),stroke:(paint:light,thickness:4.5pt))
  arrow((647,199),(647,156),light,width:4.5pt,head:30)
  line(P(670,110),P(670,298),stroke:(paint:dark,thickness:5pt))
  arrow((670,182),(670,230),dark,width:5pt,head:30)
  for x in (368,619) {
    rect(P(x,248),P(x + 80,328),fill:rgb("#bfe8f5").transparentize(30%),stroke:(paint:rgb("#91c6e0"),thickness:1.9pt))
    line(P(x,248),P(x + 80,328),stroke:(paint:rgb("#89c1dd"),thickness:3.5pt))
  }
  rect(P(114,42),P(444,110),fill:white,stroke:(paint:rgb("#999999"),thickness:1.7pt))
  rect(P(518,42),P(845,110),fill:white,stroke:(paint:rgb("#999999"),thickness:1.7pt))
  label(279,76,[Qubit Analyzer],size:28pt)
  label(682,76,[Laser Ranging],size:28pt)
  let pts=()
  for (x,y,a) in ((250,286,-90deg),(250,306,0deg),(34,306,90deg),(34,286,180deg)) {
    for i in range(9) {let t=a + i*90deg/8;pts.push(P(x + 24*calc.cos(t),y + 24*calc.sin(t)))}
  }
  line(..pts,close:true,fill:white,stroke:(paint:rgb("#999999"),thickness:1.7pt))
  label(143,296,[Qubit Laser],size:28pt)
  rect(P(59,372),P(835,622),stroke:.7pt)
  let pulse=(c,h,w,color)=>{
    let pts=(P(c - 26,620),)
    for i in range(105) {
      let x=c - 26 + .5*i
      let y=620 - h*calc.exp(-calc.pow((x - c)/w,2))
      pts.push(P(x,y))
    }
    pts.push(P(c + 26,620))
    line(..pts,close:true,fill:color,stroke:(paint:rgb("#aaaaaa"),thickness:.7pt))
  }
  for x in (106,726) {
    pulse(x,245,4.1,rgb("#b9b9b9"))
    pulse(x,215,4.6,rgb("#55549e"))
  }
  for x in (313,390,469,547) {pulse(x,53,6.6,rgb("#b25540"))}
  for x in (183,229,268,595,642,685) {circle(P(x,596),radius:3.7,fill:rgb("#7b8e72"),stroke:none)}
  double((151,398),(692,398))
  label(431,436,[100 ms],size:29pt)
  // Short timing arrow uses smaller heads than the pulse-train separation.
  arrow((396,562),(462,562),black,width:.65pt,head:10)
  arrow((462,562),(396,562),black,width:.65pt,head:10)
  label(431,534,[10 ns],size:28pt)
  label(116,653,[SLR Pulse],size:29pt)
  label(434,653,[Qubits],size:29pt)
  label(719,653,[SLR Pulse],size:29pt)
})
