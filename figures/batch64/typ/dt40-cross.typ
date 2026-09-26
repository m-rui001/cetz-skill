#set page(width: auto, height: auto, margin: 2pt)
#set text(size: 6.2pt)
#import "@preview/cetz:0.4.2": canvas, draw

#canvas({
  import draw: *
  let S = 148.0
  let px = (x, y) => (x / S, (321.0 - y) / S)
  let t = (thickness: 1.05pt)
  let hd = (symbol: ">", fill: black, length: 8.6pt, width: 2.6pt)
  let dk = (thickness: 1.05pt, dash: (4.2pt, 1.3pt))

  line(path: true, px(64,31), px(66,44), px(68,52), px(70,60), px(73,68), px(75,76), px(78,84), px(81,92), px(85,100), px(90,108), px(94,116), px(99,124), px(104,132), px(110,140), px(116,148), px(124,158), px(133,167), px(142,177), px(154,189), px(164,197), px(178,209), px(190,217), px(202,225), px(214,233), px(226,240), px(238,247), px(250,253), px(262,259), px(274,264), px(283,268), px(284,268), stroke: t)
  line(path: true, px(22,285), px(22,285), px(33,268), px(46,251), px(58,237), px(69,224), px(82,211), px(94,200), px(106,189), px(118,179), px(126,172), px(135,166), px(142,160), px(154,152), px(166,146), px(179,139), px(190,133), px(202,127), px(214,122), px(226,118), px(238,114), px(250,111), px(262,108), px(274,106), px(286,105), px(298,104), px(310,104), px(312,104), stroke: t)
  line(path: true, px(110,160), px(111,156), px(113,151), px(118,147), px(124,143), px(129,144), px(130,144), stroke: t)
  line(path: true, px(148,200), px(149,200), px(154,201), px(160,197), px(165,193), px(167,188), px(168,184), stroke: t)
  line(path: true, px(670,24), px(670,26), px(671,32), px(672,38), px(673,44), px(674,50), px(676,56), px(678,62), px(680,68), px(682,74), px(684,80), px(686,86), px(688,92), px(692,98), px(694,104), px(698,110), px(700,116), px(704,122), px(708,128), px(711,134), px(715,140), px(719,146), px(724,152), px(728,158), px(732,164), px(737,170), px(742,176), px(770,184), px(779,188), px(782,194), px(782,200), px(781,206), px(781,212), px(785,218), px(791,224), px(799,230), px(806,236), px(815,242), px(823,248), px(831,254), px(841,260), px(850,266), px(859,272), px(870,278), px(880,284), px(892,290), px(903,296), px(910,299), stroke: t)
  line(path: true, px(786,179), px(788,176), px(794,170), px(800,164), px(806,159), px(812,154), px(818,149), px(824,145), px(830,140), px(836,136), px(842,132), px(848,128), px(854,124), px(860,120), px(866,117), px(872,114), px(878,111), px(884,108), px(890,105), px(896,102), px(902,100), px(908,98), px(914,95), px(920,93), px(926,91), px(932,90), px(933,90), stroke: t)
  line(path: true, px(690,313), px(693,308), px(699,297), px(705,286), px(711,275), px(717,265), px(723,256), px(729,247), px(735,238), px(741,230), px(747,222), px(753,215), px(759,208), px(765,200), px(770,195), stroke: t)
  line(px(323,176), px(583,176), stroke: dk, mark: (end: hd))
  content(px(37, 35), anchor: "center", [#text(size: 6.4pt)[$X$]])
  content(px(303.5, 122.5), anchor: "center", [#text(size: 6.4pt)[$Z$]])
  content(px(128.5, 198), anchor: "center", [#text(size: 6.4pt)[$U$]])
  content(px(640, 31), anchor: "center", [#text(size: 6.4pt)[$X_i$]])
  content(px(925.5, 111), anchor: "center", [#text(size: 6.4pt)[$Z$]])
})
