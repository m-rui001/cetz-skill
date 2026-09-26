#set page(width: auto, height: auto, margin: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw
#set text(font: "Calibri", size: 12pt)
#let turn-text = rotate
#canvas(length: 1pt, {
  import draw: *
  let P = (x,y) => (.6*x,.6*(212 - y))
  let cyan = rgb("#98dfec")
  let red = rgb("#ff0000")
  let node = (x,y,color) => circle(P(x,y),radius:(7.5,4.8),fill:color,stroke:none)
  let dash = (thickness:.8pt,dash:(array:(3pt,2.5pt)))
  let horizontal = (a,b,y) => {
    line(P(a,y),P(b,y),stroke:dash)
    line(P(a,y),P(a + 9,y - 4),P(a + 9,y + 4),close:true,fill:black,stroke:none)
    line(P(b,y),P(b - 9,y - 4),P(b - 9,y + 4),close:true,fill:black,stroke:none)
  }
  horizontal(102,962,32)
  content(P(537,16),text(font:"Cambria Math",size:18pt,$L = 2^n L_0$))
  for x in (101,192,216,308,331,422,449,540,844,872,964) {
    for y in (54,88,158,192) { node(x,y,cyan) }
  }
  for x in (101,540,844,872,964) { line(P(x,102),P(x,141),stroke:dash) }
  line(P(619,119),P(714,119),stroke:dash)
  horizontal(882,964,133)
  content(P(926,113),text(font:"Cambria Math",size:18pt,$L_0$))
  // Native sampled helix; its centreline joins the red memory sites.
  let entangled = (a,b,loops) => {
    let dx = b.at(0) - a.at(0)
    let dy = b.at(1) - a.at(1)
    let n = calc.sqrt(dx*dx + dy*dy)
    let ux = dx/n
    let uy = dy/n
    let pts = range(loops*32 + 1).map(i => {
      let t = i/(loops*32)
      let theta = t*loops*360deg
      let along = t*n + 6.5*calc.sin(theta)
      let across = 5*calc.cos(theta)
      P(a.at(0) + along*ux - across*uy,a.at(1) + along*uy + across*ux)
    })
    line(..pts,stroke:(paint:rgb("#ff3333"),thickness:1.7pt))
  }
  entangled((105,159),(192,159),6)
  entangled((216,88),(307,88),6)
  entangled((106,194),(309,158),14)
  entangled((333,88),(540,157),15)
  for (x,y) in ((104,159),(104,194),(193,159),(216,88),(307,88),(331,88),(309,157),(540,157)) { node(x,y,red) }
  content(P(149,143),text(weight:"bold",size:12pt,[entangled]))
  content(P(264,72),text(weight:"bold",size:12pt,[entangled]))
  for (a,b,x,y) in (((195,144),(216,100),199,118),((312,144),(329,100),314,117)) {
    line(P(..a),P(..b),stroke:1pt)
    let dx = b.at(0) - a.at(0)
    let dy = b.at(1) - a.at(1)
    let n = calc.sqrt(dx*dx + dy*dy)
    let ux = dx/n
    let uy = dy/n
    for (p,d) in ((a,1),(b,-1)) {
      let bx = p.at(0) + d*ux*10
      let by = p.at(1) + d*uy*10
      line(P(..p),P(bx - uy*4,by + ux*4),P(bx + uy*4,by - ux*4),close:true,fill:black,stroke:none)
    }
    content(P(x - 8,y),turn-text(-66deg,text(fill:red,size:13pt,[BSM])))
  }
  rect(P(88,39),P(117,211),stroke:1pt)
  // Brace surrounds the first bank of memories.
  bezier(P(87,46),P(77,65),P(77,46),P(77,53),stroke:1.2pt)
  bezier(P(77,65),P(68,123),P(77,117),P(77,122),stroke:1.2pt)
  bezier(P(68,123),P(77,181),P(77,124),P(77,131),stroke:1.2pt)
  bezier(P(77,181),P(87,201),P(77,192),P(77,201),stroke:1.2pt)
  content(P(35,125),turn-text(-90deg,text(weight:"bold",size:13pt,[Quantum#linebreak()memories])))
})
