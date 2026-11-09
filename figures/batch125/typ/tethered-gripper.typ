#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 期望编译外观：上下两个虚线面板（交会捕获 / 拖曳清除），共享追逐器、碎片立方体、夹爪助手，
// 干净线稿平涂，红色系绳贯穿。来源：Mechanics of Space Debris Removal: A Review, Fig.33. DOI 10.3390/aerospace12040277.
#canvas({
  import draw: *

  // ---- 共享助手 ----
  let add(p, q) = (p.at(0) + q.at(0), p.at(1) + q.at(1))
  let mul(p, k) = (p.at(0) * k, p.at(1) * k)
  let poly(pts, fill: none, paint: black, th: 0.6pt) = draw.line(
    ..pts, close: true, fill: fill, stroke: (paint: paint, thickness: th))
  // 椭圆助手（折线近似，便于填充）
  let ell(c, rx, ry, fill: none, paint: black, th: 0.6pt) = {
    let (cx, cy) = c
    let n = 24
    let pts = range(n).map(i => {
      let a = 2 * calc.pi * i / n
      (cx + rx * calc.cos(a), cy + ry * calc.sin(a))
    })
    poly(pts, fill: fill, paint: paint, th: th)
  }

  // 配色
  let cDark = rgb("#3f4d5c")
  let cDarkEdge = rgb("#22303c")
  let cStripe = rgb("#77899a")
  let cBlue = rgb("#8fa3b5")
  let cGold = rgb("#c8a24a")
  let cGoldEdge = rgb("#6d5620")
  let cSilver = rgb("#d5d8dc")
  let cSolar = rgb("#7b7cb8")
  let cSolarEdge = rgb("#4a4b80")
  let cPeachF = rgb("#f6c9a6")
  let cPeachT = rgb("#fce2cb")
  let cPeachR = rgb("#e2a97f")
  let cPeachEdge = rgb("#b06a3b")
  let cGrip = rgb("#7f9db8")
  let cGripEdge = rgb("#3d556b")
  let cRed = rgb("#e01b1b")

  // 暗色太阳翼：起点 + 单位方向 + 长 + 宽，带两条浅色条纹
  let wing(from, dir, len, wid, fill) = {
    let d = mul(dir, len)
    let n = mul((-dir.at(1), dir.at(0)), wid)
    poly((from, add(from, d), add(add(from, d), n), add(from, n)), fill: fill, paint: cDarkEdge)
    for f in (0.32, 0.64) {
      let o = mul(n, f)
      draw.line(add(from, o), add(add(from, d), o), stroke: (paint: cStripe, thickness: 0.5pt))
    }
  }

  // 蓝紫太阳能板（碎片用）
  let spane(from, dir, len, wid) = {
    let d = mul(dir, len)
    let n = mul((-dir.at(1), dir.at(0)), wid)
    poly((from, add(from, d), add(add(from, d), n), add(from, n)), fill: cSolar, paint: cSolarEdge, th: 0.7pt)
  }

  // 追逐器平台：双侧暗色太阳翼 + 金色本体 + 碟形天线 + 黑色球头
  let chaser(c) = {
    let (x, y) = c
    wing((x - 0.6, y + 0.3), (-0.6, 0.8), 1.3, 0.7, cBlue)
    wing((x - 0.55, y - 0.2), (-0.62, -0.785), 2.1, 1.2, cDark)
    wing((x + 0.1, y + 0.22), (0.5, 0.866), 2.0, 1.1, cDark)
    poly(((x - 0.9, y - 0.4), (x + 0.45, y - 0.3), (x + 0.45, y + 0.3), (x - 0.9, y + 0.4)), fill: cGold, paint: cGoldEdge)
    poly(((x + 0.45, y - 0.3), (x + 0.78, y - 0.25), (x + 0.78, y + 0.25), (x + 0.45, y + 0.3)), fill: cSilver, paint: cGoldEdge)
    draw.line((x - 0.3, y + 0.32), (x - 0.3, y + 0.46), stroke: (paint: cGoldEdge, thickness: 0.6pt))
    ell((x - 0.3, y + 0.56), 0.3, 0.18, fill: white, paint: cGoldEdge)
    draw.circle((x + 0.62, y + 0.42), radius: 0.19, fill: black, stroke: none)
  }

  // 碎片：桃色立方体 + 两块蓝紫太阳能板 + 顶面黄色接口
  let debris(c) = {
    let (x, y) = c
    let d = (0.85, 0.62)
    let fbl = (x - 1.3, y - 1.0)
    let fbr = (x + 0.5, y - 0.85)
    let ftr = (x + 0.5, y + 1.05)
    let ftl = (x - 1.3, y + 0.9)
    spane((x - 1.3, y - 0.55), (-0.87, -0.49), 3.2, 0.6)
    spane(add(ftr, mul(d, 0.55)), (0.87, 0.49), 2.7, 0.6)
    poly((ftl, ftr, add(ftr, d), add(ftl, d)), fill: cPeachT, paint: cPeachEdge, th: 0.7pt)
    poly((fbr, add(fbr, d), add(ftr, d), ftr), fill: cPeachR, paint: cPeachEdge, th: 0.7pt)
    poly((fbl, fbr, ftr, ftl), fill: cPeachF, paint: cPeachEdge, th: 0.7pt)
    ell((x - 0.45, y + 0.1), 0.28, 0.42, paint: cPeachEdge)
    draw.circle(add(ftl, (0.35, 0.28)), radius: 0.1, fill: rgb("#e8c93a"), stroke: (paint: cPeachEdge, thickness: 0.5pt))
    draw.circle(add(ftl, (0.85, 0.38)), radius: 0.1, fill: rgb("#e8c93a"), stroke: (paint: cPeachEdge, thickness: 0.5pt))
  }

  // 夹爪：蓝灰小盒 + 右端青色夹指
  let gripper(c) = {
    let (x, y) = c
    poly(((x - 0.55, y + 0.3), (x + 0.5, y + 0.2), (x + 0.5, y - 0.2), (x - 0.55, y - 0.3)), fill: cGrip, paint: cGripEdge, th: 0.7pt)
    for k in (0.14, 0.0, -0.14) {
      draw.line((x + 0.5, y + k), (x + 0.8, y + k * 1.2), stroke: (paint: rgb("#48c2da"), thickness: 0.7pt))
    }
  }

  // ---- 上方面板：交会与捕获 ----
  draw.rect((0, 9.9), (18.6, 18.5), stroke: (paint: black, thickness: 1pt, dash: "dashed"))
  content((9.3, 17.7), [Rendezvous and Capture], size: 13pt)
  chaser((4.3, 14.5))
  gripper((11.0, 15.2))
  debris((13.9, 14.7))
  draw.line((4.92, 14.92), (10.45, 15.25), stroke: (paint: cRed, thickness: 2pt))
  content((9.4, 14.35), [Gripper], size: 13pt)

  // ---- 中间粗箭头 ----
  draw.line((9.3, 9.82), (9.3, 8.95), stroke: (paint: black, thickness: 2.4pt), mark: (end: "stealth"))

  // ---- 下方面板：拖曳清除 ----
  draw.rect((0, 0), (18.6, 8.6), stroke: (paint: black, thickness: 1pt, dash: "dashed"))
  chaser((4.3, 4.4))
  gripper((12.0, 5.0))
  debris((13.9, 4.9))
  draw.line((4.92, 4.82), (11.45, 5.05), stroke: (paint: cRed, thickness: 2pt))
  content((2.0, 6.9), [Platform], size: 13pt)
  content((7.6, 5.8), [Tether], size: 13pt)
  content((15.6, 2.5), [Debris], size: 13pt)
  content((9.3, 0.55), [Towing Removal], size: 13pt)
})
