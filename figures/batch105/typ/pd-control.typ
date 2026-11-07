// 编译效果：黑白 PD 控制框图。顶行 Full Assistance Mode 经 Reference（θ_r, ω_r）入带 X 交叉的
// 求和圆（左上 +、底部 −），经 e, ė 依次串接 PD Controller、PWM、Proportional Valve、Soft Actuator、
// Flex Sensors；传感器下折经 Angle θ 入 First Order Low Pass Filter，滤波输出长反馈线左行
// （Filtered Angle θ），左端上折入求和圆负端（支路标 θ, ω）；反馈线中右支路下折入
// Δθ/Δt 小块，其输出左行（Angular Velocity ω）上折汇入反馈线；左列 Wait 't' seconds 上馈 Reference，
// Partial Assistance Mode 上馈 Wait 盒。
// 来源：Pneumatically Actuated Soft Robotic Hand and Wrist Exoskeleton for Motion Assistance
// in Rehabilitation. Actuators 2024, 13(5), 180. DOI 10.3390/act13050180, Figure 4.
#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10.5pt)
#import "@preview/cetz:0.4.2": canvas, draw

#canvas(length: 1cm, {
  import draw: *
  // 共享 helper：方盒、带标签直箭头、折线箭头、求和圆
  let wire = 1.3pt
  let head = (end: ">", fill: black, length: .3, width: .22)
  let box(c, w, h, body) = {
    rect((c.at(0) - w / 2, c.at(1) - h / 2), (c.at(0) + w / 2, c.at(1) + h / 2), stroke: 1.1pt)
    content(c, text(weight: "bold", body))
  }
  let poly(pts) = line(..pts, stroke: wire, mark: head)
  let arrow(a, b, lab) = {
    poly((a, b))
    if lab != none {
      content(((a.at(0) + b.at(0)) / 2, (a.at(1) + b.at(1)) / 2 + .12),
        anchor: "south", text(weight: "bold", lab))
    }
  }
  let lab(at, anc, body) = content(at, anchor: anc, text(weight: "bold", body))
  let junction(c, r) = {
    circle(c, radius: r, stroke: 1.1pt)
    let d = r * 0.7071
    line((c.at(0) - d, c.at(1) - d), (c.at(0) + d, c.at(1) + d), stroke: wire)
    line((c.at(0) - d, c.at(1) + d), (c.at(0) + d, c.at(1) - d), stroke: wire)
    lab((c.at(0) - r * .58, c.at(1) + r * .27), "center", [+])
    lab((c.at(0), c.at(1) - r * .55), "center", [−])
  }
  // 顶行链：名称/宽/高/文本表 + 间隙表，循环推导中心与盒间箭头
  let top = (
    ("full", 2.4, 1.5, [Full #linebreak() Assistance #linebreak() Mode]),
    ("sum", 1.1, 1.1, none),
    ("pd", 2.8, .85, [PD Controller]),
    ("valve", 2.6, 1.3, [Proportional #linebreak() Valve]),
    ("act", 1.9, 1.1, [Soft #linebreak() Actuator]),
    ("flex", 1.9, 1.1, [Flex #linebreak() Sensors]),
  )
  let gaps = (1.65, .9, 1.3, .8, 1.2)
  let elabs = (none, [$e, dot(e)$], [PWM], none, none)
  let C = (:)
  let S = (:)
  let x = 0.3
  for i in range(top.len()) {
    let (name, w, h, body) = top.at(i)
    let c = (x + w / 2, 0)
    C.insert(name, c)
    S.insert(name, (w, h))
    if name == "sum" { junction(c, w / 2) } else { box(c, w, h, body) }
    if i < top.len() - 1 {
      arrow((x + w, 0), (x + w + gaps.at(i), 0), elabs.at(i))
      x += w + gaps.at(i)
    } else { x += w }
  }
  let R = (k) => (C.at(k).at(0) + S.at(k).at(0) / 2, 0)
  let L = (k) => (C.at(k).at(0) - S.at(k).at(0) / 2, 0)
  // 命名锚点：反馈层、微分层与左列、滤波器、微分盒
  let yfb = -2.3
  let yd = -3.9
  let xj = C.sum.at(0)
  let xt2 = xj - .75
  let filter = (C.act.at(0), yfb)
  let fw = 2.6
  let fh = 1.5
  let wait = (xt2 - 1.1, -1.35)
  let partial = (wait.at(0), -3.2)
  let xd = C.valve.at(0) - .3
  let xm = xj + 1.4
  let deriv = ((xm + xd) / 2 + .3, yd)
  // 左列：Partial 上馈 Wait，Wait 上馈 Reference 箭头
  box(wait, 1.7, 1.15, [Wait ‘t’ #linebreak() seconds])
  box(partial, 2.2, 1.4, [Partial #linebreak() Assistance #linebreak() Mode])
  arrow((wait.at(0), partial.at(1) + .7), (wait.at(0), wait.at(1) - .575), none)
  arrow((wait.at(0), wait.at(1) + .575), (wait.at(0), 0), none)
  // 传感器下折左行入滤波器；滤波输出长反馈线左行、左端上折入求和圆负端
  box(filter, fw, fh, [First Order #linebreak() Low Pass #linebreak() Filter])
  poly(((C.flex.at(0), -.55), (C.flex.at(0), yfb), (filter.at(0) + fw / 2, yfb)))
  poly(((filter.at(0) - fw / 2, yfb), (xj, yfb), (xj, -.55)))
  // 反馈线中右支路：下折左行入 Δθ/Δt 盒，输出左行上折汇入反馈线
  box(deriv, .9, 1.2, [$(Delta theta) / (Delta t)$])
  poly(((xd, yfb), (xd, yd), (deriv.at(0) + .45, yd)))
  poly(((deriv.at(0) - .45, yd), (xm, yd), (xm, yfb)))
  // 信号标签：Reference 双行、θ ω、Filtered Angle、Angle θ、Angular Velocity
  let refm = (R("full").at(0) + L("sum").at(0)) / 2 + .18
  lab((refm, .5), "south", [Reference])
  lab((refm, .14), "south", [$theta_r, omega_r$])
  lab((xj + .15, -1.3), "west", [$theta, omega$])
  lab((filter.at(0) - fw / 2 - .9, yfb + .15), "south", [Filtered #linebreak() Angle $theta$])
  lab(((filter.at(0) + fw / 2 + C.flex.at(0)) / 2, yfb - .15), "north", [Angle $theta$])
  lab(((xm + deriv.at(0) - .45) / 2, yd + .15), "south", [Angular #linebreak() Velocity $omega$])
})