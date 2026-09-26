#set page(width: auto, height: auto, margin: 2pt)
#set text(size: 6.5pt)
#import "@preview/cetz:0.4.2": canvas, draw

#canvas({
  import draw: *
  let S = 148.0
  let px = (x, y) => (x / S, (380.0 - y) / S)

  line(stroke: (thickness: 1.15pt, cap: "round"), px(176.0,136.0), px(105.0,16.0))
  line(stroke: (thickness: 1.15pt, cap: "round"), px(105.0,16.0), px(127.0,36.0))
  line(stroke: (thickness: 1.15pt, cap: "round"), px(105.0,16.0), px(115.0,46.0))
  line(stroke: (thickness: 1.15pt, cap: "round"), px(215.0,136.0), px(286.0,17.0))
  line(stroke: (thickness: 1.15pt, cap: "round"), px(286.0,17.0), px(277.0,46.0))
  line(stroke: (thickness: 1.15pt, cap: "round"), px(286.0,17.0), px(265.0,37.0))
  line(stroke: (thickness: 1.15pt, cap: "round"), px(237.0,173.0), px(369.0,169.0))
  line(stroke: (thickness: 1.15pt, cap: "round"), px(369.0,169.0), px(368.0,173.0))
  line(stroke: (thickness: 1.15pt, cap: "round"), px(369.0,169.0), px(341.0,164.0))
  line(stroke: (thickness: 1.15pt, cap: "round"), px(157.0,169.0), px(14.0,171.0))
  line(stroke: (thickness: 1.15pt, cap: "round"), px(14.0,171.0), px(37.0,165.0))
  line(stroke: (thickness: 1.15pt, cap: "round"), px(14.0,171.0), px(43.0,178.0))
  line(stroke: (thickness: 1.15pt, cap: "round"), px(178.0,204.0), px(107.0,326.0))
  line(stroke: (thickness: 1.15pt, cap: "round"), px(107.0,326.0), px(117.0,296.0))
  line(stroke: (thickness: 1.15pt, cap: "round"), px(107.0,326.0), px(129.0,305.0))
  line(stroke: (thickness: 1.15pt, cap: "round"), px(217.0,206.0), px(287.0,323.0))
  line(stroke: (thickness: 1.15pt, cap: "round"), px(287.0,323.0), px(264.0,301.0))
  line(stroke: (thickness: 1.15pt, cap: "round"), px(287.0,323.0), px(276.0,293.0))
  circle(px(196.0,170.5), radius: 8.2 / S, fill: black, stroke: none)
  content(px(193,356.5), anchor: "center", [#text(size: 6.5pt)[Source]])
})
