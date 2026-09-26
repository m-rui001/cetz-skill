#set page(width: auto, height: auto, margin: 2pt)
#set text(size: 6.2pt)
#import "@preview/cetz:0.4.2": canvas, draw

#canvas({
  import draw: *
  let S = 148.0
  let px = (x, y) => (x / S, (330.0 - y) / S)
  let t = (thickness: 1.05pt)
  let hd = (symbol: ">", fill: black, length: 6.1pt, width: 2.7pt)
  let dk = (thickness: 1.05pt, dash: (5.7pt, 1.3pt))

  line(path: true, px(258,16), px(255,21), px(250,38), px(242,61), px(232,84), px(221,106), px(210,127), px(197,146), px(185,160), px(168,176), px(145,193), px(120,206), px(95,213), px(70,213), px(48,205), px(30,192), px(19,175), px(18,165), px(24,148), px(40,133), px(62,122), px(88,118), px(112,121), px(136,129), px(158,141), px(178,156), px(185,160), px(200,176), px(215,193), px(228,211), px(242,230), px(254,249), px(265,268), px(269,275), px(271,281), stroke: t)
  line(path: true, px(922,15), px(915,24), px(911,35), px(900,58), px(888,80), px(876,100), px(864,118), px(855,130), px(845,142), px(835,142), px(810,140), px(788,126), px(762,115), px(734,110), px(708,113), px(686,122), px(667,139), px(660,158), px(666,177), px(679,191), px(701,202), px(728,208), px(757,204), px(785,192), px(809,177), px(828,162), px(835,155), px(848,165), px(849,173), px(865,192), px(890,207), px(918,219), px(951,229), px(985,238), px(1014,243), px(1020,246), stroke: t)
  line(px(293,161), px(497,161), stroke: dk, mark: (end: hd))
  content(px(98, 300), anchor: "west", [#text(size: 6.4pt)[$"in " bold(R)^2$]])
  content(px(830, 255), anchor: "center", [#text(size: 6.4pt)[Small deformation]])
  content(px(780, 298), anchor: "west", [#text(size: 6.4pt)[$"in " bold(R)^3$]])
})
