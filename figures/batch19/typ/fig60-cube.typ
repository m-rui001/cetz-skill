#set page(width: auto, height: auto, margin: 12pt)
#import "@preview/cetz:0.4.2": canvas, draw

#canvas({
  import draw: *
  let th = (thickness: 1pt)
  let td = (dash: "dashed", thickness: 1pt)
  let tp = (dash: "dotted", thickness: 1pt)
  let h = 2.0
  let k = .55
  let m = .42
  let S = (x, y, z) => (y - k * x, z - m * x)
  line(S(-h, -h, h), S(-h, -h, -h), stroke: tp)
  line(S(-h, -h, -h), S(-h, h, -h), stroke: tp)
  line(S(h, -h, -h), S(-h, -h, -h), stroke: tp)
  line(S(-h, -h, h), S(-h, h, h), stroke: th)
  line(S(-h, h, h), S(-h, h, -h), stroke: th)
  for (y, z) in ((h, h), (-h, h), (h, -h)) {
    line(S(h, y, z), S(-h, y, z), stroke: th)
  }
  line(S(h, -h, -h), S(h, h, -h), S(h, h, h), S(h, -h, h), close: true, stroke: th)
  line((0, 0), S(h, 0, 0), stroke: td)
  line(S(h, 0, 0), S(6.4, 0, 0), stroke: th, mark: (end: ">"))
  line((0, 0), S(-h, 0, 0), stroke: td)
  line(S(-h, 0, 0), S(-6.0, 0, 0), stroke: th)
  line((0, 0), (0.0 - h, 0), stroke: td)
  line((0.0 - h, 0), (0.0 - 3.7, 0), stroke: th)
  line((0, 0), (h, 0), stroke: td)
  line((h, 0), (3.7, 0), stroke: th, mark: (end: ">"))
  line((0, 0), (0, h), stroke: td)
  line((0, h), (0, 3.4), stroke: th, mark: (end: ">"))
  line((0, 0), (0, 0.0 - h), stroke: td)
  line((0, 0.0 - h), (0, 0.0 - 3.4), stroke: th)
  let mk = (p) => {
    circle(p, radius: .11, fill: black, stroke: none)
    line((p.at(0) - .2, p.at(1) - .2), (p.at(0) + .2, p.at(1) + .2), stroke: th)
    line((p.at(0) - .2, p.at(1) + .2), (p.at(0) + .2, p.at(1) - .2), stroke: th)
  }
  let top = (0, h)
  let bot = (0, 0.0 - h)
  let lft = (0.0 - h, 0)
  let rgt = (h, 0)
  let frt = S(h, 0, 0)
  let bak = S(-h, 0, 0)
  for p in (top, bot, lft, rgt, frt, bak) { mk(p) }
  content((.28, 1.8), anchor: "west", [Top])
  content((bak.at(0) + .3, bak.at(1) + .12), anchor: "west", [Back])
  content((lft.at(0), lft.at(1) - .95), [Left])
  content((rgt.at(0), rgt.at(1) - .95), [Right])
  content((frt.at(0) - .18, frt.at(1) - .8), anchor: "east", [Front])
  content((bot.at(0) + .32, bot.at(1) - .18), anchor: "west", [Bottom])
  content((.2, -.62), anchor: "west", [$(0, 0, 0)$])
  let xt = S(6.4, 0, 0)
  content((xt.at(0) + .12, xt.at(1) - .3), anchor: "west", [$x$])
  content((3.85, -.45), anchor: "west", [$y$])
  content((.2, 3.2), anchor: "west", [$z$])
})
