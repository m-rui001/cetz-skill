#set page(width: auto, height: auto, margin: 12pt)
#import "@preview/cetz:0.4.2": canvas, draw
#set text(size: 11pt)

#canvas({
  import draw: *

  let tr = (thickness: 1.25pt)
  let add = (p, q) => (p.at(0) + q.at(0), p.at(1) + q.at(1))
  let u = (a) => (calc.cos(a), calc.sin(a))
  let sc = (p, k) => (p.at(0) * k, p.at(1) * k)

  // eight rays with an open "V" partway along each.
  // out = true → the V opens back toward the centre (field pointing away)
  let asterisk = (c, out, sign, tag) => {
    let r0 = .32
    let r1 = 2.25
    let rv = 1.20
    let leg = .18
    for i in range(8) {
      let a = i * 45deg
      line(add(c, sc(u(a), r0)), add(c, sc(u(a), r1)), stroke: tr)
      let tip = add(c, sc(u(a), rv))
      let d = if out { a + 180deg } else { a }
      line(tip, add(tip, sc(u(d + 32deg), leg)), stroke: tr)
      line(tip, add(tip, sc(u(d - 32deg), leg)), stroke: tr)
    }
    content(c, anchor: "center", sign)
    content((c.at(0), 0.0 - 0.75), anchor: "center", [#(tag)])
  }

  asterisk((2.5, 2.1), true, [$+$], "(a)")
  asterisk((8.9, 2.1), false, [$-$], "(b)")
})
