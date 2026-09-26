#set page(width: auto, height: auto, margin: 12pt)
#import "@preview/cetz:0.4.2": canvas, draw
#set text(font: "Calibri", size: 11pt)

// Fig.14: original transmission, its simulation, then the collapsed block.
#canvas(length: 1pt, {
  import draw: *
  let k = 1.2
  let P = (x, y) => (k*(x - 58), k*(151 - y))
  let light = rgb("dce6f2")
  let blue = rgb("95b3d7")
  let redline = rgb("c00000")
  let green = rgb("00b050")
  let braces = rgb("4a7ebb")
  let rr = (x0, y0, x1, y1, r, paint) => {
    let points = ()
    for c in ((x1 - r, y0 + r, -90deg), (x1 - r, y1 - r, 0deg), (x0 + r, y1 - r, 90deg), (x0 + r, y0 + r, 180deg)) {
      for j in range(7) {
        let a = c.at(2) + 90deg*j/6
        points.push(P(c.at(0)+r*calc.cos(a),c.at(1)+r*calc.sin(a)))
      }
    }
    line(..points, path: true, close: true, fill: paint, stroke: none)
  }
  let frame = (start, finish, bx, label) => {
    line(P(start,61.4),P(finish,61.4),stroke:5.4pt)
    line(P(start,139.0),P(finish,139.0),stroke:5.4pt)
    rr(bx,55.9,bx+17.6,145.0,2.7,light)
    content(P(bx+8.8,101), [#text(font:"Cambria Math",size:13.2pt)[#label]])
    for (x,y,t) in ((start - 6,61.4,[a]),(start - 6,139,[b]),(finish + 6,61.4,[a]),(finish + 6,139,[b])) {
      content(P(x,y),[#text(weight:"bold")[#t]])
    }
  }
  let brace = (x, left, before) => {
    let s = if left {1} else {-1}
    bezier(P(x,57.5),P(x - 6*s,64.7),P(x - 6*s,57.5),P(x - 6*s,59.5),stroke:(paint:braces,thickness:.5pt))
    line(P(x - 6*s,64.7),P(x - 6*s,94.2),stroke:(paint:braces,thickness:.5pt))
    bezier(P(x - 6*s,94.2),P(x - 12*s,100.0),P(x - 6*s,98.4),P(x - 9*s,100.0),stroke:(paint:braces,thickness:.5pt))
    bezier(P(x - 12*s,100.0),P(x - 6*s,106.0),P(x - 9*s,100.0),P(x - 6*s,102),stroke:(paint:braces,thickness:.5pt))
    line(P(x - 6*s,106.0),P(x - 6*s,137.0),stroke:(paint:braces,thickness:.5pt))
    bezier(P(x - 6*s,137.0),P(x,144.2),P(x - 6*s,142),P(x - 6*s,144.2),stroke:(paint:braces,thickness:.5pt))
    content(P(x - 22*s,100.0), [#text(font:"Cambria Math",size:11pt)[#(if before {[$rho_(bold(upright(a b)))^(i - 1)$]} else {[$rho_(bold(upright(a b)))^i$]})]])
  }
  frame(99,207.3,183.2,[$Lambda_i$])
  frame(274.5,382.5,359.2,[$Lambda_i$])
  frame(450.2,507,483.2,[$Delta_i$])
  content(P(63,54),[(a)])
  content(P(252,54),[(b)])
  content(P(412,54),[(c)])
  brace(91,true,true)
  brace(213,false,false)
  brace(440,true,true)
  brace(516,false,false)

  let channel = (x, ytop, ybottom, finish) => {
    circle(P(x,ytop),radius:1.6,fill:redline,stroke:none)
    line(P(x,ytop),P(x+42.5,ytop),P(x+42.5,91),path:true,stroke:(paint:redline,thickness:1pt))
    line(P(x+42.5,108),P(x+42.5,ybottom),P(finish,ybottom),path:true,stroke:(paint:redline,thickness:1pt))
    line(P(finish - 3,ybottom - 1.5),P(finish,ybottom),P(finish - 3,ybottom + 1.5),stroke:(paint:redline,thickness:1pt))
    content(P(x+42.5,100),[#text(font:"Cambria Math",size:12.7pt)[$bold(cal(E))$]])
    content(P(x+10,77.0),[#text(size:10pt)[a#sub[i]]])
    content(P(finish - 12,ybottom - 5.0),[#text(size:10pt)[b#sub[i]]])
  }
  channel(99.2,71.8,128.2,183.2)

  // The resource curve and the classical communication arrow are local to (b).
  rect(P(305.7,66.5),P(328.7,133.2),fill:blue,stroke:none)
  circle(P(275.0,71.8),radius:1.6,fill:redline,stroke:none)
  line(P(275,71.8),P(317.2,71.8),stroke:(paint:redline,thickness:1pt))
  line(P(316.4,128.0),P(359.2,128),stroke:(paint:redline,thickness:1pt))
  line(P(356.2,126.5),P(359.2,128),P(356.2,129.5),stroke:(paint:redline,thickness:1pt))
  bezier(P(311,74.8),P(292.2,86),P(300,76),P(292.2,79),stroke:(paint:green,thickness:1.4pt))
  line(P(292.2,86),P(292.2,113),stroke:(paint:green,thickness:1.4pt))
  bezier(P(292.2,113),P(311,128.8),P(292.2,122),P(303,127.5),stroke:(paint:green,thickness:1.4pt))
  line(P(317,123),P(317,77),stroke:(thickness:.4pt,dash:(array:(1.7pt,1.5pt))))
  line(P(317,77),P(316.6,78),P(317.4,78),close:true,fill:black,stroke:none)
  rr(310,67.5,324.2,77.5,1.5,light)
  rr(309.2,122.0,323.4,132.0,1.5,light)
  content(P(317.1,72.5),[#text(size:6.1pt,weight:"bold")[LO]])
  content(P(316.3,127.0),[#text(size:6.1pt,weight:"bold")[LO]])
  content(P(319.2,101),[#text(size:6.6pt)[CC]],anchor:"west")
  content(P(283,101),[#text(font:"Cambria Math",size:14.5pt)[$sigma$]])
  content(P(337,101),[#text(font:"Cambria Math",size:15pt)[𝓣]])
  content(P(286,77),[#text(size:10pt)[a#sub[i]]])
  content(P(347,123),[#text(size:10pt)[b#sub[i]]])

  // (c) retains the resource U-shaped input and folds both LOCCs into Delta_i.
  bezier(P(483.2,73.0),P(467.0,84.2),P(473.5,75),P(467,77),stroke:(paint:green,thickness:1.4pt))
  line(P(467.0,84.2),P(467.0,113),stroke:(paint:green,thickness:1.4pt))
  bezier(P(467,113),P(483.2,127),P(467,121),P(475,125),stroke:(paint:green,thickness:1.4pt))
  content(P(455.0,100),[#text(font:"Cambria Math",size:14.5pt)[$sigma$]])
})
