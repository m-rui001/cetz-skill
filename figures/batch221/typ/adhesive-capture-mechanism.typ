#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 成品：白底干净线稿。左上灰色挤梁底座经双导轨与绿色滑块伸向十字轮毂；
// 四根浅灰扁臂呈 X 形张开，臂端品红粘合条向外翻卷；暗红拉簧由轮毂斜拉到
// 各臂内侧；轮毂右下挂一块绿色椭圆粘合板。三处引线标注落在留白处。
// 来源：Aerospace 2025, 12, 277 (空间碎片清除综述) Figure 30，DOI 10.3390/aerospace12040277。
#canvas({
  import draw: *

  // 配色
  let ink = rgb("#71717a")
  let armf = rgb("#efe8ef")
  let arms = rgb("#d5ced8")
  let mag = rgb("#ee22ee")
  let magd = rgb("#b000b8")
  let grn = rgb("#14b414")
  let grnd = rgb("#0a7d0a")
  let red = rgb("#a81f1f")
  let bmf = rgb("#b7b7bb")
  let bmd = rgb("#8b8b91")
  let serif = ("Times New Roman", "Liberation Serif")

  // 极坐标取点：中心 c、角度 a(度)、半径 r
  let P(c, a, r) = (c.at(0) + r * calc.cos(a * 1deg), c.at(1) + r * calc.sin(a * 1deg))
  // 折线第 i 点的单位左法线
  let nrm(pts, i) = {
    let a = pts.at(calc.max(i - 1, 0))
    let b = pts.at(calc.min(i + 1, pts.len() - 1))
    let d = (b.at(0) - a.at(0), b.at(1) - a.at(1))
    let l = calc.sqrt(d.at(0) * d.at(0) + d.at(1) * d.at(1))
    (-d.at(1) / l, d.at(0) / l)
  }
  // 带状体：中心线 + 半宽 → 闭合多边形，off 侧移模拟板厚
  let band(pts, w, off: 0) = {
    let L = ()
    let R = ()
    for i in range(pts.len()) {
      let m = nrm(pts, i)
      let wi = if type(w) == array { w.at(i) } else { w }
      let q = (pts.at(i).at(0) + off * m.at(0), pts.at(i).at(1) + off * m.at(1))
      L.push((q.at(0) + wi * m.at(0), q.at(1) + wi * m.at(1)))
      R.push((q.at(0) - wi * m.at(0), q.at(1) - wi * m.at(1)))
    }
    L + R.rev()
  }
  // 直杆带：中心 c、长 len、半宽 hw、方向 a
  let bar(c, len, hw, a) = band((P(c, a + 180, len / 2), P(c, a, len / 2)), hw)
  // 圆弧中心线：起点 p、初始方向 a、总转角 turn、弧长 len
  let arcpts(p, a, turn, len, n: 14) = {
    let s = if turn > 0 { 1 } else { -1 }
    let r = len * 180 / (calc.abs(turn) * calc.pi)
    let c = P(p, a + 90 * s, r)
    range(n + 1).map(i => P(c, a - 90 * s + turn * i / n, r))
  }
  // 方板：中心 c、半边长 r、转角 a
  let quad(c, r, a) = range(4).map(i => P(c, a + 45 + 90 * i, r * 1.414))
  // 长圆槽：灰边 + 白芯
  let slot(p, a, len) = {
    line(P(p, a, -len / 2), P(p, a, len / 2), stroke: (paint: ink, thickness: 0.16))
    line(P(p, a, -len / 2 + 0.05), P(p, a, len / 2 - 0.05), stroke: (paint: white, thickness: 0.09))
  }
  // 拉簧：细杆 + 中段密绕线圈 + 两端粗头
  let spring(p, q) = {
    let d = (q.at(0) - p.at(0), q.at(1) - p.at(1))
    let L = calc.sqrt(d.at(0) * d.at(0) + d.at(1) * d.at(1))
    let u = (d.at(0) / L, d.at(1) / L)
    let n = (-u.at(1), u.at(0))
    let at(t) = (p.at(0) + d.at(0) * t, p.at(1) + d.at(1) * t)
    line(p, q, stroke: (paint: red, thickness: 0.05))
    for i in range(14) {
      let c = at(0.20 + 0.68 * i / 13)
      line((c.at(0) - 0.05 * n.at(0), c.at(1) - 0.05 * n.at(1)),
           (c.at(0) + 0.05 * n.at(0), c.at(1) + 0.05 * n.at(1)),
           stroke: (paint: red, thickness: 0.042))
    }
    line(p, at(0.17), stroke: (paint: red, thickness: 0.10))
    line(at(0.88), q, stroke: (paint: red, thickness: 0.10))
  }
  // 椭圆：密采样折线
  let oval(c, rx, ry, a, n: 48) = range(n).map(i => {
    let t = 360 * i / n
    (c.at(0) + rx * calc.cos(t * 1deg) * calc.cos(a * 1deg) - ry * calc.sin(t * 1deg) * calc.sin(a * 1deg),
     c.at(1) + rx * calc.cos(t * 1deg) * calc.sin(a * 1deg) + ry * calc.sin(t * 1deg) * calc.cos(a * 1deg))
  })

  // 轮毂中心与四臂参数：方向角、灰杆长、粘合条长、条端外翻角、暗面侧
  let H = (8.20, 6.45)
  let armspec = ((94, 5.00, 3.45, 20, -1), (24, 4.05, 2.40, 70, -1),
                 (196, 4.75, 3.40, -44, 1), (260, 4.00, 2.15, -65, 1))

  // 挤梁底座：右端厚度面、上下翼缘、型材本体、纵向筋、左端线
  let A0 = (2.34, 7.42)
  let A1 = (5.98, 9.36)
  let bn = (-0.471, 0.883)
  let bd = (0.24, 0.16)
  line((A1.at(0) + 0.48 * bn.at(0), A1.at(1) + 0.48 * bn.at(1)),
       (A1.at(0) - 0.48 * bn.at(0), A1.at(1) - 0.48 * bn.at(1)),
       (A1.at(0) - 0.48 * bn.at(0) + bd.at(0), A1.at(1) - 0.48 * bn.at(1) + bd.at(1)),
       (A1.at(0) + 0.48 * bn.at(0) + bd.at(0), A1.at(1) + 0.48 * bn.at(1) + bd.at(1)),
       close: true, fill: rgb("#9a9aa0"), stroke: (paint: bmd, thickness: 0.8pt))
  for s in (0.50, -0.50) {
    line(..band((A0, A1), 0.10, off: s), close: true, fill: rgb("#d2d2d6"), stroke: (paint: bmd, thickness: 0.7pt))
  }
  line(..band((A0, A1), 0.44), close: true, fill: bmf, stroke: (paint: bmd, thickness: 0.8pt))
  for s in (0.22, 0.0, -0.22) {
    line((A0.at(0) + s * bn.at(0), A0.at(1) + s * bn.at(1)),
         (A1.at(0) + s * bn.at(0), A1.at(1) + s * bn.at(1)), stroke: (paint: bmd, thickness: 0.6pt))
  }
  line((A0.at(0) + 0.60 * bn.at(0), A0.at(1) + 0.60 * bn.at(1)),
       (A0.at(0) - 0.60 * bn.at(0), A0.at(1) - 0.60 * bn.at(1)), stroke: (paint: bmd, thickness: 0.7pt))
  // 双导轨：由梁端伸入轮毂；绿色滑块横跨其上
  line((6.06, 9.12), (7.92, 7.02), stroke: (paint: bmd, thickness: 1.5pt))
  line((6.02, 8.72), (7.86, 6.66), stroke: (paint: bmd, thickness: 1.3pt))
  for t in (0.10, 0.42) {
    let c = (6.06 + 1.86 * t, 9.12 - 2.10 * t)
    line(..bar(c, 0.86, 0.15, 41.5), close: true, fill: grn, stroke: (paint: grnd, thickness: 0.6pt))
    line(..bar((c.at(0) - 0.22, c.at(1) + 0.17), 0.30, 0.09, 41.5), close: true, fill: grn, stroke: none)
  }
  // 四臂：灰杆 + 长圆槽 + 品红粘合条
  for (a, lj, lp, turn, side) in armspec {
    let j = P(H, a, lj)
    line(..band((H, j), 0.34, off: 0.075 * side), close: true, fill: arms, stroke: none)
    line(..band((H, j), 0.34), close: true, fill: armf, stroke: (paint: ink, thickness: 0.7pt))
    slot(P(H, a, lj * 0.42), a, 0.50)
    slot(P(H, a, lj * 0.76), a, 1.05)
    let cp = arcpts(j, a, turn, lp)
    let wd = range(cp.len()).map(i => 0.31 - 0.055 * i / (cp.len() - 1))
    line(..band(cp, wd), close: true, fill: mag, stroke: (paint: magd, thickness: 0.7pt))
  }
  // 四根拉簧：轮毂侧汇聚，另一端搭在臂内侧
  spring((8.52, 6.98), (8.62, 9.35))
  spring((8.58, 6.54), (10.26, 7.04))
  spring((7.88, 5.80), (6.12, 5.18))
  spring((8.62, 5.86), (8.28, 3.88))


  // 轮毂：两根交叉搭板（各跨一对臂）+ 深灰中心块 + 绿色横销 + 红色短销
  line(..bar(H, 1.90, 0.30, 24), close: true, fill: rgb("#b3b3ba"), stroke: (paint: ink, thickness: 0.9pt))
  line(..bar(H, 1.90, 0.30, 94), close: true, fill: rgb("#a5a5ac"), stroke: (paint: ink, thickness: 0.9pt))
  line(..quad(H, 0.30, 10), close: true, fill: rgb("#76767d"), stroke: (paint: ink, thickness: 0.8pt))
  line((7.86, 6.80), (8.42, 6.66), stroke: (paint: grn, thickness: 0.20))
  line((8.60, 6.56), (8.90, 6.48), stroke: (paint: grn, thickness: 0.16))
  line((8.92, 6.26), (9.18, 6.12), stroke: (paint: red, thickness: 0.13))

  // 绿色粘合板
  line(..oval((9.92, 5.94), 0.76, 0.86, -20), close: true, fill: grn, stroke: (paint: grnd, thickness: 0.9pt))
  // 引线标注
  let lbl(p, t) = content(p, text(font: serif, size: 15pt, t), anchor: "west")
  let lead(p, q) = line(p, q, stroke: (paint: black, thickness: 0.8pt))
  lbl((8.92, 12.94), [Adhesive arm])
  lead((8.80, 12.72), (8.06, 11.96))
  lbl((9.30, 3.44), [Adhesive plate])
  lead((10.52, 4.02), (10.20, 5.00))
  lbl((1.92, 3.00), [Tension spring])
  lead((5.86, 3.52), (8.44, 4.96))
})
