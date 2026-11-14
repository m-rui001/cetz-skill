// 轴向磁通永磁电机四联图（线稿重绘）
// 源图：A Review of Axial Flux Permanent Magnet Machine Technology
//       (IEEE Trans. Industry Applications, 2023) Fig. 5
//       (a) T-shaped PM 盘式转子照片  (b) Torus 机 + 准 Halbach 转子剖视
//       (c) 准 Halbach 转子的磁钢分块排布  (d) 轴向磁通磁钢 / 斜极拓扑分类圆图
//
// 版面（自左向右，与源图一致）：
//   (a) disc-rotor     盘式转子线稿：背铁圆盘 + 14 个 T 形磁钢分块 + 9 个螺栓 / 轴孔
//   (b) torus-section  Torus 机轴向剖视：上/下转子叠片盘（3）+ 准 Halbach 磁钢层（4）+
//                      两侧气隙 + 中间的环形（toroidal）定子（铁芯 1 / 2 + 环形绕组）+ 轴
//                      注：源图编号 3 指向外侧灰盘（转子）、1 与 2 指向中间绕线环（定子），
//                      故中间为定子、两侧为转子，与源图标注一致。
//   (c) halbach-rotor  两个极的磁钢分块图（每极 5 块叠片扇形块 + 磁化方向箭头）
//   (d) topology-wheel 扇区拓扑分类圆环：8 种磁钢形状 + 引线标签
//
// 说明：源图 (a) 为实物照片，本图改为纯线稿；源图 (b) 的 3D 剖切楔块改为轴对称剖视，
//       保留源图编号 1 stator core / 2 toroidal stator core / 3 rotor / 4 PM，
//       并补画源图未显示的轴。其余各图的几何关系、编号与标签位置均按源图。
#set page(width: auto, height: auto, margin: 6pt)
#import "@preview/cetz:0.4.2": canvas, draw
#set text(font: ("Times New Roman", "Segoe UI"), size: 7.6pt, fill: rgb("#1d1d1d"))

