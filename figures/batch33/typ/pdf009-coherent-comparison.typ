#set page(width: auto, height: auto, margin: 12pt)
#import "@preview/cetz:0.4.2": canvas, draw
#set text(font: "Calibri", size: 11pt)

// Fig.20: two coherent inputs pass through the coupled Bob/Charlie network.
#canvas(length: 1pt, {
  import draw: *
  let k = 1.28
  let P = (x,y) => (k*(x - 83),k*(478 - y))
  let thin = (thickness:.7pt)
  let ar = (a,b) => {
    line(P(..a),P(..b),stroke:thin)
    let dx = b.at(0) - a.at(0)
    let dy = b.at(1) - a.at(1)
    let n = calc.sqrt(dx*dx + dy*dy)
    let ux = dx/n
    let uy = dy/n
    let x = b.at(0) - 2.7*ux
    let y = b.at(1) - 2.7*uy
    line(P(x - 1.1*uy,y + 1.1*ux),P(..b),P(x + 1.1*uy,y - 1.1*ux),stroke:thin)
  }
  let BL = (117.3,338.9)
  let BR = (219.8,338.9)
  let CL = (117.3,423.1)
  let CR = (219.8,423.1)
  let M = (166.5,296.9)
  let N = (166.5,465.8)
  let dashed = (thickness:.55pt,dash:(array:(2.1pt,.75pt)))
  rect(P(104.1,290.9),P(257.5,374.9),stroke:dashed)
  rect(P(104.1,387.3),P(257.5,471.1),stroke:dashed)
  ar((97.2,358.3),BL)
  ar(BL,M)
  ar(M,BR)
  ar(BL,CR)
  ar((97.2,404.9),CL)
  ar(CL,BR)
  ar(CL,N)
  ar(N,CR)
  ar(BR,(235.4,326.6))
  ar(BR,(235.9,351.8))
  ar(CR,(235.4,410.4))
  ar(CR,(235.9,435.4))

  for node in (BL,BR,CL,CR) {
    line(P(node.at(0) - 9.5,node.at(1)),P(node.at(0) + 9.5,node.at(1)),stroke:2.8pt)
  }
  let mirror = (y,top) => {
    line(P(141.2,y),P(192.0,y),stroke:.75pt)
    for i in range(19) {
      let x = 141.2 + 50.8*i/18
      line(P(x,y),P(x+(if top {1.5} else {-1.5}),y+(if top {-2.7} else {2.7})),stroke:.55pt)
    }
  }
  mirror(296.9,true)
  mirror(465.8,false)
  content(P(254.4,297.0),[#text(weight:"bold")[Bob]],anchor:"east")
  content(P(254.4,464.8),[#text(weight:"bold")[Charlie]],anchor:"east")

  content(P(92.0,363.0),[#text(font:"Cambria Math",size:9.2pt)[$lr(|alpha ⟩)$]])
  content(P(92.0,370.0),[#text(size:6.4pt)[Input]])
  content(P(92.0,376.0),[#text(size:6.4pt)[Bob]])
  content(P(92.0,388.0),[#text(size:6.4pt)[Input]])
  content(P(92.0,394.0),[#text(size:6.4pt)[Charlie]])
  content(P(92.0,401.5),[#text(font:"Cambria Math",size:9.2pt)[$lr(|beta ⟩)$]])

  let state = (y,plus) => content(P(246.0,y),[#text(font:"Cambria Math",size:9.4pt)[#(if plus {[$lr(|(alpha+beta)/2 ⟩)$]} else {[$lr(|(alpha-beta)/2 ⟩)$]})]])
  state(319.0,true)
  state(358.5,false)
  state(404.0,false)
  state(443.0,true)
  for (y,label) in ((330,[Signal]),(348,[Null-port]),(415.4,[Null-port]),(433.6,[Signal])) {
    content(P(245,y),[#text(size:6.4pt)[#label]])
  }
})
