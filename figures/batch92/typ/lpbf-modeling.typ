// LPBF 计算建模三联图：多尺度模型 / 熔池模式 / 八种热源
// 源图：Advances in computational modeling for laser powder bed fusion
//       additive manufacturing（Additive Manufacturing, 2024）
//       Fig. 13 多尺度（single melt line → scan island → complete part）
//       Fig. 14 (a) Conduction / Keyhole 两种熔池模式  (b) 匙孔物理细节
//       Fig. 15 (a)–(h) 八种热源几何 + q = q0 f(z) 形式
//
// 版面：三排横排，横向 26cm、纵向约 22cm。
//   上排 —— 三块等轴测小体块，表示从 µm 到 cm 的尺度递进，
//            块之间用 ε^inh（固有应变）过渡箭头连接；
//   中排 —— 左 60% 两种熔池模式对照剖面，右 40% 匙孔物理细节；
//   下排 —— 4×2 网格，八种热源的旋转体线框 + 尺寸标注 + 强度公式。
// 全部线稿；激光、熔池、粉末用少量彩色与灰阶，其余黑线。
#set page(width: auto, height: auto, margin: 6pt)
#import "@preview/cetz:0.4.2": canvas, draw
#set text(font: ("Times New Roman", "Segoe UI"), size: 8pt, fill: rgb("#1c1c1c"))

