#set page(width: auto, height: auto, margin: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw
#set text(font: "Calibri", size: 12pt)
#canvas(length: 1pt, {
  import draw: *
  let P = (x,y) => (.6*x,.6*(664 - y))
  let cyan = rgb("#71d8f1")
  let red = rgb("#ff0000")
  let node = (x,y,label) => {
    circle(P(x,y), radius:(11.5,9.2), fill:cyan, stroke:none)
    content(P(x,y),text(size:12pt,label))
  }
  let link = (a,b,y) => {
    line(P(a,y),P(b,y),stroke:(thickness:1.05pt,dash:(array:(4.5pt,3pt))))
    line(P(a,y),P(a + 10,y - 4.5),P(a + 10,y + 4.5),close:true,fill:black,stroke:none)
    line(P(b,y),P(b - 10,y - 4.5),P(b - 10,y + 4.5),close:true,fill:black,stroke:none)
  }
  let distance = (x,y,c) => content(P(x,y),text(font:"Cambria Math",size:22pt,c))
  content(P(21,47),[(a)],anchor:"west")
  content(P(380,32),text(fill:red,weight:"bold",size:18pt,[#emph[n] nesting levels]))
  for (x,l) in ((42,"A"),(164,"QM"),(207,"QM"),(328,"QM"),(426,"QM"),(549,"QM"),(589,"QM"),(714,"B")) { node(x,113,l) }
  for (a,b,x) in ((64,144,102),(228,308,266),(448,529,482),(611,692,651)) {
    link(a,b,115)
    distance(x,88,$L_0$)
  }
  line(P(361,113),P(396,113),stroke:(thickness:1pt,dash:(array:(4.5pt,3.5pt))))
  line(P(68,150),P(694,150),stroke:1pt)
  line(P(68,150),P(79,145),P(79,155),close:true,fill:black,stroke:none)
  line(P(694,150),P(683,145),P(683,155),close:true,fill:black,stroke:none)
  distance(373,187,$L = 2^n L_0$)

  content(P(21,247),[(b)],anchor:"west")
  content(P(388,252),text(fill:red,weight:"bold",size:18pt,[2 nesting levels]))
  for (x,l) in ((95,"A"),(215,"QM"),(258,"QM"),(379,"QM"),(426,"QM"),(548,"QM"),(590,"QM"),(715,"B")) { node(x,359,l) }
  for (a,b,x) in ((115,195,151),(279,358,315),(448,528,484),(611,693,650)) {
    link(a,b,362)
    distance(x,334,$L_0$)
  }
  for x in (236,568) {
    circle(P(x,360),radius:27,stroke:(paint:red,thickness:1.4pt))
    content(P(x,306),text(size:18pt,[BSM1]))
  }
  let progress = (y) => {
    bezier(P(60,y),P(60,y + 92),P(4,y + 7),P(4,y + 72),stroke:(paint:cyan,thickness:6.2pt))
    bezier(P(60,y),P(60,y + 92),P(4,y + 7),P(4,y + 72),stroke:(paint:red,thickness:4pt))
    line(P(46,y + 79),P(61,y + 93),P(47,y + 103),close:true,fill:red,stroke:(paint:cyan,thickness:.7pt))
  }
  progress(384)
  progress(520)
  for (x,l) in ((96,"A"),(383,"QM"),(427,"QM"),(715,"B")) { node(x,496,l) }
  link(116,360,500)
  link(450,693,500)
  distance(235,467,$2L_0$)
  distance(576,467,$2L_0$)
  circle(P(407,494),radius:27,stroke:(paint:red,thickness:2.8pt))
  content(P(407,438),text(weight:"bold",size:18pt,[BSM2]))
  node(96,634,"A")
  node(715,634,"B")
  link(117,693,637)
  distance(406,602,$4L_0$)
})
