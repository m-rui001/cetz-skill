// EUV 镜面干涉光刻（MIL, Mirror Interference Lithography）光束线
// 源图：Extreme ultraviolet lithography reaches 5 nm resolution
//       (arXiv:2402.18234, 2024)  Figure 1 "Mirror interference lithography"
//
// 版面（约 22.5 cm × 9.6 cm，横排）：
//   (a) 上排左：XIL-II 光束线
//       波荡器(Undulator) → 椭圆柱收集镜 → 三片平板镜(Mirrors) → 针孔(Pinhole)
//       → MIL 器件（虚线圆）；圆下方小图：EUV-IL 掩模处的交叉光路（虚线圆）
//   (b) 右侧：掠入射双镜干涉原理（λ、d、α、2α、S、E₁/E₂、x-z 轴、周期公式）
//   (c) 左下：MIL 器件（源图为实物照片，这里改画线稿）+ 硬币轮廓作比例
//
// 光路约定：EUV 光 = 紫色半透明光锥（边缘 0.5pt）+ 主光轴虚线；
//   结构件 = 0.55–0.8pt 黑色线稿；反射镜 = 蓝色；针孔 = 灰绿；
//   掩模/抗蚀剂 = 暗红。所有坐标由主光轴高度 AY 与干涉场中心 CX 派生。
#set page(width: auto, height: auto, margin: 6pt)
#import "@preview/cetz:0.4.2": canvas, draw
#set text(font: ("Segoe UI", "Arial"), size: 7pt)