#canvas({
  import draw: *

  // 配色与线型
  let INK = rgb("#1c1c1c")        // 主线条
  let GREY1 = rgb("#eceeef")      // 最浅：受光面 / 零件正面
  let GREY2 = rgb("#d3d5d7")      // 中间：粉末床 / 基体
  let GREY3 = rgb("#b9bcbe")      // 最深：背光侧面 / 粉末层
  let GREY4 = rgb("#9a9ea1")      // 细线、粉末颗粒轮廓
  let FRAME = rgb("#8c8c8c")      // 面板虚线框 / 尺寸引线
  let POOL_L = rgb("#f2a24a")     // 熔池外圈（浅橙）
  let POOL = rgb("#e2761c")       // 熔池（橙）
  let POOL_D = rgb("#b8480f")     // 熔池边缘（深橙）
  let RED = rgb("#b5161a")        // 匙孔熔池 / 深红
  let RED_L = rgb("#e8352a")      // 激光柱亮面
  let RED_D = rgb("#8c0d10")      // 激光柱暗边
  let YELL = rgb("#ffe14a")       // 激光束上段（黄）
  let BLUE = rgb("#1d5fbf")       // 扫描方向 / 热传导箭头
  let ORA = rgb("#e08a1e")        // 对流辐射波浪箭头

  let thin = (paint: INK, thickness: 0.5pt, cap: "round")
  let mid = (paint: INK, thickness: 0.6pt, cap: "round")
  let bold = (paint: INK, thickness: 0.75pt, cap: "round")
  let faint = (paint: FRAME, thickness: 0.35pt)
  let dotframe = (paint: FRAME, thickness: 0.5pt, dash: (2.4pt, 1.8pt))

  // 文字标签（anchor 控制对齐，避免长标签压到图元上）
  let lab(x, y, body, size: 8pt, anchor: "center", fill: INK, weight: "regular", style: "normal") = content(
    (x, y), anchor: anchor, text(size: size, fill: fill, weight: weight, style: style, body),
  )

  // 上排：等轴测投影
  // 三维坐标 x 向右、y 向上、z 指向纵深（屏幕上向右上方），
  // 每 +1 纵深在屏幕上右移 0.55、上移 0.32，即工程上常用的斜二测。
  let KX = 0.55
  let KY = 0.32
  let iso(x, y, z) = (x + KX * z, y + KY * z)

  // 三维折线 / 多边形：把三维点逐个投影后交给 line()
  let poly3(..p, close: false, fill: none, stroke: mid) = line(
    ..p.pos().map(q => iso(q.at(0), q.at(1), q.at(2))),
    close: close,
    fill: fill,
    stroke: stroke,
  )

  // 三维长方体：只画三个可见面（前面 z0、顶面 y1、右面 x1）
  let box3(x0, y0, z0, x1, y1, z1, front: GREY2, top: GREY1, side: GREY3, stroke: mid) = {
    poly3((x0, y0, z0), (x1, y0, z0), (x1, y1, z0), (x0, y1, z0), close: true, fill: front, stroke: stroke)
    poly3((x0, y1, z0), (x1, y1, z0), (x1, y1, z1), (x0, y1, z1), close: true, fill: top, stroke: stroke)
    poly3((x1, y0, z0), (x1, y0, z1), (x1, y1, z1), (x1, y1, z0), close: true, fill: side, stroke: stroke)
  }

  // 三维激光光锥：整段黄、下半段橙红（两层半透明填充近似“黄→红”渐变）
  let laser-cone3(xs, ytop, ybot, wtop, wbot, z) = {
    poly3(
      (xs - wtop, ytop, z), (xs + wtop, ytop, z), (xs + wbot, ybot, z), (xs - wbot, ybot, z),
      close: true, fill: YELL.transparentize(38%), stroke: (paint: ORA, thickness: 0.4pt),
    )
    let ym = ybot + (ytop - ybot) * 0.40
    let wm = wbot + (wtop - wbot) * 0.40
    poly3(
      (xs - wm, ym, z), (xs + wm, ym, z), (xs + wbot, ybot, z), (xs - wbot, ybot, z),
      close: true, fill: rgb("#e0561a").transparentize(22%), stroke: none,
    )
  }

  // 上排 · 第 1 块
  // 建模尺度 [µm]：一束激光在粉床上扫出一条熔道。
  // 这一块交代最小的计算单元——高斯光斑 r_ext^G、扫描速度 v_lsr 与熔池横截面。
  let scale-melt-line(ox, oy) = group({
    translate((ox, oy))
    let zc = 1.65    // 熔道所在的纵深位置
    let xs = 3.45    // 光斑中心的 x

    // 粉末床：一块薄板
    box3(0, 0, 0, 5.9, 0.5, 3.1, front: GREY2, top: rgb("#f1f2f3"), side: GREY3)

    // 熔道：顶面上的一条窄槽（浅橙打底 + 橙色芯部）
    poly3(
      (0.10, 0.5, zc - 0.17), (5.80, 0.5, zc - 0.17), (5.80, 0.5, zc + 0.17), (0.10, 0.5, zc + 0.17),
      close: true, fill: POOL_L, stroke: (paint: POOL_D, thickness: 0.4pt),
    )
    poly3(
      (0.10, 0.5, zc - 0.07), (5.80, 0.5, zc - 0.07), (5.80, 0.5, zc + 0.07), (0.10, 0.5, zc + 0.07),
      close: true, fill: POOL, stroke: none,
    )

    // 高斯光斑：屏幕上是一个扁椭圆（等轴测下圆面变成椭圆）
    circle(iso(xs, 0.52, zc), radius: (0.38, 0.16), fill: POOL_D, stroke: (paint: RED, thickness: 0.4pt))

    // 会聚激光束（自上方射向光斑）
    laser-cone3(xs, 2.02, 0.55, 0.40, 0.11, zc)

    // 光斑直径 r_ext^G 的双向标注
    line(iso(xs - 0.38, 0.84, zc), iso(xs + 0.38, 0.84, zc),
      stroke: (paint: RED_D, thickness: 0.4pt), mark: (start: ">", end: ">", fill: RED_D, scale: 0.3))
    lab(iso(xs - 0.62, 1.10, zc).at(0), iso(xs - 0.62, 1.10, zc).at(1), [$r_"ext"^G$], size: 7.4pt, anchor: "east")
    line(iso(xs - 0.46, 1.02, zc), iso(xs - 0.30, 0.90, zc), stroke: faint)

    // 扫描速度矢量 v_lsr（沿 +x）
    line(iso(xs - 0.10, 1.14, zc), iso(xs + 1.52, 1.14, zc),
      stroke: (paint: INK, thickness: 0.6pt), mark: (end: ">", fill: INK, scale: 0.36))
    lab(iso(xs + 1.86, 1.36, zc).at(0), iso(xs + 1.86, 1.36, zc).at(1), [$arrow(v)_"lsr"$], size: 8pt, anchor: "west")

    // 三维坐标系 x1 / x2 / x3（左上角，与源图同向）
    let O = iso(0.10, 1.18, 0.30)
    let (ox0, oy0) = (O.at(0), O.at(1))
    line(O, (ox0 + 1.18, oy0 + 0.04), stroke: thin, mark: (end: ">", fill: INK, scale: 0.34))
    line(O, (ox0 - 0.72, oy0 - 0.58), stroke: thin, mark: (end: ">", fill: INK, scale: 0.34))
    line(O, (ox0 + 0.02, oy0 - 1.02), stroke: thin, mark: (end: ">", fill: INK, scale: 0.34))
    lab(ox0 + 0.62, oy0 + 0.24, [$x_1$], size: 7.6pt)
    lab(ox0 - 0.92, oy0 - 0.66, [$x_2$], size: 7.6pt)
    lab(ox0 + 0.24, oy0 - 1.06, [$x_3$], size: 7.6pt)

    // 尺度说明（源图英文原文）
    lab(2.95, -1.02, [single melt line [$mu$m]], size: 8.4pt)
  })

  // 上排 · 第 2 块
  // 建模尺度 [mm]：一条扫描岛。往复扫描线按 hatch 间距并排，
  // 每一道都是第 1 块里那条熔线的平移复制——这是“熔道 → 扫描岛”的尺度升级。
  let scale-hatch(ox, oy) = group({
    translate((ox, oy))
    box3(0, 0, 0, 5.8, 1.15, 3.1, front: GREY2, top: rgb("#f3f4f5"), side: GREY3)

    // 往复扫描线：沿 x 走一道，端部折返，再按 hatch 间距在纵深方向平移
    let n = 8
    let za = 0.42
    let dz = 0.30
    for i in range(0, n) {
      let z = za + i * dz
      poly3((0.32, 1.152, z), (5.46, 1.152, z), stroke: (paint: POOL, thickness: 0.5pt))
      if i < n - 1 {
        let xe = if calc.even(i) { 5.46 } else { 0.32 }
        poly3((xe, 1.152, z), (xe, 1.152, z + dz), stroke: (paint: POOL_D, thickness: 0.5pt))
      }
    }

    // hatch 间距：相邻两道之间的距离（纵深方向的小标注）
    // 在右端头相邻两道之间量一个 hatch 间距
    let zs = za + 4 * dz
    line(iso(5.05, 1.152, zs), iso(5.05, 1.152, zs + dz),
      stroke: (paint: POOL_D, thickness: 0.4pt), mark: (start: ">", end: ">", fill: POOL_D, scale: 0.26))
    lab(5.95, 2.36, [hatch spacing], size: 7pt)
    line((5.86, 2.30), (5.62, 1.64), stroke: faint)

    // 扫描岛：顶面中部的一块凸台，示意“当前正在熔化的岛区”
    box3(2.35, 1.15, 1.10, 3.30, 1.52, 2.00, front: rgb("#e8eaeb"), top: rgb("#fbfbfb"), side: GREY3, stroke: bold)

    // v_lsr：岛区上方的扫描方向（源图为向左）
    line(iso(3.60, 1.86, 1.55), iso(1.75, 1.86, 1.55),
      stroke: (paint: INK, thickness: 0.6pt), mark: (end: ">", fill: INK, scale: 0.34))
    lab(iso(2.85, 2.10, 1.55).at(0), iso(2.85, 2.10, 1.55).at(1), [$arrow(v)_"lsr"$], size: 8pt, anchor: "south")

    // r_ext：光斑作用半径（引线指到凸台顶面）
    lab(1.92, 2.42, [$r_"ext"$], size: 7.6pt, anchor: "center")
    line((2.10, 2.34), (3.06, 2.06), stroke: faint)

    lab(2.95, -1.02, [scan island [mm]], size: 8.4pt)
  })

  // 上排 · 第 3 块
  // 建模尺度 [cm]：整个零件。内部竖线代表逐层堆积后留下的扫描道/柱状组织，
  // 说明“零件模型”是把成千上万个扫描岛按层叠起来的结果。
  let scale-part(ox, oy) = group({
    translate((ox, oy))
    box3(0, 0, 0, 4.9, 1.75, 2.55, front: rgb("#f4f5f6"), top: GREY1, side: GREY3)

    // 正面的竖向切片线（每一道扫描在剖面上留下一条竖线）
    for i in range(0, 33) {
      let x = 0.11 + i * 0.143
      poly3((x, 0.07, 0.004), (x, 1.68, 0.004), stroke: (paint: GREY4, thickness: 0.4pt))
    }
    // 顶面沿纵深方向的层线
    for i in range(0, 19) {
      let z = 0.07 + i * 0.132
      poly3((0.07, 1.753, z), (4.83, 1.753, z), stroke: (paint: GREY4, thickness: 0.4pt))
    }

    lab(2.55, -1.02, [complete part [cm]], size: 8.4pt)
  })

  // 上排三块尺度面板：循环套用同一个接口，只换 kind 与落位
  let scale-panel(kind, ox, oy) = {
    if kind == "melt" { scale-melt-line(ox,
      oy) } else if kind == "hatch" { scale-hatch(ox, oy) } else { scale-part(ox, oy) }
  }
  for (kind, ox, oy) in (("melt", 0.55, 18.45), ("hatch", 9.45, 18.30), ("part", 18.30, 18.15)) {
    scale-panel(kind, ox, oy)
  }

  lab(4.35, 21.62, [laser scan model], size: 9pt)
  lab(13.10, 21.62, [layer hatch model], size: 9pt)
  lab(21.50, 21.62, [part model], size: 9pt)

  // 块间说明：熔池宽/深与固液相温度（都属于第 1 块的熔池截面）
  lab(7.22, 21.34, [$d_w, d_d$], size: 8.6pt, anchor: "west")
  lab(7.22, 20.92, [$theta_"melt"$, $theta_"solid"$], size: 8.6pt, anchor: "west")
  // 两条弧形引线：由标签分别指向第 1 块的光斑与熔道
  bezier(
    (7.10, 21.26), (5.08, 19.86), (6.45, 21.15), (5.75, 20.15),
    stroke: (paint: INK, thickness: 0.45pt), mark: (end: ">", fill: INK, scale: 0.3),
  )
  bezier(
    (7.10, 20.82), (5.58, 19.56), (6.50, 20.62), (5.95, 19.85),
    stroke: (paint: INK, thickness: 0.45pt), mark: (end: ">", fill: INK, scale: 0.3),
  )

  // 块间过渡：ε^inh 固有应变（扫描岛 → 零件 的双向信息传递）
  lab(17.60, 21.30, [$epsilon^"inh"$], size: 9.4pt)
  bezier(
    (17.12, 20.62), (18.28, 20.86), (17.55, 21.02), (17.95, 20.98),
    stroke: (paint: INK, thickness: 0.5pt), mark: (end: ">", fill: INK, scale: 0.32),
  )
  bezier(
    (18.30, 20.42), (17.14, 20.20), (18.00, 20.06), (17.55, 20.06),
    stroke: (paint: INK, thickness: 0.5pt), mark: (end: ">", fill: INK, scale: 0.32),
  )

  // 中排：熔池物理
  // 这一排把上排“一条熔道”的截面放大：先对比两种熔池形态，
  // 再把匙孔内部的力与热流画清楚。

  // 虚线面板框（与源图一致：中排两块、下排一整块）
  rect((0.35, 9.50), (15.25, 16.60), fill: none, stroke: dotframe)
  rect((16.05, 9.50), (25.65, 16.60), fill: none, stroke: dotframe)
  rect((0.35, 0.18), (25.75, 8.78), fill: none, stroke: dotframe)

  // 2D 激光束：上宽下窄的锥形，两层半透明填充近似“黄 → 红”
  let laser-cone2(xs, ytop, ybot, wtop, wbot, stroke-col: ORA) = {
    line(
      (xs - wtop, ytop), (xs + wtop, ytop), (xs + wbot, ybot), (xs - wbot, ybot),
      close: true, fill: YELL.transparentize(35%), stroke: (paint: stroke-col, thickness: 0.4pt),
    )
    let ym = ybot + (ytop - ybot) * 0.42
    let wm = wbot + (wtop - wbot) * 0.42
    line(
      (xs - wm, ym), (xs + wm, ym), (xs + wbot, ybot), (xs - wbot, ybot),
      close: true, fill: rgb("#e0561a").transparentize(22%), stroke: none,
    )
  }

  // 熔池剖面：mode = "conduction"（浅碗）/ "keyhole"（深窄匙孔）
  // 半椭圆采样：a 从 0 到 π，得到“右端 → 池底 → 左端”的碗形边界
  let half-bowl(cx, ys, w, d, rev: false) = {
    let pts = ()
    for i in range(0, 25) {
      let a = calc.pi * i / 24
      pts.push((cx + w * calc.cos(a), ys - d * calc.sin(a)))
    }
    if rev { pts.rev() } else { pts }
  }

  let melt-pool(cx, ys, w, dep, mode) = {
    if mode == "conduction" {
      // 浅碗：外圈浅橙（热影响区）+ 内圈橙（熔池），宽度远大于深度
      line(..half-bowl(cx, ys, w, dep), close: true, fill: POOL_L, stroke: (paint: POOL_D, thickness: 0.5pt))
      line(..half-bowl(cx, ys, w * 0.66, dep * 0.70), close: true, fill: POOL, stroke: none)
    } else {
      // 匙孔：熔池被挤成 U 形窄带，中间是一条细长的匙孔腔
      line(
        ..half-bowl(cx, ys, w, dep), ..half-bowl(cx, ys, w * 0.50, dep * 0.88, rev: true),
        close: true, fill: POOL, stroke: (paint: POOL_D, thickness: 0.5pt),
      )
      line(..half-bowl(cx, ys, w * 0.50, dep * 0.88), close: true, fill: RED_D, stroke: none)
    }
  }

  // (a) Conduction / Keyhole 两种熔池模式
  let melt-mode-panel(ox, oy) = group({
    translate((ox, oy))
    lab(0.22, 6.88, [(a)], size: 10.5pt, anchor: "north-west")

    // 两块基体（Substrate）
    for xs in (1.55, 8.35) {
      rect((xs, 0.75), (xs + 5.05, 2.80), fill: GREY2, stroke: mid)
      line((xs, 2.80), (xs + 5.05, 2.80), stroke: bold)
      lab(xs + 0.26, 1.06, [Substrate], size: 8pt, anchor: "west")
    }

    // 左：传导模式——浅碗状熔池，光束停在表面
    laser-cone2(4.05, 5.95, 2.80, 0.62, 0.26)
    melt-pool(4.05, 2.80, 1.08, 0.82, "conduction")
    lab(4.05, 6.32, [Conduction mode], size: 8.8pt)

    // 右：匙孔模式——深窄匙孔，光束一直穿进腔内
    laser-cone2(10.85, 5.95, 2.80, 0.56, 0.28)
    melt-pool(10.85, 2.80, 1.18, 1.82, "keyhole")
    // 匙孔内继续下行的光束（底部收成圆弧状尖）
    line(
      (10.56, 2.79), (10.56, 1.42), (10.72, 1.16), (10.98, 1.16), (11.14, 1.42), (11.14, 2.79),
      close: true, fill: RED_L.transparentize(12%), stroke: (paint: RED_D, thickness: 0.4pt),
    )
    lab(10.85, 6.32, [Keyhole mode], size: 8.8pt)

    // Laser beam：一条标签引出两条引线，分别指向两束光
    lab(7.45, 4.62, [Laser beam], size: 8pt)
    line((6.55, 4.56), (4.42, 4.38), stroke: thin, mark: (end: ">", fill: INK, scale: 0.28))
    line((8.36, 4.56), (10.42, 4.38), stroke: thin, mark: (end: ">", fill: INK, scale: 0.28))

    // Melt pool：两个标签分列中间空档，各指一侧熔池
    lab(6.95, 3.78, [Melt pool], size: 8pt, anchor: "east")
    line((6.92, 3.48), (5.02, 2.88), stroke: thin, mark: (end: ">", fill: INK, scale: 0.28))
    lab(8.28, 3.78, [Melt pool], size: 8pt, anchor: "west")
    line((8.30, 3.48), (10.10, 2.88), stroke: thin, mark: (end: ">", fill: INK, scale: 0.28))
  })
  melt-mode-panel(0.35, 9.50)

  // (b) 匙孔物理细节
  // 这一块说明“匙孔里发生了什么”：反冲压力把熔池压出凹坑、
  // 金属蒸气逸出、粉末被卷入、热量向基体传导、表面辐射散热。
  let keyhole-detail(ox, oy) = group({
    translate((ox, oy))
    lab(0.20, 6.88, [(b)], size: 10.5pt, anchor: "north-west")

    let bx = 5.55        // 匙孔中心
    let ys = 2.45        // 基体上表面
    let yp = 2.92        // 粉末层顶面

    // 基体
    rect((0.75, 0.35), (9.45, ys), fill: GREY2, stroke: mid)

    // 熔池：画在基体之上、粉末层之下，因此只有匙孔口（粉末被冲开处）看得见，
    // 正好对应“熔池埋在粉层下面”的物理情形。顶面在孔口下凹，底部是深碗。
    let pool = (
      (3.55, 2.62), (4.30, 2.60), (4.85, 2.50), (5.55, 2.40), (6.25, 2.50), (6.80, 2.58), (7.30, 2.62),
      (7.02, 2.30), (6.52, 1.94), (6.02, 1.66), (5.55, 1.52), (5.05, 1.66), (4.55, 1.94), (4.05, 2.26), (3.62, 2.46),
    )
    line(..pool, close: true, fill: RED, stroke: (paint: RED_D, thickness: 0.5pt))

    // 粉末层：被匙孔冲开成左右两段，顶面起伏、靠孔口处向熔池塌陷
    let powder-strip(x0, x1, n, rim, side) = {
      let pts = ()
      for i in range(0, n + 1) {
        let x = x0 + (x1 - x0) * i / n
        let d = if side == "left" { rim - x } else { x - rim }
        let sag = if d < 0.80 { -0.28 * calc.cos(calc.pi * calc.max(0, d) / 1.60) } else { 0.0 }
        pts.push((x, yp + 0.06 * calc.cos(i * 1.9) + sag))
      }
      pts
    }
    line((0.75, ys), ..powder-strip(0.75, 3.95, 18, 3.95, "left"), (3.95, ys), close: true,
      fill: GREY3, stroke: (paint: INK, thickness: 0.5pt))
    line((7.05, ys), ..powder-strip(7.05, 9.45, 14, 7.05, "right"), (9.45, ys), close: true,
      fill: GREY3, stroke: (paint: INK, thickness: 0.5pt))
    // 粉末颗粒：循环撒圆（位置由固定正弦序列给出，匙孔口附近不放颗粒）
    for i in range(0, 38) {
      let x = 0.98 + i * 0.225
      if x < 3.85 or x > 7.15 {
        circle(
          (x, ys + 0.15 + 0.10 * calc.cos(i * 2.31)),
          radius: 0.072 + 0.018 * calc.cos(i * 1.13),
          fill: white, stroke: (paint: GREY4, thickness: 0.4pt),
        )
      }
    }

    // 激光柱：自上而下射入匙孔，并在孔底收成尖（= 匙孔腔）
    let key = (
      (bx - 0.52, 6.10), (bx + 0.52, 6.10), (bx + 0.52, 2.92), (bx + 0.62, 2.55),
      (bx + 0.26, 1.86), (bx, 1.58), (bx - 0.26, 1.86), (bx - 0.62, 2.55), (bx - 0.52, 2.92),
    )
    line(..key, close: true, fill: RED_L, stroke: (paint: RED_D, thickness: 0.5pt))
    lab(bx, 4.72, [Laser], size: 8pt, fill: white)
    // 光束入射轴线
    line((bx, 6.10), (bx, 5.80), stroke: (paint: RED_D, thickness: 0.4pt))

    // Scan direction：右上角蓝色粗箭头
    line((7.15, 5.60), (8.95, 5.60),
      stroke: (paint: BLUE, thickness: 2.6pt, cap: "butt"), mark: (end: ">", fill: BLUE, scale: 0.5))
    lab(8.05, 5.96, [Scan direction], size: 8pt)

    // Vapor：金属蒸气自匙孔口逸出
    bezier((6.14, 3.02), (7.28, 4.06), (6.62, 3.42), (7.10, 3.72),
      stroke: (paint: INK, thickness: 0.45pt), mark: (end: ">", fill: INK, scale: 0.28))
    bezier((4.98, 3.02), (4.62, 4.12), (5.05, 3.45), (4.72, 3.80),
      stroke: (paint: INK, thickness: 0.45pt), mark: (end: ">", fill: INK, scale: 0.28))
    lab(7.10, 4.48, [Vapor], size: 8pt, anchor: "west")
    lab(4.90, 4.48, [Vapor], size: 8pt, anchor: "south-east")

    // Recoil Pressure：反冲压力把熔体压向孔壁（孔内一串向下小箭头）
    lab(6.80, 3.30, [Recoil], size: 7.4pt, anchor: "west")
    lab(6.80, 3.04, [Pressure], size: 7.4pt, anchor: "west")
    line((6.74, 3.00), (5.95, 2.56), stroke: faint)
    for k in (0, 1, 2) {
      let xx = 5.74 + k * 0.11
      line((xx, 2.56), (xx - 0.04, 2.16),
        stroke: (paint: INK, thickness: 0.45pt), mark: (end: ">", fill: INK, scale: 0.26))
    }

    // 熔池标签（压在红色熔体上，白字斜排）
    content((4.50, 2.34), anchor: "center", angle: -14deg, text(size: 6.8pt, fill: white, style: "italic", [Melt pool]))

    // pores：匙孔外壁卷入的气孔
    for (px_, py_, rr) in ((2.05, 2.14, 0.12), (2.48, 1.94, 0.10), (2.86, 2.20, 0.11), (2.28, 1.72, 0.09)) {
      circle((px_, py_), radius: (rr, rr * 0.62), fill: rgb("#f2f2f2"), stroke: (paint: INK, thickness: 0.45pt))
    }
    lab(0.98, 2.18, [pores], size: 8pt, anchor: "west")
    line((1.70, 2.14), (2.00, 2.15), stroke: faint)

    // Heat conduction：热量自熔池沿匙孔壁向基体深处传导（蓝箭头 + 斜排标签）
    for k in (0, 1, 2) {
      line((4.62 - k * 0.18, 1.92 - k * 0.05), (3.92 - k * 0.22, 1.10 - k * 0.06),
        stroke: (paint: BLUE, thickness: 0.6pt), mark: (end: ">", fill: BLUE, scale: 0.3))
    }
    content((2.55, 1.28), anchor: "center", angle: -40deg, text(size: 7.6pt, [Heat conduction]))

    // Convection Radiation：表面对流与辐射散热（橙色波浪箭头）
    let wave(a, b, amp) = {
      let (x0, y0) = (a.at(0), a.at(1))
      let (x1, y1) = (b.at(0), b.at(1))
      let dx = x1 - x0
      let dy = y1 - y0
      let len = calc.sqrt(dx * dx + dy * dy)
      let nx = -dy / len * amp
      let ny = dx / len * amp
      bezier(
        a, b, (x0 + dx * 0.33 + nx, y0 + dy * 0.33 + ny), (x0 + dx * 0.66 - nx, y0 + dy * 0.66 - ny),
        stroke: (paint: ORA, thickness: 0.6pt), mark: (end: ">", fill: ORA, scale: 0.3),
      )
    }
    wave((3.45, 3.05), (4.02, 4.16), 0.16)
    wave((3.78, 2.96), (4.34, 4.04), 0.16)
    content((2.32, 3.62), anchor: "center", angle: 30deg,
      text(size: 7.4pt, fill: ORA, style: "italic")[Convection #linebreak() Radiation])

    // powder / Substrate 标签
    lab(8.45, 3.60, [powder], size: 8pt, anchor: "east")
    line((8.42, 3.54), (7.80, 3.00), stroke: faint)
    lab(8.55, 0.68, [Substrate], size: 8pt, anchor: "east")
  })
  keyhole-detail(16.05, 9.50)

  // 下排：八种热源
  // 每种热源都是绕竖直轴旋转的线框体，差别只在“母线”形状：
  // 高斯旋转体尖顶、椭球圆顶、双椭球前后不对称、锥形、双锥等。
  // 因此用一张 kind 表 + 一个轮廓函数，循环生成八个面板。
  let PW = 5.95          // 面板宽
  let PH = 3.90          // 面板高
  let PX(i) = 0.50 + i * 6.50
  let PY1 = 4.75         // 上排（(a)–(d)）底边
  let PY2 = 0.30         // 下排（(e)–(h)）底边

  // 底椭圆 / 纬线椭圆：整圈实线或虚线的采样画法
  let ellipse-pts(cx, cy, rx, ry) = {
    let pts = ()
    for i in range(0, 49) {
      let a = 2 * calc.pi * i / 48
      pts.push((cx + rx * calc.cos(a), cy + ry * calc.sin(a)))
    }
    pts
  }

  // 尺寸标注：水平（半径）与竖直（高度）两种，两端箭头 + 引线
  let dim-h(x0, x1, y, label, above: true) = {
    line((x0, y), (x1, y), stroke: (paint: INK, thickness: 0.4pt),
      mark: (start: ">", end: ">", fill: INK, scale: 0.3))
    content(((x0 + x1) / 2, y + (if above { 0.18 } else { -0.18 })),
      anchor: if above { "south" } else { "north" }, text(size: 6.4pt, style: "italic", label))
  }
  let dim-v(x, y0, y1, label) = {
    line((x, y0), (x, y1), stroke: (paint: INK, thickness: 0.4pt),
      mark: (start: ">", end: ">", fill: INK, scale: 0.3))
    content((x + 0.14, (y0 + y1) / 2), anchor: "west", text(size: 6.4pt, style: "italic", label))
  }
  // 尺寸引线（自图形最宽处引到标注线）
  let ext(a, b) = line(a, b, stroke: faint)

  // 旋转体线框：母线 prof(t) 给出 t∈[0,1]（自底到顶）处的半宽比例
  let body(prof, cx, yb, rb, hh, ry) = {
    let N = 24
    let right = ()
    let left = ()
    for i in range(0, N + 1) {
      let t = i / N
      let w = rb * prof(t)
      right.push((cx + w, yb + hh * t))
      left.push((cx - w, yb + hh * t))
    }
    // 底部前半椭圆（自右端经最低点回到左端）
    let front = ()
    for i in range(0, 13) {
      let a = calc.pi * i / 12
      front.push((cx + rb * calc.cos(a), yb - ry * calc.sin(a)))
    }
    line(..right, ..left.rev(), ..front, close: true, fill: none, stroke: mid)
    // 底部后半椭圆（虚线，表示被遮住的一侧）
    let back = ()
    for i in range(1, 12) {
      let a = calc.pi * i / 12
      back.push((cx - rb * calc.cos(a), yb + ry * calc.sin(a)))
    }
    line((cx + rb, yb), ..back, (cx - rb, yb),
      stroke: (paint: INK, thickness: 0.4pt, dash: (1.3pt, 1.1pt)))
    // 一条纬线：前半实线 + 后半虚线，交代立体形状
    let t1 = 0.50
    let w1 = rb * prof(t1)
    let y1 = yb + hh * t1
    line(..ellipse-pts(cx, y1, w1, ry * w1 / rb), close: true,
      stroke: (paint: INK, thickness: 0.4pt, dash: (1.3pt, 1.1pt)))
    let fr = ()
    for i in range(0, 25) {
      let a = calc.pi * i / 24
      fr.push((cx + w1 * calc.cos(a), y1 - ry * w1 / rb * calc.sin(a)))
    }
    line(..fr, stroke: (paint: INK, thickness: 0.45pt))
    // 顶端不收尖的形体（双锥 / 截锥）补一个顶面椭圆
    let wt = rb * prof(1)
    if wt > 0.06 {
      line(..ellipse-pts(cx, yb + hh, wt, ry * wt / rb), close: true,
        stroke: (paint: INK, thickness: 0.45pt))
    }
    // 旋转轴（点划线）
    line((cx, yb - ry - 0.12), (cx, yb + hh + 0.14),
      stroke: (paint: INK, thickness: 0.35pt, dash: (2.6pt, 1pt, 0.5pt, 1pt)))
  }

  // 单个热源面板
  let heat-source(kind, px, py, tag, formula: none, prof: none) = {
    let cx = px + 2.30
    let yb = py + 0.70
    let rb = 0.90
    let hh = 1.85
    let ry = 0.24

    lab(px + 0.16, py + PH - 0.26, tag, size: 9.5pt, anchor: "north-west")

    if kind == "double-ellipsoid" {
      // (c) 双椭球：前后两半椭球不对称，沿扫描方向前短后长
      let (af, ar, cc, bb) = (1.28, 1.00, 0.78, 0.52)
      let yc = yb + 0.62
      let up = ()
      let dn = ()
      for i in range(0, 21) {
        let t = i / 20
        let x = cx - ar + ar * t
        let y = yc + cc * calc.sqrt(calc.max(0, 1 - ((x - cx) / ar) * ((x - cx) / ar)))
        up.push((x, y))
        dn.push((x, 2 * yc - y))
      }
      for i in range(0, 21) {
        let t = i / 20
        let x = cx + af * t
        let y = yc + cc * calc.sqrt(calc.max(0, 1 - ((x - cx) / af) * ((x - cx) / af)))
        up.push((x, y))
      }
      for i in range(0, 21) {
        let t = 1 - i / 20
        let x = cx + af * t
        let y = yc + cc * calc.sqrt(calc.max(0, 1 - ((x - cx) / af) * ((x - cx) / af)))
        dn.push((x, 2 * yc - y))
      }
      line(..up, ..dn.rev(), close: true, fill: rgb("#f5f6f6"), stroke: mid)
      // 赤道线（点划线）+ 前端截面椭圆（表示半宽 b）
      line((cx - ar - 0.10, yc), (cx + af + 0.10, yc),
        stroke: (paint: INK, thickness: 0.4pt, dash: (2.6pt, 1pt, 0.5pt, 1pt)))
      line(..ellipse-pts(cx + af, yc, 0.16, bb * 0.42), close: true, stroke: (paint: INK, thickness: 0.45pt))
      line((cx, yc - cc - 0.12), (cx, yc + cc + 0.14),
        stroke: (paint: INK, thickness: 0.35pt, dash: (2.6pt, 1pt, 0.5pt, 1pt)))
      // 标注 a_r / a_f / b / c
      ext((cx - ar, yc), (cx - ar, yc + cc + 0.42))
      ext((cx + af, yc), (cx + af, yc + cc + 0.42))
      ext((cx, yc + cc), (cx, yc + cc + 0.42))
      dim-h(cx - ar, cx, yc + cc + 0.34, [$a_r$])
      dim-h(cx, cx + af, yc + cc + 0.34, [$a_f$])
      dim-v(cx + af + 0.28, yc, yc + cc, [$c$])
      content((cx + af + 0.42, yc + 0.10), anchor: "west", text(size: 6.4pt, style: "italic", [$b$]))
      line((cx + af + 0.40, yc + 0.06), (cx + af + 0.12, yc - 0.06), stroke: faint)
    } else if kind == "cone" {
      // (d) 锥形热源：向下张开的截锥（r_l → r_i），内部再画一个虚线锥
      let (rt, rbi, rw) = (0.48, 0.88, 0.26)
      let yt = yb + hh
      line((cx - rt, yt), (cx - rbi, yb), (cx + rbi, yb), (cx + rt, yt), stroke: mid)
      line(..ellipse-pts(cx, yt, rt, ry * rt / rb), close: true, stroke: (paint: INK, thickness: 0.5pt))
      line(..ellipse-pts(cx, yb, rbi, ry * rbi / rb), close: true, stroke: (paint: INK, thickness: 0.5pt))
      // 内部锥（虚线）：激光能量在锥体内的分布边界
      line((cx - rw, yt), (cx, yb + 0.10), (cx + rw, yt),
        stroke: (paint: INK, thickness: 0.4pt, dash: (1.6pt, 1.2pt)))
      line((cx, yb - ry - 0.12), (cx, yt + 0.16),
        stroke: (paint: INK, thickness: 0.35pt, dash: (2.6pt, 1pt, 0.5pt, 1pt)))
      // 标注 r_l / r_0 / r_i / H
      dim-h(cx - rt, cx + rt, yt + 0.34, [$r_l$])
      dim-h(cx - rbi, cx + rbi, yb - 0.36, [$r_i$], above: false)
      ext((cx + rbi, yb), (cx + rbi, yb - 0.36))
      dim-v(cx + 1.22, yb, yt, [$H$])
      ext((cx + rbi, yb), (cx + 1.22, yb))
    } else {
      // 其余六种都是旋转体，只换母线
      body(prof, cx, yb, rb, hh, ry)

      // r_l：最宽直径（自底部最宽处引线到顶部标注）
      ext((cx - rb, yb), (cx - rb, yb + hh + 0.46))
      ext((cx + rb, yb), (cx + rb, yb + hh + 0.46))
      dim-h(cx - rb, cx + rb, yb + hh + 0.40, [$r_l$])

      if formula == none {
        // (a)(b)：标出穿透深度 r_d
        dim-v(cx + 0.22, yb, yb + hh * 0.62, [$r_d$])
      } else {
        // (e)–(h)：标出峰值 q0 与基面 q，并在底部写强度公式
        dim-v(cx + rb + 0.42, yb + hh * 0.55, yb + hh, [$q_0$])
        dim-v(cx + rb + 0.42, yb, yb + hh * 0.55, [$q$])
        content((px + PW / 2, py + 0.20), anchor: "center", text(size: 8.4pt, formula))
      }
    }
  }

  // 八种热源：kind 表 + 母线表，循环生成
  // 母线 prof(t)：t 为自底向顶的相对高度，返回该高度处的半宽比例
  let kinds = (
    (tag: [(a)], kind: "gauss", formula: none,
      prof: t => calc.pow(1 - t, 1.50) * (1 + 0.35 * t)),
    (tag: [(b)], kind: "ellipsoid", formula: none,
      prof: t => calc.pow(calc.max(0, 1 - t * t), 0.45)),
    (tag: [(c)], kind: "double-ellipsoid", formula: none, prof: t => 1),
    (tag: [(d)], kind: "cone", formula: none, prof: t => 1),
    (tag: [(e)], kind: "bell", formula: [$q = q_0 f_1 (z)$],
      prof: t => calc.pow(1 - t, 0.55) * (1 + 0.10 * t)),
    (tag: [(f)], kind: "bell", formula: [$q = q_0 f_2 (z)$],
      prof: t => (1 - 0.18 * calc.sin(calc.pi * t)) * calc.pow(calc.max(0, 1 - calc.pow(t, 6)), 0.5)),
    (tag: [(g)], kind: "double-cone", formula: [$q = q_0 f_3 (z)$],
      prof: t => 0.24 + 0.76 * calc.abs(calc.cos(calc.pi * t))),
    (tag: [(h)], kind: "capped", formula: [$q = q_0 f_4 (z)$],
      prof: t => if t < 0.58 { 1 - 0.30 * t } else { 0.826 * (1 - 0.62 * (t - 0.58) / 0.42) }),
  )

  for (i, k) in kinds.enumerate() {
    let col = calc.rem(i, 4)
    let row = calc.div-euclid(i, 4)
    let py = if row == 0 { PY1 } else { PY2 }
    heat-source(k.kind, PX(col), py, k.tag, formula: k.formula, prof: k.prof)
  }
}, length: 1cm)
