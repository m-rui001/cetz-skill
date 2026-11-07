// 编译效果：上下两面板共享同一放电室。左侧 Propellant Storage 圆角盒经 Flow Control 的 V 阀接入
// 斜切喷口；腔体双色灰、深蓝边，内有 Propellant Atoms 虚线箭头与 Ionization 星芒，右侧双虚线网格
// 引出三条虚线离子束，下方花括号标 Ionization Chamber / Grids，右下 Neutralizer 斜棒与 e⁻。
// (a) 加 Hollow Cathode 弹头与 Magnet Ring 菱形；(b) 换 Electromagnetic Coils 三圆组与 P 激励电源圆。
// 来源：Propulsion Technologies for CubeSats: Review, Aerospace 2024, 11(7), 502, Figure 22. DOI 10.3390/aerospace11070502.
#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

#canvas(length: 1cm, {
  import draw: *
  // 颜色与通用样式：深蓝描边、星芒灰、中性化器蓝、箭头与引线
  let ink = rgb("#1f3864")
  let body = rgb("#c9c9c9")
  let mouth = rgb("#ececec")
  let star = rgb("#a6a6a6")
  let neu = rgb("#4472c4").darken(20%)
  let head = (end: ">", fill: black)
  let lab(at, t, anchor: "center") = content(at, anchor: anchor, text(weight: "bold", t))
  let leader(a, b) = line(a, b, stroke: .8pt, mark: (end: ">", fill: black, length: .22, width: .16))
  // 腔体地标：喷口 mx/mh、斜切 fx、半高 H、右壁 rx、双色分界 sx、罩壳左右 el/er、磁环/线圈横标 mg
  let (mx, mh, fx, H, rx, sx) = (4.2, .8, 5.2, 2.1, 10.6, 6.0)
  let (el, er, mg) = (3.2, 12.7, 8.4)
  // 腔体：整体灰 + 左浅灰条 + 深蓝轮廓（喷口边虚线）
  let shell() = {
    let pts = ((mx, mh), (fx, H), (rx, H), (rx, -H), (fx, -H), (mx, -mh))
    line(..pts, close: true, fill: body, stroke: none)
    line((mx, mh), (fx, H), (sx, H), (sx, -H), (fx, -H), (mx, -mh), close: true, fill: mouth, stroke: none)
    line(..pts, stroke: (paint: ink, thickness: 1.2pt))
    line((mx, mh), (mx, -mh), stroke: (paint: ink, dash: "dashed"))
  }
  // 电离星芒：24 个角度交替长短半径循环成尖星
  let burst(c) = {
    let pts = ()
    for i in range(24) {
      let r = if calc.odd(i) { .5 } else { 1.0 }
      let a = i * 15deg + 8deg
      pts.push((c.at(0) + r * calc.cos(a), c.at(1) + r * calc.sin(a)))
    }
    line(..pts, close: true, fill: star, stroke: none)
  }
  // 双网格：两个竖直虚线矩形
  let grids() = {
    for g in (10.85, 11.15) {
      rect((g, -2.6), (g + .22, 2.6), stroke: (dash: "dashed", thickness: 1pt))
    }
  }
  // 离子束：三条水平虚线箭头
  let beams() = {
    for y in (1.3, 0, -1.3) {
      line((rx, y), (er, y), stroke: (dash: "dashed", thickness: 1.5pt), mark: head)
    }
  }
  // 下花括号标签：两端上钩、中间下钩
  let brace(x0, x1, y, t) = {
    let m = (x0 + x1) / 2
    line((x0, y + .15), (x0, y), (m, y), (m, y - .15), (m, y), (x1, y), (x1, y + .15), stroke: .8pt)
    lab((m, y - .3), t, anchor: "north")
  }
  // 单面板：dy 纵向平移，mode 切换 (a) 磁环 / (b) 线圈
  let panel(dy, mode) = group({
    translate(y: dy)
    // 虚线罩壳与左侧供给：储存盒、V 阀、Flow Control 引线
    rect((el, -3.55), (er, 3.0), stroke: (paint: ink, dash: "dashed"))
    rect((.45, -1.05), (2.95, 1.05), radius: .3, fill: rgb("#d9d9d9"), stroke: 1pt)
    lab((1.7, 0), [Propellant #linebreak() Storage])
    line((2.95, 0), (3.12, 0), stroke: 1pt)
    circle((3.5, 0), radius: .38, fill: white, stroke: 1pt)
    lab((3.5, 0), [V])
    lab((2.9, 1.4), [Flow Control], anchor: "south")
    leader((3.2, 1.25), (3.42, .45))
    shell()
    // 喷口：上下虚线箭头 + Propellant Atoms 标签
    for y in (.55, -.55) {
      line((mx + .05, y), (mx + .7, y), stroke: (dash: "dashed", thickness: 1.2pt), mark: head)
      lab((mx + .9, y), [Propellant Atoms], anchor: "west")
    }
    if mode == "a" {
      // 空心阴极：圆头弹形（角度循环推顶点）+ 点线箭头 + 引线标签
      let (cr, tc) = (.28, 5.6)
      let pts = ((mx, -cr), (tc, -cr))
      for i in range(1, 6) {
        let a = -90deg + i * 30deg
        pts.push((tc + cr * calc.cos(a), cr * calc.sin(a)))
      }
      pts += ((tc, cr), (mx, cr))
      line(..pts, close: true, fill: star, stroke: (paint: ink, thickness: 1pt))
      line((tc + cr + .1, 0), (7.6, 0), stroke: (dash: "dotted", thickness: 1.4pt), mark: head)
      lab((3.0, -1.9), [Hollow Cathode], anchor: "north")
      leader((3.9, -1.6), (5.2, -.2))
      // 磁环：上下菱形 + 引线标签
      for y in (H, -H) {
        line((mg - .75, y), (mg, y + .22), (mg + .75, y), (mg, y - .22), close: true, fill: star, stroke: (paint: ink, thickness: 1pt))
      }
      lab((9.4, 2.55), [Magnet Ring], anchor: "south-west")
      leader((9.6, 2.45), (8.6, 2.3))
    } else {
      // 电磁线圈：上下各三圆 + 引线标签；中部点线箭头
      for y in (H, -H) {
        for x in (mg - 1.2, mg - .6, mg) {
          circle((x, y), radius: .24, fill: star, stroke: (paint: ink, thickness: 1pt))
        }
      }
      lab((8.3, 2.55), [Electromagnetic Coils], anchor: "south")
      leader((9.0, 2.45), (8.55, 2.32))
      line((6.1, 0), (7.6, 0), stroke: (dash: "dotted", thickness: 1.4pt), mark: head)
      // 激励电源：左下 P 圆 + 两行引线标签
      circle((fx, -H), radius: .38, fill: white, stroke: 1pt)
      lab((fx, -H), [P])
      lab((3.3, -2.85), [Excitation #linebreak() Power Supply])
      leader((4.2, -2.6), (4.9, -2.2))
    }
    // 星芒与 Ionization 标签、网格、离子束及束标签
    burst((9.1, 0))
    lab((9.1, 0), [Ionization])
    grids()
    beams()
    lab((er + .25, 0), [Electrostatically #linebreak() Accelerated Ion Beam], anchor: "west")
    // 下花括号：Ionization Chamber 与 Grids
    brace(5.7, rx, -H - .34, [Ionization Chamber])
    brace(10.85, 11.37, -2.72, [Grids])
    // 中性化器：45° 斜棒（方向向量推四角）+ e⁻ 引线箭头
    let (nx, ny) = (12.0, -2.1)
    let (d, p) = ((calc.cos(45deg), calc.sin(45deg)), (-calc.sin(45deg), calc.cos(45deg)))
    let bar = ()
    for (sl, sw) in ((.5, .1), (.5, -.1), (-.5, -.1), (-.5, .1)) {
      bar.push((nx + sl * d.at(0) + sw * p.at(0), ny + sl * d.at(1) + sw * p.at(1)))
    }
    line(..bar, close: true, fill: neu, stroke: (paint: ink, thickness: .8pt))
    lab((nx + .4, ny - .05), [Neutralizer], anchor: "west")
    leader((12.2, -1.75), (12.0, -1.35))
    content((11.9, -1.5), anchor: "east", text(size: 12pt, $e^-$))
    // 面板字母
    content((7.6, -4.35), text(size: 13pt, weight: "bold", "(" + mode + ")"))
  })
  // 两面板上下堆叠：(a) 上、(b) 下
  for (dy, mode) in ((0, "a"), (-9.2, "b")) { panel(dy, mode) }
})