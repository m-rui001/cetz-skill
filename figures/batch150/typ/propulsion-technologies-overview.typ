#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 重绘：CubeSat 微纳卫星推进技术分类总览（Aerospace 2024, 11(7), 502, Fig.1；DOI 10.3390/aerospace11070502）
// 外观：白底细黑框、顶部加粗标题主干、四主类粗框、虚线子类框、细箭头线稿

#canvas({
  import draw: *

  // ── 共享助手：方框＋居中文字、箭头、折线 ──
  let node(cx, cy, w, h, body, bold: false, dashed: false, fs: 8pt) = {
    rect(
      (cx - w / 2, cy - h / 2),
      (cx + w / 2, cy + h / 2),
      stroke: (
        paint: black,
        thickness: if bold { 1.5pt } else { 0.6pt },
        dash: if dashed { "dashed" } else { none },
      ),
      fill: white,
    )
    content((cx, cy), body, size: fs, weight: if bold { "bold" } else { "regular" })
  }
  let arr(a, b) = line(a, b, stroke: 0.6pt, mark: (end: "stealth", scale: 0.5))
  let wire(pts) = line(..pts, stroke: 0.6pt)

  // ── 顶部标题与主干分叉 ──
  node(10.75, 16.10, 11.5, 0.80,
    [Propulsion Systems for Microsatellites and Nanosatellites],
    bold: true, fs: 8.5pt)
  wire(((10.75, 15.70), (10.75, 15.35)))
  wire(((2.9, 15.35), (18.8, 15.35)))

  // ── 四个一级类别（粗框）──
  let cats = (
    (x: 2.9, w: 2.4, t: [Chemical]),
    (x: 6.9, w: 2.1, t: [Kinetic]),
    (x: 10.6, w: 2.5, t: [Electrical]),
    (x: 18.8, w: 3.0, t: [Propellant-less]),
  )
  for c in cats {
    node(c.x, 14.40, c.w, 0.75, c.t, bold: true, fs: 8.5pt)
    arr((c.x, 15.35), (c.x, 14.79))
  }

  // ── Chemical：左侧竖向总线（x=0.6）──
  wire(((2.9, 14.02), (2.9, 13.30), (0.6, 13.30), (0.6, 9.30)))
  let chem = (
    (y: 12.60, w: 2.3, h: 0.62, t: [Liquid], d: false, fs: 8pt),
    (y: 11.60, w: 2.8, h: 0.55, t: [Monopropellant], d: true, fs: 7.5pt),
    (y: 10.85, w: 2.8, h: 0.55, t: [Bipropellant], d: true, fs: 7.5pt),
    (y: 9.30, w: 2.3, h: 0.62, t: [Solid], d: false, fs: 8pt),
  )
  for c in chem {
    node(2.9, c.y, c.w, c.h, c.t, dashed: c.d, fs: c.fs)
    arr((0.6, c.y), (2.9 - c.w / 2, c.y))
  }
  // 单／双组元共用虚线包络
  rect((1.20, 11.95), (4.60, 10.50),
    stroke: (paint: black, thickness: 0.5pt, dash: "dashed"), fill: none)

  // ── Chemical 下端引出：化学混合／绿色推进剂 ──
  wire(((4.05, 9.30), (4.05, 7.20)))
  let hyb = (
    (y: 8.30, t: [Chemical \ Hybrid]),
    (y: 7.20, t: [Green \ Propellants]),
  )
  for h in hyb {
    node(6.35, h.y, 2.9, 0.82, h.t, dashed: true, fs: 7.5pt)
    arr((4.05, h.y), (4.90, h.y))
  }

  // ── Kinetic：左竖线分出冷气／电阻加热 ──
  wire(((6.9, 14.02), (6.9, 13.30), (5.5, 13.30), (5.5, 11.00)))
  let kin = (
    (y: 12.00, w: 2.3, t: [Cold Gas]),
    (y: 11.00, w: 2.5, t: [Resistojet]),
  )
  for k in kin {
    node(6.9, k.y, k.w, 0.62, k.t, fs: 8pt)
    arr((5.5, k.y), (6.9 - k.w / 2, k.y))
  }

  // ── Electrical：左竖线连接三大类（x=8.3 避开化学混合框）──
  wire(((10.6, 14.02), (10.6, 13.45), (8.9, 13.45), (8.9, 7.00)))
  node(10.6, 12.40, 2.9, 0.95, [Electrothermal \ Discharge], fs: 7.5pt)
  node(10.6, 11.15, 2.5, 0.62, [Electrostatic], fs: 8pt)
  node(10.6, 7.00, 2.9, 0.62, [Electromagnetic], fs: 7.5pt)
  arr((8.9, 12.40), (9.15, 12.40))
  arr((8.9, 11.15), (9.35, 11.15))
  arr((8.9, 7.00), (9.15, 7.00))

  // ── 静电类虚线子项（总线 x=12.6）──
  wire(((11.85, 11.15), (12.6, 11.15), (12.6, 7.35)))
  let esub = (
    (y: 10.00, h: 0.65, t: [Electrosprays]),
    (y: 9.20, h: 0.65, t: [Ion-Gridded]),
    (y: 8.25, h: 1.00, t: [Field Emission \ Electric Propulsion]),
    (y: 7.35, h: 0.65, t: [Hall-Effect]),
  )
  for s in esub {
    node(14.85, s.y, 3.5, s.h, s.t, dashed: true, fs: 7.5pt)
    arr((12.6, s.y), (13.1, s.y))
  }

  // ── 电磁类虚线子项（独立短总线）──
  wire(((12.05, 7.00), (12.6, 7.00), (12.6, 5.75)))
  let msub = (
    (y: 6.55, t: [Pulsed-Plasma]),
    (y: 5.75, t: [Ambipolar]),
  )
  for s in msub {
    node(14.85, s.y, 3.5, 0.65, s.t, dashed: true, fs: 7.5pt)
    arr((12.6, s.y), (13.1, s.y))
  }

  // ── Propellant-less：左竖线接五个子项 ──
  wire(((18.8, 14.02), (18.8, 13.40), (16.9, 13.40), (16.9, 8.20)))
  let psub = (
    (y: 12.20, h: 0.65, t: [Solar Sail]),
    (y: 11.20, h: 0.85, t: [Electrodynamic \ Tethers]),
    (y: 10.20, h: 0.65, t: [Photonic Laser]),
    (y: 9.20, h: 0.85, t: [Magnetic \ Laser]),
    (y: 8.20, h: 0.65, t: [Electric Sail]),
  )
  for s in psub {
    node(18.8, s.y, 3.3, s.h, s.t, fs: 7.5pt)
    arr((16.9, s.y), (17.15, s.y))
  }
})