#canvas({
  import draw: *

  // 配色与线型
  let INK = rgb("#1b1b1b") // 结构线墨色
  let PURPLE = rgb("#6f5488") // 光锥边缘线
  let PFILL = rgb("#8a6ba6") // 光锥填充（透明后叠加处自然加深）
  let MIRRORF = rgb("#7181c9") // 反射镜蓝
  let TEAL = rgb("#a4b9ae") // 针孔（灰绿）
  let MAGNET = rgb("#c3c3c3") // 波荡器磁块灰
  let RED = rgb("#9c3a34") // 抗蚀剂 / 掩模层（暗红）
  let METAL = rgb("#dbd9d4") // (c) 金属件的浅灰
  let METAL2 = rgb("#c8c5bf") // (c) 金属件的深灰（台阶面）
  let HINT = rgb("#7d7d7d") // 辅助线 / 引线

  let THIN = (paint: INK, thickness: 0.55pt)
  let MAIN = (paint: INK, thickness: 0.7pt)
  let BOLD = (paint: INK, thickness: 0.8pt)
  let BEAM-EDGE = (paint: PURPLE, thickness: 0.5pt)
  let AXIS-DASH = (paint: INK, thickness: 0.5pt, dash: (2.2pt, 1.6pt))

  // 标签：统一字号，可指定锚点
  let lbl(pos, body, anchor: "center", size: 7pt) = content(pos, anchor: anchor, text(size: size, body))

  // 圆弧采样：以 (cx,cy) 为心、半径 r，从 a0 到 a1（逆时针）取 n+1 个点
  // 用于把 (c) 的机械件轮廓拼成闭合折线（CeTZ 无布尔运算，用采样点拼）
  let arc-pts(cx, cy, r, a0, a1, n) = range(0, n + 1).map(i => {
    let a = a0 + (a1 - a0) * (i / n)
    (cx + r * calc.cos(a), cy + r * calc.sin(a))
  })

  // 圆心定位的圆弧：CeTZ 的 arc 是从"起点"开始画（起点 = 圆心 + r·方向），
  // 这里把 (圆心, 半径, 起止角) 换算成 arc 需要的起点，避免把弧画歪
  let arc-at(cx, cy, r, a0, a1, stroke: (paint: INK, thickness: 0.55pt), mark: none) = arc(
    (cx + r * calc.cos(a0), cy + r * calc.sin(a0)),
    start: a0,
    stop: a1,
    radius: r,
    stroke: stroke,
    mark: mark,
  )

  // (a) 光束线：元件函数

  // 波荡器：上下两排交替极性的磁块，中缝为电子束通道。
  // 上下两排刻意错开一块，对应"沿束方向交替排列"的磁极序列。
  let undulator(x, y, n: 6, bw: 0.40, bh: 0.56, gap: 0.24) = {
    for i in range(n) {
      let x0 = x + i * bw
      // 上排：偶数块为白、奇数块为灰
      rect(
        (x0, y + gap / 2),
        (x0 + bw, y + gap / 2 + bh),
        fill: if calc.odd(i) { MAGNET } else { white },
        stroke: (paint: INK, thickness: 0.55pt),
      )
      // 下排：与上排反相
      rect(
        (x0, y - gap / 2 - bh),
        (x0 + bw, y - gap / 2),
        fill: if calc.odd(i) { white } else { MAGNET },
        stroke: (paint: INK, thickness: 0.55pt),
      )
    }
  }

  // EUV 光锥：从 (x0,y0) 处宽 w0 张到 (x1,y1) 处宽 w1 的四边形。
  // 紫色半透明填充 + 0.5pt 边缘线；主光轴虚线统一在图外单独绘制。
  let beam-cone(x0, y0, x1, y1, w0, w1) = {
    line(
      (x0, y0 - w0 / 2),
      (x1, y1 - w1 / 2),
      (x1, y1 + w1 / 2),
      (x0, y0 + w0 / 2),
      close: true,
      fill: PFILL.transparentize(55%),
      stroke: BEAM-EDGE,
    )
  }

  // 椭圆柱收集镜：竖长椭圆（源图为椭圆柱面镜的正视投影）
  let ellipse-mirror(x, y, rx: 0.23, ry: 1.38) = {
    circle((x, y), radius: (rx, ry), fill: MIRRORF, stroke: (paint: INK, thickness: 0.7pt))
    // 内轮廓线：示意柱面母线
    circle((x - rx * 0.34, y), radius: (rx * 0.52, ry * 0.97), stroke: (paint: white, thickness: 0.5pt), fill: none)
  }

  // 平板镜：竖向窄矩形（矩形本身就是"板厚"的双线），左侧再加一条棱线
  let mirror(x, y, h, w: 0.26) = {
    rect((x - w / 2, y - h / 2), (x + w / 2, y + h / 2), fill: MIRRORF, stroke: MAIN)
    line((x - w / 2 + 0.07, y - h / 2 + 0.04), (x - w / 2 + 0.07, y + h / 2 - 0.04), stroke: (paint: white, thickness: 0.5pt))
  }

  // 针孔：两个相对的三角形（上尖朝下、下尖朝上）夹出一条狭缝
  let pinhole(x, y, hw: 0.19, hh: 0.90, gap: 0.10) = {
    line((x - hw, y + gap + hh), (x + hw, y + gap + hh), (x, y + gap), close: true, fill: TEAL, stroke: MAIN)
    line((x - hw, y - gap - hh), (x + hw, y - gap - hh), (x, y - gap), close: true, fill: TEAL, stroke: MAIN)
  }

  // MIL 器件：虚线圆内 —— 两片近水平倾斜镜 + 中央挡块 + 右侧掩模/基板。
  // 光两次反射：左上镜 → 左下镜 → 掩模，挡块挡住直接透过的光。
  let mil-device(x, y, r: 1.62) = {
    // 虚线圆（示意"器件放大/器件所在位置"）
    circle((x, y), radius: r, stroke: (paint: INK, thickness: 0.6pt, dash: (2.6pt, 2.2pt)), fill: none)

    // 两片倾斜镜：左端张开、右端收拢，形成很浅的 "<" 形
    let up0 = (x - 1.22, y + 0.58)
    let up1 = (x + 0.22, y + 0.35)
    let lo0 = (x - 1.22, y - 0.58)
    let lo1 = (x + 0.22, y - 0.35)
    let thick = 0.18
    line(up0, up1, (up1.at(0), up1.at(1) - thick), (up0.at(0), up0.at(1) - thick), close: true, fill: MIRRORF, stroke: MAIN)
    line(lo0, lo1, (lo1.at(0), lo1.at(1) + thick), (lo0.at(0), lo0.at(1) + thick), close: true, fill: MIRRORF, stroke: MAIN)

    // 中央挡块（黑色，挡住未反射的直射光）
    rect((x - 1.15, y - 0.14), (x - 0.95, y + 0.14), fill: INK, stroke: none)

    // 掩模 / 基板：竖直薄板，迎光面为暗红抗蚀剂层
    rect((x + 0.33, y - 0.92), (x + 0.45, y + 0.92), fill: rgb("#e8e6e2"), stroke: MAIN)
    line((x + 0.33, y - 0.92), (x + 0.33, y + 0.92), stroke: (paint: RED, thickness: 1.6pt))

    // 两镜之间的多次反射：入射 → 上镜 → 下镜 → 上镜 → 掩模
    // 折点全部落在镜面（迎光面）上，用一条粗的圆头折线表示"细光束"，
    // 比多个四边形拼接更干净（折点不会出现重叠台阶）
    let p0 = (x - 0.92, y + 0.12)
    let p1 = (x - 0.48, y + 0.36) // 上镜
    let p2 = (x - 0.08, y - 0.20) // 下镜
    let p3 = (x + 0.20, y + 0.19) // 上镜
    let p4 = (x + 0.33, y + 0.04) // 掩模
    line(p0, p1, p2, p3, p4,
      stroke: (paint: PFILL.transparentize(30%), thickness: 3.6pt, cap: "round", join: "round"))
    line(p0, p1, p2, p3, p4, stroke: (paint: PURPLE, thickness: 0.5pt))
    // 每段中点一个方向箭头（短线段 + 箭头，避免压住折点）
    for (a, b) in ((p0, p1), (p1, p2), (p2, p3)) {
      let f(t) = (a.at(0) + (b.at(0) - a.at(0)) * t, a.at(1) + (b.at(1) - a.at(1)) * t)
      line(f(0.40), f(0.62), stroke: (paint: PURPLE, thickness: 0.8pt), mark: (end: ">", fill: PURPLE, scale: 0.55))
    }
  }

  // EUV-IL 掩模处的光路（(a) 下方的虚线圆小图）：
  // 膜片（左侧薄板堆）发出的两束光在掩模/基板（右侧暗红板）处交叉。
  let mil-inset(x, y, r: 1.20) = {
    circle((x, y), radius: r, stroke: (paint: INK, thickness: 0.6pt, dash: (2.6pt, 2.2pt)), fill: none)

    // 左侧掩模膜片：竖向薄板 + 上下夹持块 + 中间膜层细线
    rect((x - 0.82, y - 0.72), (x - 0.66, y + 0.72), fill: rgb("#e4eae6"), stroke: MAIN)
    for i in range(4) {
      line((x - 0.82, y - 0.50 + i * 0.34), (x - 0.66, y - 0.50 + i * 0.34), stroke: HINT)
    }
    rect((x - 0.90, y + 0.62), (x - 0.58, y + 0.80), fill: METAL2, stroke: THIN)
    rect((x - 0.90, y - 0.80), (x - 0.58, y - 0.62), fill: METAL2, stroke: THIN)

    // 右侧基板：灰色薄板 + 暗红抗蚀剂面
    rect((x + 0.50, y - 0.72), (x + 0.62, y + 0.72), fill: rgb("#e8e6e2"), stroke: MAIN)
    line((x + 0.50, y - 0.72), (x + 0.50, y + 0.72), stroke: (paint: RED, thickness: 1.6pt))

    // 两束光交叉成 X：各自从膜片一点射向基板一段
    line((x - 0.66, y + 0.40), (x + 0.50, y - 0.34), (x + 0.50, y - 0.06), close: true,
      fill: PFILL.transparentize(50%), stroke: BEAM-EDGE)
    line((x - 0.66, y - 0.36), (x + 0.50, y + 0.36), (x + 0.50, y + 0.08), close: true,
      fill: PFILL.transparentize(50%), stroke: BEAM-EDGE)
  }

  // (b) 掠入射双镜干涉：几何常量与元件函数
  let CX = 18.30 // 干涉场中心（z 轴）的 x 坐标
  let AL = 13deg // 掠入射角 α（光束与镜面之间的夹角）
  let A2 = 26deg // 反射光与竖直方向（z 轴）的夹角 = 2α
  let YTOP = 9.20 // 入射光束顶端
  let YSUB = 1.62 // 基底（抗蚀剂）上表面
  let BOFF = 1.50 // 两束光中心线到 z 轴的距离 = d/2
  let BW = 0.58 // 光束带宽
  // 镜面中心高度由几何决定：光束中心线以 2α 出射，正好落在 (CX, YSUB)
  let MY = YSUB + BOFF / calc.tan(A2)
  let SM = MY - YSUB // S：基底到镜心的距离

  // 一对掠入射镜：左右各一片，镜面（迎光面）严格落在过 M 的 2α 直线上
  let grazing-pair(x, y, len: 3.20, thick: 0.30) = {
    for mu in (-1, 1) {
      let mx = x + mu * BOFF
      let ux = mu * calc.sin(AL) // 沿镜面、自下向上的单位向量
      let uy = calc.cos(AL)
      let nx = -mu * calc.cos(AL) // 指向光轴的法向（迎光面法线）
      let ny = -mu * calc.sin(AL)
      // 迎光面上、下端
      let a = (mx + ux * len / 2, y + uy * len / 2)
      let b = (mx - ux * len / 2, y - uy * len / 2)
      // 背面
      let a2 = (a.at(0) - nx * thick, a.at(1) - ny * thick)
      let b2 = (b.at(0) - nx * thick, b.at(1) - ny * thick)
      line(a, b, b2, a2, close: true, fill: MIRRORF, stroke: MAIN)
      line(a, b, stroke: (paint: INK, thickness: 1.2pt)) // 反射面加粗
      // 镜面延长线（虚线，供 α 角标注参照）
      let ext = (a.at(0) + ux * 1.10, a.at(1) + uy * 1.10)
      line(a, ext, stroke: (paint: INK, thickness: 0.5pt, dash: (2.0pt, 1.8pt)))
      // α 角：顶点取"光束外缘与镜面迎光面"的交点，弧开在光束外侧
      let vx = mx + mu * BW / 2 // 外侧光束边
      let vy = y + uy * ((vx - mx) / ux)
      if mu < 0 {
        arc-at(vx, vy, 0.86, 90deg, 90deg + AL)
        lbl((vx - 0.30, vy + 1.06), [$alpha$], anchor: "east", size: 7.6pt)
      } else {
        arc-at(vx, vy, 0.86, 90deg - AL, 90deg)
        lbl((vx + 0.30, vy + 1.06), [$alpha$], anchor: "west", size: 7.6pt)
      }
    }
  }

  // 单侧光束（mu = -1 左 / +1 右）：
  //   竖直入射段 → 沿镜面足迹折转 → 以 2α 出射 → 停在基底表面。
  // 入射段与出射段分别成两个四边形填充，重叠处（镜面下方）自然加深。
  let grazing-beam(mu) = {
    let bx = CX + mu * BOFF // 光束中心线
    let xo = bx + mu * BW / 2 // 外侧边
    let xi = bx - mu * BW / 2 // 内侧边
    let ux = mu * calc.sin(AL)
    let uy = calc.cos(AL)
    // 竖直线 x 与镜面直线的交点
    let hit(x) = {
      let t = (x - bx) / ux
      (x, MY + uy * t)
    }
    let ho = hit(xo)
    let hi = hit(xi)
    // 出射方向（与竖直方向成 2α，指向光轴）
    let dx = -mu * calc.sin(A2)
    let dy = -calc.cos(A2)
    // 沿出射方向落到基底高度
    let bottom(p) = {
      let s = (p.at(1) - YSUB) / (-dy)
      (p.at(0) + dx * s, YSUB)
    }
    let bo = bottom(ho)
    let bi = bottom(hi)
    // 入射段：上端 + 镜面足迹
    line((xo, YTOP), (xi, YTOP), hi, ho, close: true,
      fill: PFILL.transparentize(48%), stroke: BEAM-EDGE)
    // 出射段：镜面足迹 → 基底
    line(hi, bi, bo, ho, close: true,
      fill: PFILL.transparentize(62%), stroke: BEAM-EDGE)
    // 光束中心轴（虚线 + 指向镜面的箭头）
    line((bx, YTOP - 0.06), (bx, MY - 0.36), stroke: AXIS-DASH, mark: (end: ">", fill: INK, scale: 0.55))
    line((bx, MY - 0.30), (bx + dx * ((MY - 0.30 - YSUB) / -dy), YSUB + 0.02), stroke: (paint: INK, thickness: 0.5pt, dash: (2.0pt, 1.6pt)))
  }

  // (c) MIL 器件线稿（源图为照片）：异形金属板 + 安装孔 + 中央掩模夹具
  let device-plate(cx, cy) = {
    let dcx = cx - 0.62 // 左侧圆盘圆心
    let dcy = cy + 0.05
    // 外轮廓：圆盘左缘 → 下缘两个半圆凹口 → 右侧凸耳 → 圆盘上缘收口
    // （CeTZ 无布尔运算，这里用"圆弧采样点 + 直线段"拼一条闭合折线）
    line(
      ..arc-pts(dcx, dcy, 1.42, 88deg, 198deg, 10),
      ..arc-pts(cx - 1.02, cy - 1.12, 0.40, 200deg, 336deg, 8),
      ..arc-pts(cx - 0.22, cy - 1.20, 0.40, 200deg, 336deg, 8),
      (cx + 0.74, cy - 1.02),
      (cx + 2.16, cy - 1.02),
      (cx + 2.16, cy + 0.50),
      (cx + 0.73, cy + 0.50), // 该点正好落在圆盘圆弧上（y=+0.50 处）
      ..arc-pts(dcx, dcy, 1.42, 19deg, 88deg, 8),
      close: true,
      fill: METAL,
      stroke: BOLD,
    )

    // 安装孔（大孔 + 内圈倒角）
    for p in (
      (cx - 1.42, cy + 0.56),
      (cx - 1.54, cy - 0.32),
      (cx - 0.96, cy - 0.80),
      (cx - 0.30, cy + 1.02),
      (cx + 1.60, cy - 0.30),
      (cx + 1.60, cy + 0.22),
    ) {
      circle(p, radius: 0.19, fill: white, stroke: MAIN)
      circle(p, radius: 0.13, fill: METAL2, stroke: (paint: HINT, thickness: 0.5pt))
    }

    // 中央掩模夹具：小平台 + 倾斜夹片（正面 + 上缘）+ 深色掩模片
    line(
      (cx - 0.28, cy + 0.26), (cx + 0.34, cy + 0.26), (cx + 0.34, cy + 0.38), (cx - 0.28, cy + 0.38),
      close: true, fill: METAL2, stroke: MAIN,
    )
    line((cx - 0.20, cy + 0.38), (cx + 0.02, cy + 0.90), (cx + 0.34, cy + 0.88), (cx + 0.12, cy + 0.36),
      close: true, fill: METAL2, stroke: MAIN) // 夹片正面
    line((cx + 0.02, cy + 0.90), (cx + 0.10, cy + 0.96), (cx + 0.42, cy + 0.94), (cx + 0.34, cy + 0.88),
      close: true, fill: METAL, stroke: MAIN) // 夹片上缘（厚度）
    // 掩模片（贴在夹片正面的深色小方片）
    line((cx - 0.08, cy + 0.56), (cx + 0.03, cy + 0.82), (cx + 0.19, cy + 0.81), (cx + 0.08, cy + 0.55),
      close: true, fill: rgb("#3a3a3c"), stroke: THIN)

    // 小螺钉（十字槽）
    for p in ((cx + 0.34, cy - 0.24), (cx + 0.56, cy - 0.54), (cx + 0.02, cy - 0.44)) {
      circle(p, radius: 0.085, fill: white, stroke: MAIN)
      line((p.at(0) - 0.05, p.at(1)), (p.at(0) + 0.05, p.at(1)), stroke: THIN)
      line((p.at(0), p.at(1) - 0.05), (p.at(0), p.at(1) + 0.05), stroke: THIN)
    }
  }

  // 硬币（比例尺）：双圈轮廓 + 齿纹 + 简化的头像轮廓
  let coin(cx, cy, r: 1.00) = {
    circle((cx, cy), radius: r, fill: rgb("#edece8"), stroke: MAIN)
    circle((cx, cy), radius: r * 0.86, stroke: (paint: HINT, thickness: 0.6pt))
    // 外圈齿纹（短径向线，落在两圈之间）
    for i in range(30) {
      let a = (i / 30) * 360deg
      line(
        (cx + r * 0.88 * calc.cos(a), cy + r * 0.88 * calc.sin(a)),
        (cx + r * 0.97 * calc.cos(a), cy + r * 0.97 * calc.sin(a)),
        stroke: (paint: HINT, thickness: 0.45pt),
      )
    }
    // 头像轮廓（写意：头 + 肩 + 两条铭文线，不是写实）
    circle((cx - 0.08, cy + 0.20), radius: 0.17, stroke: (paint: HINT, thickness: 0.6pt))
    bezier((cx - 0.34, cy - 0.12), (cx + 0.28, cy - 0.12), (cx - 0.28, cy + 0.10), (cx + 0.20, cy + 0.10),
      stroke: (paint: HINT, thickness: 0.6pt))
    line((cx - 0.34, cy - 0.30), (cx + 0.20, cy - 0.30), stroke: (paint: HINT, thickness: 0.5pt))
    line((cx - 0.26, cy - 0.42), (cx + 0.24, cy - 0.42), stroke: (paint: HINT, thickness: 0.5pt))
  }

  // 绘制 (a) 光束线
  let AY = 7.90 // (a) 主光轴高度

  // 波荡器：电子束在其间摆动，产生 EUV 辐射
  undulator(1.55, AY)
  lbl((2.75, AY + 0.98), [Undulator])
  lbl((0.86, AY), [$e^-$], anchor: "east", size: 7.6pt)
  line((1.00, AY), (4.10, AY), stroke: THIN) // 电子束轨迹（中缝）

  // 第一段光锥：波荡器出口 → 椭圆柱收集镜（张开）
  beam-cone(3.95, AY, 5.75, AY, 0.06, 0.95)
  // 第二段光锥：收集镜 → 针孔（收拢到焦点）；三片平板镜在此光路中
  beam-cone(5.75, AY, 8.60, AY, 0.95, 0.05)

  // 主光轴（虚线）：贯穿整条光束线，便于判断同轴关系
  line((3.95, AY), (11.66, AY), stroke: AXIS-DASH)

  // 椭圆柱收集镜
  ellipse-mirror(5.75, AY)
  // 三片平板镜（蓝色竖向矩形，带板厚）
  mirror(6.52, AY, 2.00)
  mirror(6.99, AY, 2.00)
  mirror(7.46, AY, 2.00)
  lbl((7.00, AY + 1.24), [Mirrors])

  // 针孔：过针孔后光束重新张开，成为第三段光锥
  pinhole(8.60, AY)
  lbl((8.60, AY + 1.15), [Pinhole])
  beam-cone(8.60, AY, 10.40, AY, 0.05, 0.84)

  // 虚线圆内的 MIL 器件
  mil-device(11.35, AY)
  lbl((11.35, AY - 1.90), [MIL device])

  // 旋转箭头：器件 → (c) 实物 / 掩模小图
  arc-at(11.35, AY - 2.42, 0.28, 100deg, 440deg,
    stroke: (paint: INK, thickness: 0.6pt), mark: (start: ">", end: ">", fill: INK, scale: 0.5))

  // EUV-IL 掩模小图
  lbl((11.35, AY - 3.00), [EUV-IL mask])
  mil-inset(11.35, AY - 4.28, r: 1.10)

  // 绘制 (b) 掠入射双镜干涉
  grazing-beam(-1)
  grazing-beam(1)
  grazing-pair(CX, MY)

  // 光束标注：EUV light / λ / d
  lbl((CX, YTOP + 0.42), [EUV light], size: 7.4pt)
  lbl((CX, YTOP - 0.16), [$lambda$], size: 7.6pt)
  line((CX - BOFF, YTOP - 0.62), (CX + BOFF, YTOP - 0.62),
    stroke: (paint: INK, thickness: 0.55pt), mark: (start: ">", end: ">", fill: INK, scale: 0.6))
  lbl((CX, YTOP - 0.92), [$d$], size: 7.6pt)

  // 基底 / 抗蚀剂层
  rect((15.80, 1.28), (20.80, 1.50), fill: rgb("#e6e4e0"), stroke: MAIN)
  rect((15.80, 1.50), (20.80, YSUB), fill: RED, stroke: MAIN)
  lbl((15.62, 1.44), [Substrate], anchor: "east", size: 7.4pt)

  // 干涉区：两条光束中心线上的场矢量 E₁ / E₂（⊗ = 垂直于纸面向里的圆偏振）
  let ex = (CX - 0.42, 2.55)
  let ex2 = (CX + 0.42, 2.55)
  for p in (ex, ex2) {
    circle(p, radius: 0.15, fill: white, stroke: MAIN)
    line((p.at(0) - 0.10, p.at(1) - 0.10), (p.at(0) + 0.10, p.at(1) + 0.10), stroke: THIN)
    line((p.at(0) - 0.10, p.at(1) + 0.10), (p.at(0) + 0.10, p.at(1) - 0.10), stroke: THIN)
  }
  lbl((CX - 0.76, 2.52), [$arrow(E)_1$], anchor: "east", size: 7.8pt)
  lbl((CX + 0.76, 2.52), [$arrow(E)_2$], anchor: "west", size: 7.8pt)

  // 2α：两束反射光相对 z 轴的夹角（各标一次，与源图一致）
  arc-at(CX, YSUB, 1.55, 90deg - A2, 90deg)
  arc-at(CX, YSUB, 1.55, 90deg, 90deg + A2)
  lbl((CX - 0.38, 3.44), [$2 alpha$], anchor: "east", size: 7.4pt)
  lbl((CX + 0.38, 3.44), [$2 alpha$], anchor: "west", size: 7.4pt)

  // x-z 坐标轴（z 轴自干涉交叉点上方起，避免穿过交叉菱形）
  line((CX, 2.30), (CX, MY + 1.90), stroke: (paint: INK, thickness: 0.7pt), mark: (end: ">", fill: INK, scale: 0.65))
  lbl((CX + 0.16, MY + 2.02), [$z$], anchor: "west", size: 7.8pt)
  line((20.80, YSUB), (21.72, YSUB), stroke: (paint: INK, thickness: 0.7pt), mark: (end: ">", fill: INK, scale: 0.65))
  lbl((21.84, YSUB - 0.24), [$x$], anchor: "east", size: 7.8pt)

  // S：基底到镜心的距离（双箭头尺寸线）
  line((20.58, YSUB), (20.58, MY), stroke: (paint: INK, thickness: 0.55pt), mark: (start: ">", end: ">", fill: INK, scale: 0.6))
  lbl((20.80, (YSUB + MY) / 2), [$S$], anchor: "west", size: 7.6pt)

  // "Mirror" 标签 + 引线指向左侧镜面
  lbl((15.30, 4.55), [Mirror], anchor: "east", size: 7.4pt)
  line((15.42, 4.62), (16.62, 5.20), stroke: (paint: HINT, thickness: 0.5pt))

  // 干涉周期公式（分式用大字号排，才能看清 λ / 2sin2α）
  content((15.15, 0.68), anchor: "west", text(size: 7.4pt,
    [Patterning period #h(0.6em) #text(size: 11.5pt)[$P = lambda / (2 sin 2 alpha)$]]))

  // 绘制 (c) MIL 器件线稿 + 硬币
  lbl((5.35, 4.18), [MIL device on XIL-II mask holder], size: 7.4pt)
  device-plate(4.05, 2.05)
  coin(7.75, 1.88, r: 1.00)

  // 面板标号
  content((0.52, 9.42), anchor: "west", text(size: 9pt, weight: "bold", [(a)]))
  content((14.38, 9.42), anchor: "west", text(size: 9pt, weight: "bold", [(b)]))
  content((0.52, 4.42), anchor: "west", text(size: 9pt, weight: "bold", [(c)]))
})
