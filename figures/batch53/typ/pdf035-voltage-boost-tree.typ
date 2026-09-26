#set page(width:auto,height:auto,margin:2pt)
#set text(font:"Times New Roman",size:6.55pt,weight:"bold")
#set par(leading:3.4pt)
#import "@preview/cetz:0.4.2":canvas,draw
#canvas(length:1pt,{
  import draw:*
  let s=.46
  let P=(x,y)=>(s*(x - 106),s*(463 - y))
  let wire=(pts)=>line(..pts.map(p=>P(..p)),stroke:.85pt)
  let edge=(px,py,x,y,bus)=>{
    if px==x {wire(((px,py),(x,y)))} else {
      let sign=if x > px {1} else {-1}
      wire(((px,py),(px,bus - 7)))
      bezier(P(px,bus - 7),P(px + sign*7,bus),P(px,bus),P(px,bus),stroke:.85pt)
      wire(((px + sign*7,bus),(x - sign*7,bus)))
      bezier(P(x - sign*7,bus),P(x,bus + 7),P(x,bus),P(x,bus),stroke:.85pt)
      wire(((x,bus + 7),(x,y)))
    }
  }
  let box=(x,y,w,h,c,words)=>{
    rect(P(x,y),P(x + w,y + h),radius:6*s,fill:rgb(c),stroke:none)
    content(P(x + w/2,y + h/2),align(center,words))
  }
  for x in (174.5,298,420.5,544.5,856) {edge(544.5,187,x,230,209)}
  for x in (227,357.5) {edge(298,283,x,316,300)}
  for x in (475,610.5) {edge(544.5,283,x,320,300)}
  for x in (758,856,956.5) {edge(856,283,x,320,303)}
  for x in (313,400) {edge(357.5,359,x,421,388)}
  for x in (440,508.5) {edge(475,355,x,380,369)}
  for x in (552.5,669) {edge(610.5,355,x,421,387)}
  for x in (717.5,798.5) {edge(758,355,x,380,369)}
  for x in (889.5,1023.5) {edge(956.5,355,x,421,388)}
  box(486.5,134,116,53,"#e8b6b2",[Voltage Boost\ Technique])
  let green="#bfe3b7"
  box(106,230,137,53,green,[Switched Capacitor\ (Charge Pump)])
  box(261,230,74,53,green,[Voltage\ Multiplier])
  box(359,230,123,53,green,[Switched Inductor\ and Voltage Lift])
  box(505,230,79,53,green,[Magnetic\ Coupling])
  box(789,230,134,53,green,[Multi-Stage / -Level])
  let yellow="#ffffa8"
  box(169,316,116,43,yellow,[Voltage Multiplier\ Cell])
  box(299,316,117,43,yellow,[Voltage Multiplier\ Rectifier])
  box(427,320,96,35,yellow,[Transformer])
  box(552,320,117,35,yellow,[Coupled Inductor])
  box(714,320,88,35,yellow,[Cascaded])
  box(812,320,88,35,yellow,[Interleaved])
  box(912,320,89,35,yellow,[Multilevel])
  let blue="#bde3ed"
  box(410,380,60,32,blue,[Isolated])
  box(478,380,61,32,blue,[Built-in])
  box(682.5,380,70,32,blue,[Quadratic])
  box(768,380,61,32,blue,[Hybrid])
  box(274,421,78,32,blue,[Half-Wave])
  box(361,421,78,32,blue,[Full-Wave])
  box(491,421,123,42,blue,[Tapped Inductor /\ Autotransformer])
  box(619,421,100,42,blue,[Magnetically\ Coupled Based])
  box(831,421,117,42,blue,[Modular\ (Single DC source)])
  box(956.5,421,134,42,blue,[Cascaded\ (Multiple DC Source)])
})
