#set page(width: auto, height: auto, margin: 12pt)
#import "@preview/cetz:0.4.2": canvas, draw

#canvas({
  import draw: *
  // ---- panel (a): small, left ----
  let Oa = (0, 0)
  let Ba = (2.0, .95)
  let Aa = (.75, .95)
  line(Oa, Ba, mark: (end: ">"))
  line(Oa, Aa, mark: (end: ">"))
  let ra = .45
  let aB = calc.atan2(Ba.at(1), Ba.at(0))
  let aA = calc.atan2(Aa.at(1), Aa.at(0))
  arc((ra * calc.cos(aB), ra * calc.sin(aB)), radius: ra, start: aB, stop: aA)
  content((.45, .1), [$theta$])
  content((Aa.at(0) - .2, Aa.at(1) + .2), [$arrow(A)$])
  content((Ba.at(0) + .12, Ba.at(1) - .3), [$arrow(B)$])
  content((.1, -1.9), [(a)])
  // ---- panel (b): large, right ----
  let Ob = (3.6, .1)
  let Bb = (6.9, 1.35)
  let Ab = (4.9, 2.6)
  line(Ob, Bb, mark: (end: ">"))
  line(Ob, Ab, mark: (end: ">"))
  // foot of perpendicular from A onto line OB
  let L = calc.sqrt((Bb.at(0) - Ob.at(0)) * (Bb.at(0) - Ob.at(0)) + (Bb.at(1) - Ob.at(1)) * (Bb.at(1) - Ob.at(1)))
  let d = ((Bb.at(0) - Ob.at(0)) / L, (Bb.at(1) - Ob.at(1)) / L)
  let t = (Ab.at(0) - Ob.at(0)) * d.at(0) + (Ab.at(1) - Ob.at(1)) * d.at(1)
  let H = (Ob.at(0) + t * d.at(0), Ob.at(1) + t * d.at(1))
  line(Ab, H, stroke: (dash: "dashed"))
  // right-angle mark at H
  let q = ((Ab.at(0) - H.at(0)) / calc.sqrt((Ab.at(0) - H.at(0)) * (Ab.at(0) - H.at(0)) + (Ab.at(1) - H.at(1)) * (Ab.at(1) - H.at(1))), (Ab.at(1) - H.at(1)) / calc.sqrt((Ab.at(0) - H.at(0)) * (Ab.at(0) - H.at(0)) + (Ab.at(1) - H.at(1)) * (Ab.at(1) - H.at(1))))
  let p1 = (H.at(0) + .14 * d.at(0), H.at(1) + .14 * d.at(1))
  let p2 = (p1.at(0) + .14 * q.at(0), p1.at(1) + .14 * q.at(1))
  let p3 = (H.at(0) + .14 * q.at(0), H.at(1) + .14 * q.at(1))
  line(p1, p2, p3, stroke: (dash: "dashed"))
  // angle arc at origin
  let rb = .62
  let aB2 = calc.atan2(Bb.at(1) - Ob.at(1), Bb.at(0) - Ob.at(0))
  let aA2 = calc.atan2(Ab.at(1) - Ob.at(1), Ab.at(0) - Ob.at(0))
  arc((Ob.at(0) + rb * calc.cos(aB2), Ob.at(1) + rb * calc.sin(aB2)), radius: rb, start: aB2, stop: aA2)
  content((Ob.at(0) + .58, Ob.at(1) + .22), [$theta$])
  content((Ab.at(0) - .3, Ab.at(1) + .2), [$arrow(A)$])
  content((Bb.at(0) + .12, Bb.at(1) + .1), [$arrow(B)$])
  // brace under the projected segment Ob–H
  let mx = (Ob.at(0) + H.at(0)) / 2
  let my = (Ob.at(1) + H.at(1)) / 2
  bezier((Ob.at(0) + .06, Ob.at(1) - .14), (H.at(0) - .04, H.at(1) - .12), (mx - .55, my - .3), (mx + .55, my - .3))
  content((3.7, -1.9), [(b)])
  content((3.7, -2.6), [The projection of $arrow(A)$ onto $arrow(B)$:])
  content((3.7, -3.05), [$| arrow(A) | cos theta$ times the length of $arrow(B)$:])
  content((3.7, -3.5), [gives the dot product $arrow(A) dot arrow(B)$: $| arrow(A) | | arrow(B) | cos theta$])
})