#canvas({
  import draw: *

  // 配色与线型
  let INK = rgb("#1d1d1d")        // 主线条
  let CORE = rgb("#8f9598")       // 定子铁芯（灰）
  let COREL = rgb("#b6bbbe")      // 铁芯叠片内圈线
  let ROTOR = rgb("#eceeef")      // 转子叠片盘（浅灰）
  let RHATCH = rgb("#c3c9cc")     // 转子盘斜线
  let PM = rgb("#5f676d")         // 磁钢（深灰，便于放白色磁化箭头）
  let WIND = rgb("#f4e3c9")       // 环形绕组（源图橙色 → 浅橙）
  let WIND2 = rgb("#cfae7e")      // 绕组轮廓线
  let BLUE = rgb("#d2dfef")       // (c) 磁钢分块
  let SECT = rgb("#9aa0a3")       // (d) 圆环 / 扇区虚线
  let MAGD = rgb("#d5d6d3")       // (d) 磁钢灰填充
  let SHAFT = rgb("#cfd3d5")      // 轴

  let st = (paint: INK, thickness: 0.6pt)
  let stt = (paint: INK, thickness: 0.4pt)
  let dash = (paint: SECT, thickness: 0.4pt, dash: (1.1pt, 1.1pt))
  let thinn = (paint: RHATCH, thickness: 0.35pt)

  // 通用工具函数

  // 极坐标折线 / 圆弧采样：pts 为 (半径, 角度, 下一点是否走弧线) 的数组，
  // 走弧线时沿当前半径按角度插值，角度差为负则表示反向。
  let polar-path(cx, cy, pts, n: 18) = {
    let out = ()
    for i in range(0, pts.len()) {
      let (r, t, mode) = pts.at(i)
      out.push((cx + r * calc.cos(t), cy + r * calc.sin(t)))
      if mode == "A" {
        let (_, t1, _) = pts.at(calc.rem(i + 1, pts.len()))
        for k in range(1, n) {
          let tt = t + (t1 - t) * k / n
          out.push((cx + r * calc.cos(tt), cy + r * calc.sin(tt)))
        }
      }
    }
    out
  }

  // 矩形内的 45° 斜线填充（手工裁剪，用于转子叠片盘）
  let hatch(x0, y0, x1, y1, step: 0.24, stroke: thinn) = {
    let h = y1 - y0
    let c = x0 - h
    while c < x1 {
      let xa = calc.max(x0, c)
      let ya = y0 + (xa - c)
      let xb = calc.min(x1, c + h)
      let yb = y0 + (xb - c)
      if xb - xa > 0.03 { line((xa, ya), (xb, yb), stroke: stroke) }
      c += step
    }
  }

  // 磁场 / 磁化方向箭头
  let arr(a, b, paint: white, w: 0.5pt) = line(
    a, b, stroke: (paint: paint, thickness: w, cap: "round"),
    mark: (end: ">", fill: paint, scale: 0.36),
  )

  // (a) T 形磁钢盘式转子（源图照片 → 线稿：背铁圆盘 + 14 个扇形分块 + 螺栓孔）
  let disc-rotor(cx, cy, R) = {
    let n = 14
    let pp = 360deg / n
    let rOut = R
    let rMid = 0.79 * R
    let rIn = 0.55 * R
    let rHub = 0.72 * R
    // 转子背铁：外缘环 + 圆盘
    circle((cx, cy), radius: R + 0.05, fill: rgb("#c5c8c9"), stroke: st)
    circle((cx, cy), radius: R, fill: rgb("#e9e9e4"), stroke: stt)
    circle((cx, cy), radius: rHub, fill: rgb("#dcdcd6"), stroke: stt)
    circle((cx, cy), radius: rHub - 0.07, fill: none, stroke: thinn)
    // 14 个 T 形磁钢分块：外圈宽扇形 + 内侧窄颈（相邻块之间的 V 形槽）
    for i in range(0, n) {
      let a = 90deg - i * pp
      let h = 0.44 * pp
      let hn = 0.395 * pp
      let pts = (
        (rOut, a - h, "A"), (rOut, a + h, "L"),
        (rMid, a + h, "L"), (rMid, a + hn, "L"),
        (rIn, a + hn, "L"), (rIn, a - hn, "A"),
        (rMid, a - hn, "L"), (rMid, a - h, "L"),
      )
      line(..polar-path(cx, cy, pts), close: true, fill: rgb("#a8b1b8"), stroke: st)
    }
    // 中心轴孔 + 两圈螺栓孔（内 4 + 外 4，交错 45°）
    circle((cx, cy), radius: 0.24, fill: white, stroke: stt)
    for (rr, a0) in ((0.98, 45deg), (1.60, 0deg)) {
      for i in range(0, 4) {
        let a = a0 + i * 90deg
        let c = (cx + rr * calc.cos(a), cy + rr * calc.sin(a))
        circle(c, radius: 0.185, fill: white, stroke: stt)
        // 孔壁阴影：下半部一段细弧（示意孔深）
        line(
          ..polar-path(c.at(0), c.at(1), ((0.105, 205deg, "A"), (0.105, 335deg, "L"))),
          stroke: (paint: RHATCH, thickness: 0.55pt),
        )
      }
    }
  }

  // (b) Torus 机 + 准 Halbach 转子：轴向剖视
  //     1 stator core / 2 toroidal stator core / 3 rotor / 4 PM
  let torus-section(cx, cy) = {
    let RW = 4.0          // 半外径
    let discO = 3.15      // 上转子盘外表面
    let discI = 1.90      // 上转子盘内表面（贴合磁钢）
    let magI = 1.28       // 上磁钢内表面（面向气隙）
    let gapI = 0.96       // 上气隙内边界 = 绕组表面
    let windO = 0.92      // 环形绕组半厚
    let coreO = 0.50      // 定子铁芯半厚
    let bore = 0.86       // 环形定子内孔
    let coreO2 = 3.62     // 定子铁芯外径
    let windO2 = 3.92     // 绕组外表面
    let sh = 0.42         // 轴半宽

    // 轴：贯穿环形定子内孔（先画，被上下转子盘遮住两端）
    rect((cx - sh, cy - 3.55), (cx + sh, cy + 3.55), fill: SHAFT, stroke: st)
    let yy = cy - 3.4
    while yy < cy + 3.4 {
      line((cx - sh + 0.05, yy), (cx + sh - 0.05, yy + 0.12),
        stroke: (paint: rgb("#a9aeb1"), thickness: 0.35pt))
      yy += 0.24
    }

    // 转子叠片盘（浅灰 + 斜线）：上、下各一
    for s in (1, -1) {
      let ya = calc.min(cy + s * discI, cy + s * discO)
      let yb = calc.max(cy + s * discI, cy + s * discO)
      rect((cx - RW, ya), (cx + RW, yb), fill: ROTOR, stroke: st)
      hatch(cx - RW, ya, cx + RW, yb, step: 0.26,
        stroke: (paint: rgb("#b3babd"), thickness: 0.4pt))
    }

    // 准 Halbach 磁钢层：每极 1 块主磁钢（轴向充磁）+ 2 块侧磁钢（切向充磁）
    // 每个轴向面 6 极：轴孔两侧各 3 极（磁钢内缘让开转子中心孔）
    let nPole = 3
    let inner = 0.78
    let outer = RW - 0.05
    let p = (outer - inner) / nPole
    for s in (1, -1) {
      let y0 = cy + s * magI
      let y1 = cy + s * discI
      let ymid = (y0 + y1) / 2
      for q in (-1, 1) {
        for k in range(0, nPole) {
          let xk = q * (inner + (k + 0.5) * p)
          // 主磁钢（轴向充磁）
          rect((cx + xk - 0.26 * p, calc.min(y0, y1)), (cx + xk + 0.26 * p, calc.max(y0, y1)),
            fill: PM, stroke: stt)
          // 侧磁钢（切向充磁）
          for d in (-1, 1) {
            rect(
              (cx + xk + d * 0.30 * p, calc.min(y0, y1)),
              (cx + xk + d * 0.44 * p, calc.max(y0, y1)),
              fill: rgb("#7d858b"), stroke: stt,
            )
          }
          // 磁化方向：主磁钢轴向（上下两面反向、相邻极反向），侧磁钢切向
          arr(
            (cx + xk, ymid - s * 0.16), (cx + xk, ymid + s * 0.16),
            paint: white, w: 0.55pt,
          )
          for d in (-1, 1) {
            let xs = cx + xk + d * 0.37 * p
            let dir = if calc.rem(k - d + 2, 2) == 0 { 1 } else { -1 }
            arr((xs - dir * 0.10, ymid), (xs + dir * 0.10, ymid), paint: white, w: 0.5pt)
          }
        }
      }
    }

    // 环形定子：绕组（浅橙）+ 铁芯（灰，叠片内圈线）
    for s in (1, -1) {
      let xa = cx + s * bore
      let xb = cx + s * windO2
      // 环形绕组外轮廓
      rect(
        (calc.min(xa, xb), cy - windO), (calc.max(xa, xb), cy + windO),
        radius: 0.16, fill: WIND, stroke: (paint: WIND2, thickness: 0.6pt),
      )
      // 绕组线匝分界（上、下两个面）
      let x0 = cx + s * (bore + 0.12)
      let x1 = cx + s * (windO2 - 0.12)
      let step = 0.30
      let t = 0
      while t <= calc.abs(x1 - x0) + 0.01 {
        let xx = x0 + s * t
        line((xx, cy + coreO + 0.02), (xx, cy + windO - 0.05), stroke: (paint: WIND2, thickness: 0.4pt))
        line((xx, cy - windO + 0.05), (xx, cy - coreO - 0.02), stroke: (paint: WIND2, thickness: 0.4pt))
        t += step
      }
      // 定子铁芯
      let ca = cx + s * (bore + 0.30)
      let cb = cx + s * coreO2
      rect(
        (calc.min(ca, cb), cy - coreO), (calc.max(ca, cb), cy + coreO),
        fill: CORE, stroke: st,
      )
      // 叠片层（绕制的取向电工钢：嵌套细线）
      for k in (1, 2) {
        rect(
          (calc.min(ca, cb) + 0.13 * k, cy - coreO + 0.13 * k),
          (calc.max(ca, cb) - 0.13 * k, cy + coreO - 0.13 * k),
          fill: none, stroke: (paint: COREL, thickness: 0.35pt),
        )
      }
    }

    // 轴线（点划线，画在最上层）
    // 轴线（点划线）
    line((cx, cy - 3.85), (cx, cy + 3.85),
      stroke: (paint: INK, thickness: 0.35pt, dash: (3.2pt, 1.2pt, 0.6pt, 1.2pt)))
  }

  // (c) 准 Halbach 转子的极：两个相邻极并排，每极 5 块叠片扇形磁钢 + 磁化箭头
  //     分块尺寸按源图量取：中间块最宽（略超极轮廓圆）且最厚
  let halbach-rotor(cx, cy, r, dirs) = {
    // 每块厚度 / 半宽（相对极轮廓圆半径 r）
    let th = (0.183, 0.205, 0.251, 0.202, 0.186)
    let hw = (0.630, 0.955, 1.060, 0.955, 0.630)
    let tot = 0
    for i in range(0, 5) { tot += th.at(i) }
    let y = cy - tot * r
    for i in range(0, 5) {
      let hh = th.at(i) * r
      let w = hw.at(i) * r
      let yc = y + hh
      // 叠片扇形磁钢块：两端圆角的长方块，块内两条细线示意叠片
      rect(
        (cx - w, yc - hh), (cx + w, yc + hh), radius: 0.14 * hh,
        fill: BLUE, stroke: (paint: rgb("#2f4358"), thickness: 0.6pt),
      )
      // 叠片缝（扇形块内部的两条细线，示意叠片）
      for k in (-1, 1) {
        line((cx - w + 0.12, yc + hh * 0.34 * k), (cx + w - 0.12, yc + hh * 0.34 * k),
          stroke: (paint: rgb("#93a8c0"), thickness: 0.3pt))
      }
      // 磁化方向箭头（Halbach：切向 → 45° → 轴向 逐块旋转）
      let d = dirs.at(i)
      let ax = calc.abs(calc.sin(d))
      let len = if ax > 0.9 { 0.55 * hh } else if ax > 0.4 { 0.85 * hh } else { calc.min(0.30, 0.30 * w) }
      arr(
        (cx - len * calc.cos(d), yc - len * calc.sin(d)),
        (cx + len * calc.cos(d), yc + len * calc.sin(d)),
        paint: rgb("#20303f"), w: 0.7pt,
      )
      y += 2 * hh
    }
    // 极轮廓圆（压在磁钢块之上，与源图一致）
    circle((cx, cy), radius: r, fill: none, stroke: (paint: INK, thickness: 0.55pt))
  }

  // (d) 轴向磁通磁钢 / 斜极拓扑分类圆环
  let topology-wheel(cx, cy, R) = {
    let rh = 0.34 * R
    let r1 = rh + 0.10 * R
    let r2 = R - 0.12 * R
    // 转子外圆（双圈）+ 轮毂圆
    circle((cx, cy), radius: R, fill: none, stroke: (paint: SECT, thickness: 0.8pt))
    circle((cx, cy), radius: R - 0.085 * R, fill: none, stroke: (paint: SECT, thickness: 0.5pt))
    circle((cx, cy), radius: rh, fill: white, stroke: (paint: SECT, thickness: 0.8pt))
    circle((cx, cy), radius: 0.022 * R, fill: INK, stroke: none)

    let h = 17deg      // 磁钢半角
    let hd = 21deg     // 名义扇区（未斜极）半角
    // 8 个槽位（45° 均布）与磁钢形状代号
    let slots = (
      (78deg, "round"), (33deg, "tri"), (-12deg, "fan"), (-57deg, "classic"),
      (-102deg, "parallel"), (-147deg, "var"), (168deg, "trap"), (123deg, "dual"),
    )

    for (a, kind) in slots {
      // 名义扇区（虚线参考：两条穿过中心的径向线 + 内外弧）
      line((cx + 0.02 * R * calc.cos(a - hd), cy + 0.02 * R * calc.sin(a - hd)),
        (cx + R * calc.cos(a - hd), cy + R * calc.sin(a - hd)), stroke: dash)
      line((cx + 0.02 * R * calc.cos(a + hd), cy + 0.02 * R * calc.sin(a + hd)),
        (cx + R * calc.cos(a + hd), cy + R * calc.sin(a + hd)), stroke: dash)
      line(..polar-path(cx, cy, ((r1, a - hd, "A"), (r1, a + hd, "L"))), stroke: dash)
      line(..polar-path(cx, cy, ((r2, a - hd, "A"), (r2, a + hd, "L"))), stroke: dash)

      // 各拓扑的磁钢形状
      let pts = if kind == "fan" {
        ((r1, a - h, "A"), (r1, a + h, "L"), (r2, a + h, "A"), (r2, a - h, "L"))
      } else if kind == "tri" {
        // 三角斜极：一条长斜边把磁钢切成三角形
        ((r1, a - h, "A"), (r1, a + h, "L"), (r2, a + h - 19deg, "L"), (r2, a - h, "L"))
      } else if kind == "trap" {
        // 梯形斜极：两侧同时内收，外弧变窄
        ((r1, a - h, "A"), (r1, a + h, "L"), (r2, a + h - 7deg, "A"), (r2, a - h + 7deg, "L"))
      } else if kind == "dual" {
        // 双斜极：两侧反向外张，内弧变窄
        ((r1, a - h + 8deg, "A"), (r1, a + h - 8deg, "L"),
          (r2, a + h + 2deg, "A"), (r2, a - h - 2deg, "L"))
      } else if kind == "classic" {
        // 经典斜极：仅前缘斜切
        ((r1, a - h, "A"), (r1, a + h, "L"), (r2, a + h, "A"), (r2, a - h + 10deg, "L"))
      } else if kind == "parallel" {
        // 平行斜极：两条边平行斜置
        ((r1, a - h, "A"), (r1, a + h, "L"), (r2, a + h + 7deg, "A"), (r2, a - h + 7deg, "L"))
      } else if kind == "var" {
        // 弧形磁钢：外弧半径沿周向变化
        ((r1, a - h, "A"), (r1, a + h, "L"))
      } else {
        (())
      }

      if kind == "round" {
        let rc = 0.68 * R
        let rr = 0.31 * R
        circle((cx + rc * calc.cos(a), cy + rc * calc.sin(a)), radius: rr,
          fill: MAGD, stroke: (paint: rgb("#8d8f8a"), thickness: 0.6pt))
      } else if kind == "var" {
        // 手工采样外弧（半径沿周向起伏，示意 "variable magnet arc"）
        let out = ()
        let n = 10
        for k in range(0, n + 1) {
          let t = (a + h) - 2 * h * k / n
          let rr = r2 - 0.13 * R * (0.5 + 0.5 * calc.cos(2 * calc.pi * k / n))
          out.push((cx + rr * calc.cos(t), cy + rr * calc.sin(t)))
        }
        let inner = polar-path(cx, cy, ((r1, a - h, "A"), (r1, a + h, "L")))
        line(..(inner + out), close: true, fill: MAGD, stroke: (paint: rgb("#8d8f8a"), thickness: 0.6pt))
      } else {
        line(..polar-path(cx, cy, pts), close: true, fill: MAGD,
          stroke: (paint: rgb("#8d8f8a"), thickness: 0.6pt))
      }
    }
  }

  // 版面排布
  let AY = 5.72
  let BY = 5.60
  let CY = 5.72
  let DY = 5.72

  // (a) 盘式转子
  disc-rotor(4.72, AY, 3.30)

  // (b) Torus 剖视
  torus-section(14.0, BY)
  // 源图编号 1..4
  let num(x, y, s) = content((x, y), anchor: "center", text(size: 8.6pt, s))
  num(9.42, 6.62, [1])
  line((9.72, 6.55), (10.95, 5.90), stroke: (paint: INK, thickness: 0.45pt),
    mark: (end: ">", fill: INK, scale: 0.4))
  num(18.62, 6.62, [2])
  line((18.32, 6.55), (17.05, 5.90), stroke: (paint: INK, thickness: 0.45pt),
    mark: (end: ">", fill: INK, scale: 0.4))
  num(18.55, 8.62, [3])
  line((18.30, 8.52), (17.10, 8.20), stroke: (paint: INK, thickness: 0.45pt),
    mark: (end: ">", fill: INK, scale: 0.4))
  num(18.85, 7.62, [4])
  line((18.55, 7.55), (17.05, 7.20), stroke: (paint: INK, thickness: 0.45pt),
    mark: (end: ">", fill: INK, scale: 0.4))
  // 气隙 / 轴 / 磁钢阵列尺寸标注
  content((10.02, 6.72), anchor: "west", text(size: 6.2pt, style: "italic", [air gap]))
  content((17.80, 4.50), anchor: "east", text(size: 6.2pt, style: "italic", [air gap]))
  content((14.0, 9.42), anchor: "center", text(size: 6.6pt, [shaft]))
  // 源图编号图例
  content((14.0, 1.62), anchor: "center",
    text(size: 6.4pt, [1 stator core　　 2 toroidal stator core]))
  content((14.0, 1.24), anchor: "center",
    text(size: 6.4pt, [3 rotor　　 4 quasi-Halbach PM]))

  // (c) 准 Halbach 转子磁钢排布
  // 左极为 N 极（主磁钢向上），右极为 S 极（主磁钢向下），磁化方向逐块旋转 45°
  let magDirN = (180deg, 135deg, 90deg, 45deg, 0deg)
  let magDirS = (0deg, -45deg, -90deg, -135deg, 180deg)
  halbach-rotor(22.28, CY, 1.62, magDirN)
  halbach-rotor(26.62, CY, 1.62, magDirS)
  // 重复记号（源图左、右两侧的省略号，表示沿圆周重复）
  for dy in (-0.16, 0, 0.16) {
    circle((22.28 - 1.98, CY + dy), radius: 0.045, fill: INK, stroke: none)
    circle((26.62 + 1.98, CY + dy), radius: 0.045, fill: INK, stroke: none)
  }

  // (d) 拓扑分类圆环
  topology-wheel(33.62, DY, 2.98)
  // 引线标签（左 4 / 右 4，位置按源图）
  let lab(x, y, lines, anchor: "east") = {
    for (i, s) in lines.enumerate() {
      content((x, y - i * 0.34), anchor: anchor, text(size: 6.9pt, s))
    }
  }
  let lead(a, b, c) = line(a, ..c, stroke: (paint: INK, thickness: 0.45pt))
  let PW = 33.62
  let PY = DY
  let PR = 2.98
  // 左
  lab(PW - PR - 0.42, PY + 0.80 * PR, ([Round], [Magnet]))
  lead((PW - PR - 0.40, PY + 0.72 * PR), (PW + PR * calc.cos(78deg) * 0.80, PY + PR * calc.sin(78deg) * 0.80),
    ((PW - PR * 0.55, PY + 0.88 * PR),))
  lab(PW - PR - 0.42, PY + 0.30 * PR, ([Dual], [Skew]))
  lead((PW - PR - 0.40, PY + 0.26 * PR), (PW + PR * calc.cos(123deg) * 0.74, PY + PR * calc.sin(123deg) * 0.74),
    ((PW - PR * 0.62, PY + 0.34 * PR),))
  lab(PW - PR - 0.42, PY - 0.30 * PR, ([Trapezoidal], [skew]))
  lead((PW - PR - 0.40, PY - 0.30 * PR), (PW + PR * calc.cos(168deg) * 0.74, PY + PR * calc.sin(168deg) * 0.74),
    ((PW - PR * 0.60, PY - 0.34 * PR),))
  lab(PW - PR - 0.42, PY - 0.80 * PR, ([Variable], [magnet arc]))
  lead((PW - PR - 0.40, PY - 0.86 * PR), (PW + PR * calc.cos(-147deg) * 0.72, PY + PR * calc.sin(-147deg) * 0.72),
    ((PW - PR * 0.55, PY - 0.98 * PR),))
  // 右
  lab(PW + PR + 0.42, PY + 0.80 * PR, ([Triangular], [Skew]), anchor: "west")
  lead((PW + PR + 0.40, PY + 0.70 * PR), (PW + PR * calc.cos(33deg) * 0.80, PY + PR * calc.sin(33deg) * 0.80),
    ((PW + PR * 0.58, PY + 0.88 * PR),))
  lab(PW + PR + 0.42, PY + 0.26 * PR, ([Fan-shaped], [unskewed], [Magnet]), anchor: "west")
  lead((PW + PR + 0.40, PY + 0.30 * PR), (PW + PR * calc.cos(-12deg) * 0.80, PY + PR * calc.sin(-12deg) * 0.80),
    ((PW + PR * 0.62, PY + 0.36 * PR),))
  lab(PW + PR + 0.42, PY - 0.34 * PR, ([Classic], [Skew]), anchor: "west")
  lead((PW + PR + 0.40, PY - 0.36 * PR), (PW + PR * calc.cos(-57deg) * 0.76, PY + PR * calc.sin(-57deg) * 0.76),
    ((PW + PR * 0.60, PY - 0.40 * PR),))
  lab(PW + PR + 0.42, PY - 0.80 * PR, ([Parallel], [Skew]), anchor: "west")
  lead((PW + PR + 0.40, PY - 0.86 * PR), (PW + PR * calc.cos(-102deg) * 0.74, PY + PR * calc.sin(-102deg) * 0.74),
    ((PW + PR * 0.56, PY - 0.96 * PR),))

  // 子图编号
  let tag(x, y, s) = content((x, y), anchor: "center", text(size: 9.6pt, s))
  tag(4.72, 0.70, [(a)])
  tag(14.0, 0.70, [(b)])
  tag(24.29, 0.70, [(c)])
  tag(33.62, 0.70, [(d)])
})
