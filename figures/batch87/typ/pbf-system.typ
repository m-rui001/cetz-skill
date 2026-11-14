// 粉末床熔融（PBF）系统原理 + 三种点阵样件示意图
// 源图：Additively manufactured materials and structures: A state-of-the-art review
//       (Elsevier, 2023) Figure 2
//       (a) Schematic for the PBF system
//       (b)(c)(d) 三种点阵样件照片
//
// 重绘原则：
//   1. (a) 用轴测（斜二测）剖视重画：机身沿前后剖切，能看见两个粉仓内部；
//      保留 两个粉仓 / 两个活塞 / 铺粉辊 / 粉末层 / 基板 / 点阵零件 /
//      激光束 / 扫描箭头 / V（成形平台下降方向）。
//   2. (b)(c)(d) 的照片改为线框点阵示意（BCC 开孔点阵 / 球形节点点阵 / TPMS 曲面点阵），
//      点阵全部由“重复单元函数”循环生成，不手写线段。
//   3. 全部线稿，仅粉末层 / 活塞台面做浅灰填充；线宽 0.6–0.8pt。
//   4. 标签沿用源图英文原文。
#set page(width: auto, height: auto, margin: 6pt)
#import "@preview/cetz:0.4.2": canvas, draw
#set text(font: ("Times New Roman", "Segoe UI"), size: 8.4pt)

#canvas({
  import draw: *

  // 配色与线型
  let INK = rgb("#1a1a1a")        // 线稿墨色
  let RED = rgb("#b02a1e")        // 运动箭头（源图为红色箭头）
  let LASER = rgb("#c0399b")      // 激光束（源图为品红）
  let POWDER = rgb("#cbcbcb")     // 粉末层 / 料层：最深的灰面
  let MACH = rgb("#e6e6e6")       // 壁顶、外表面、剖切面等结构面：浅灰
  let PART = rgb("#d8d8d8")       // 活塞台面、基板、液压缸：中间灰
  let INWALL = rgb("#fafafa")     // 腔体内表面：近白
  let HATCH = rgb("#a3a3a3")      // 剖面线灰
  let FRAME = rgb("#9a9a9a")      // 面板外框 / 辅助线灰
  let thin = (paint: INK, thickness: 0.6pt, cap: "round")   // 主体线
  let bold = (paint: INK, thickness: 0.8pt, cap: "round")   // 轮廓 / 强调线
  let lat = (paint: INK, thickness: 0.6pt, cap: "round")    // 点阵杆件

  // 轴测投影（斜二测）
  // 三维坐标：x 向右、y 向上、z 向纵深（屏幕上向右上方偏约 30°）
  // 投影：sx = (x + K·z)·SC，sy = (y + KV·z)·SC
  let K = 0.62
  let KV = 0.36
  let SC = 1.20     // 机身整体缩放（与下方 (b)(c)(d) 面板行同宽）
  let OX = 2.10     // 投影原点（屏幕 x）
  let OY = 11.40    // 投影原点（屏幕 y）
  let P(x, y, z) = (OX + (x + z * K) * SC, OY + (y + z * KV) * SC)

  // 三维折线 / 多边形：把三维点逐个投影后交给 line()
  let ln3(..pts, close: false, fill: none, stroke: thin) = line(
    ..pts.pos().map(p => P(p.at(0), p.at(1), p.at(2))),
    close: close,
    fill: fill,
    stroke: stroke,
  )

  // 三维长方体：只画看得见的三面（前面 z0、顶面 y1、右面 x1）
  let box3(x0, y0, z0, x1, y1, z1, fill: white, stroke: thin) = {
    ln3((x0, y0, z0), (x1, y0, z0), (x1, y1, z0), (x0, y1, z0), close: true, fill: fill, stroke: stroke)   // 前面
    ln3((x0, y1, z0), (x1, y1, z0), (x1, y1, z1), (x0, y1, z1), close: true, fill: fill, stroke: stroke)   // 顶面
    ln3((x1, y0, z0), (x1, y0, z1), (x1, y1, z1), (x1, y1, z0), close: true, fill: fill, stroke: stroke)   // 右面
  }

  // 剖面线：在 z = 0 剖切面的轴对齐矩形内画 45° 细线（工程制图的材料剖面符号）
  let hatch(x0, y0, x1, y1, step: 0.20) = {
    let xa = OX + x0 * SC
    let xb = OX + x1 * SC
    let ya = OY + y0 * SC
    let yb = OY + y1 * SC
    let c0 = xa - yb
    let c1 = xb - ya
    let n = calc.ceil((c1 - c0) / step)
    for i in range(0, n + 1) {
      let c = c0 + i * step
      // 直线 x − y = c 与矩形求交后截断
      let p0 = calc.max(ya, xa - c)
      let p1 = calc.min(yb, xb - c)
      if p1 - p0 > 0.001 {
        line((c + p0, p0), (c + p1, p1), stroke: (paint: HATCH, thickness: 0.6pt))
      }
    }
  }

  // 机身几何常量
  let X0 = 0.00      // 机身左端面
  let X1 = 16.00     // 机身右端面
  let ZB = 4.50      // 内腔后壁
  let Z1 = 5.05      // 后壁外表面
  let YC = 1.45      // 基座板底面
  let YB = 1.95      // 基座板顶面（= 腔底）
  let YR = 4.25      // 腔口（壁顶）
  let C1A = 0.55     // 供粉仓左内壁
  let C1B = 6.90     // 供粉仓右内壁（= 隔墙左面）
  let C2A = 8.00     // 成形仓左内壁（= 隔墙右面）
  let C2B = 15.45    // 成形仓右内壁
  let YSUP = 3.30    // 供粉活塞台面高度（活塞已上升，料面接近腔口）
  let YFAB = 2.30    // 成形活塞台面高度（活塞已下降 = V 方向）

  // 命名函数：(a) 各部件

  // 粉末层：任意 x / z 范围内的水平薄层，浅灰填充 + 剖切面打 45° 剖面线；
  // 供粉仓料层与成形仓铺粉层共用同一函数
  let powder-layer(x0, x1, ya, yb, z0: 0.00, z1: ZB - 0.05, face-hatch: true) = {
    box3(x0, ya, z0, x1, yb, z1, fill: POWDER, stroke: thin)
    if face-hatch {
      hatch(x0, ya, x1, yb, step: 0.22)
    }
  }

  // 粉仓活塞：台面（活塞顶板）+ 竖直柱塞；dir = +1 上升（供粉仓）、-1 下降（成形仓）
  let powder-piston(x0, x1, ytop, dir) = {
    let xm = (x0 + x1) / 2
    // 柱塞：自台面下沿伸到基座，剖切后可见其正面与右侧面
    box3(xm - 0.44, YB, 1.70, xm + 0.44, ytop - 0.35, 3.30, fill: PART, stroke: thin)
    // 台面（活塞顶板），其前面即剖切面
    box3(x0, ytop - 0.35, 0.00, x1, ytop, ZB - 0.05, fill: PART, stroke: bold)
    // 台面下沿的一道细线，示意活塞与缸体的配合面
    ln3((x0, ytop - 0.36, 0.05), (x1, ytop - 0.36, 0.05), stroke: thin)
    // 台面下方的点划线，示意活塞仍在运动的行程
    ln3(
      (x0 + 0.35, ytop - 0.72, 0.05), (x1 - 0.35, ytop - 0.72, 0.05),
      stroke: (paint: FRAME, thickness: 0.6pt, dash: (1.8pt, 1.4pt)),
    )
  }

  // 铺粉辊：沿 z 轴的圆柱（投影为“胶囊” = 两端圆 + 两条平行母线），a / b 为轴两端点
  let roller(a, b, r) = {
    let pa = P(a.at(0), a.at(1), a.at(2))
    let pb = P(b.at(0), b.at(1), b.at(2))
    let dx = pb.at(0) - pa.at(0)
    let dy = pb.at(1) - pa.at(1)
    let len = calc.sqrt(dx * dx + dy * dy)
    // 母线方向 (dx,dy)，法向 (−dy,dx)/len，两端偏移 ±r
    let nx = -dy / len * r
    let ny = dx / len * r
    circle(pa, radius: r, fill: white, stroke: bold)   // 后端面
    circle(pb, radius: r, fill: white, stroke: bold)   // 前端面
    line((pa.at(0) + nx, pa.at(1) + ny), (pb.at(0) + nx, pb.at(1) + ny), stroke: bold)
    line((pa.at(0) - nx, pa.at(1) - ny), (pb.at(0) - nx, pb.at(1) - ny), stroke: bold)
  }

  // 点阵零件：以重复单元在 nx×ny×nz 网格上生成杆件（竖杆 + 双向横杆 + 顶面框），
  // 避免手写大量线段；单元为立方骨架，等价于源图样件的“逐层栅格”外观
  let build-part(x0, y0, z0, w, h, d, nx, ny, nz) = {
    let ux = w / nx
    let uy = h / ny
    let uz = d / nz
    // 竖杆（沿 y）：每个平面节点一根
    for k in range(0, nz + 1) {
      for i in range(0, nx + 1) {
        ln3((x0 + i * ux, y0, z0 + k * uz), (x0 + i * ux, y0 + h, z0 + k * uz), stroke: lat)
      }
    }
    // 横杆（沿 x、沿 z 两个方向），逐层生成
    for j in range(1, ny + 1) {
      let y = y0 + j * uy
      for k in range(0, nz + 1) {
        for i in range(0, nx) {
          ln3((x0 + i * ux, y, z0 + k * uz), (x0 + (i + 1) * ux, y, z0 + k * uz), stroke: lat)
        }
      }
      for i in range(0, nx + 1) {
        for k in range(0, nz) {
          ln3((x0 + i * ux, y, z0 + k * uz), (x0 + i * ux, y, z0 + (k + 1) * uz), stroke: lat)
        }
      }
    }
    // 顶面外框 + 底面轮廓，强调块体轮廓并交代零件与粉床的接合面
    ln3(
      (x0, y0 + h, z0), (x0 + w, y0 + h, z0), (x0 + w, y0 + h, z0 + d), (x0, y0 + h, z0 + d),
      close: true, stroke: bold,
    )
    ln3((x0, y0, z0), (x0 + w, y0, z0), (x0 + w, y0, z0 + d), (x0, y0, z0 + d), close: true, stroke: thin)
  }

  // 激光束与扫描方向：镜筒（沿 z 的短圆柱）+ 会聚光束锥 + 熔池上方四向扫描箭头
  let laser-beam(ax, ay, az, bx, by, bz) = {
    roller((ax, ay, az - 0.48), (ax, ay, az + 0.48), 0.38)
    // 会聚光束：上宽下窄的三角形，浅品红填充
    let w0 = 0.26
    ln3(
      (ax - w0, ay - 0.05, az), (bx, by, bz), (ax + w0, ay - 0.05, az),
      close: true, fill: rgb("#f7dcf1"), stroke: (paint: LASER, thickness: 0.7pt),
    )
    // 光轴虚线
    ln3((ax, ay - 0.05, az), (bx, by, bz), stroke: (paint: LASER, thickness: 0.6pt, dash: (1.1pt, 1pt)))
    // 扫描方向：熔池上方的十字双向箭头（源图为四向红箭头）
    let sy = by + 0.26
    line(
      P(bx - 1.10, sy, bz), P(bx + 1.10, sy, bz),
      stroke: (paint: RED, thickness: 0.7pt, cap: "round"),
      mark: (start: ">", end: ">", fill: RED, scale: 0.42),
    )
    line(
      P(bx, sy, bz - 1.15), P(bx, sy, bz + 1.15),
      stroke: (paint: RED, thickness: 0.7pt, cap: "round"),
      mark: (start: ">", end: ">", fill: RED, scale: 0.38),
    )
    // 熔池位置的小圆点
    circle(P(bx, by, bz), radius: 0.06, fill: LASER, stroke: none)
  }

  // 液压缸：轴线竖直的圆柱，只画两条母线与下缘椭圆（顶端藏在基座板之后）。
  // 用屏幕坐标直接绘制，避开斜二测“越深越高”使缸顶穿出基座板的假象。
  let hydraulic-cylinder(cx, ytop, ybot, r, ry) = {
    let pts = ((cx - r, ytop),)
    for i in range(0, 25) {
      let a = calc.pi + calc.pi * i / 24
      pts.push((cx + r * calc.cos(a), ybot + ry * calc.sin(a)))
    }
    pts.push((cx + r, ytop))
    line(..pts, close: true, fill: PART, stroke: bold)
  }

  // 文字标签
  let lbl(x, y, body, size: 8.4pt, anchor: "center", weight: "bold", fill: INK) = content(
    (x, y), anchor: anchor, text(size: size, fill: fill, weight: weight, body),
  )
  // 两行标签（dy 为行距）
  let lbl2(x, y, a, b, size: 8.4pt, anchor: "center", dy: 0.46) = {
    lbl(x, y + dy / 2, a, size: size, anchor: anchor)
    lbl(x, y - dy / 2, b, size: size, anchor: anchor)
  }
  // 指引线（源图为细实线，无箭头）
  let lead(a, b) = line(a, b, stroke: (paint: INK, thickness: 0.6pt))
  // 运动箭头（参数为屏幕坐标）
  let arrow(a, b, fill: RED) = line(
    a, b,
    stroke: (paint: fill, thickness: 0.8pt, cap: "round"),
    mark: (end: ">", fill: fill, scale: 0.4),
  )

  // (a) 机身主体
  // —— 视线方向为 (+x, +y, −z)，故按“远→近”逐层绘制：后壁 → 侧壁内面 → 腔底 → 内容 → 壁顶 → 剖切面 ——

  // 后壁内表面（腔体最后方的一片墙）
  ln3((X0, YB, ZB), (X1, YB, ZB), (X1, YR, ZB), (X0, YR, ZB), close: true, fill: INWALL, stroke: thin)
  // 后壁顶面
  ln3((X0, YR, ZB), (X1, YR, ZB), (X1, YR, Z1), (X0, YR, Z1), close: true, fill: MACH, stroke: bold)

  // 隔墙朝向成形仓的一面（x = C2A）与左端壁朝向供粉仓的一面（x = C1A）
  ln3((C2A, YB, 0), (C2A, YR, 0), (C2A, YR, ZB), (C2A, YB, ZB), close: true, fill: INWALL, stroke: bold)
  ln3((C1A, YB, 0), (C1A, YR, 0), (C1A, YR, ZB), (C1A, YB, ZB), close: true, fill: INWALL, stroke: bold)

  // 腔底（基座板顶面）
  ln3((X0, YB, 0), (X1, YB, 0), (X1, YB, ZB), (X0, YB, ZB), close: true, fill: INWALL, stroke: thin)

  // 左粉仓（供粉仓：活塞上升，料面接近腔口）
  powder-piston(C1A + 0.05, C1B - 0.05, YSUP, 1)
  // 供粉仓料层：自台面顶到接近腔口，浅灰填充，剖切后可见完整料柱
  powder-layer(C1A + 0.05, C1B - 0.05, YSUP, YR - 0.16, z0: 0.02, z1: ZB - 0.05)
  // 料面上的一道浅痕，示意刮平后的粉面
  ln3(
    (C1A + 0.60, YR - 0.16, 1.20), (C1B - 0.60, YR - 0.16, 1.20),
    stroke: (paint: FRAME, thickness: 0.6pt),
  )

  // 右粉仓（成形仓：活塞下降，正在打印点阵零件）
  powder-piston(C2A + 0.05, C2B - 0.05, YFAB, -1)
  // 基板（成形平台上的底板，零件在其上逐层生长）
  box3(C2A + 0.06, YFAB, 0.06, C2B - 0.06, YFAB + 0.25, ZB - 0.06, fill: PART, stroke: bold)
  // 铺粉层（基板之上、零件周围的一层粉）
  powder-layer(C2A + 0.06, C2B - 0.06, YFAB + 0.25, YFAB + 1.15, z0: 0.06, z1: ZB - 0.06)
  // 点阵零件：坐在铺粉层上，高出腔口
  build-part(10.05, YFAB + 1.15, 1.05, 2.60, 1.70, 2.30, 4, 3, 3)

  // 壁顶（最近的一层，最后画）
  // 隔墙顶面
  ln3((C1B, YR, 0), (C2A, YR, 0), (C2A, YR, ZB), (C1B, YR, ZB), close: true, fill: MACH, stroke: bold)
  // 左端壁顶面
  ln3((X0, YR, 0), (C1A, YR, 0), (C1A, YR, ZB), (X0, YR, ZB), close: true, fill: MACH, stroke: bold)
  // 右端壁顶面 + 右侧外表面
  ln3((C2B, YR, 0), (X1, YR, 0), (X1, YR, ZB), (C2B, YR, ZB), close: true, fill: MACH, stroke: bold)
  ln3((X1, 0.10, 0), (X1, YR, 0), (X1, YR, Z1), (X1, 0.10, Z1), close: true, fill: MACH, stroke: bold)

  // 前端剖切面（z = 0，最近）
  ln3((X0, 0.10, 0), (C1A, 0.10, 0), (C1A, YR, 0), (X0, YR, 0), close: true, fill: MACH, stroke: bold)    // 左立柱
  ln3((C1B, YB, 0), (C2A, YB, 0), (C2A, YR, 0), (C1B, YR, 0), close: true, fill: MACH, stroke: bold)      // 隔墙
  ln3((C2B, 0.10, 0), (X1, 0.10, 0), (X1, YR, 0), (C2B, YR, 0), close: true, fill: MACH, stroke: bold)    // 右立柱

  // 两台液压缸 + 基座板
  // 液压缸先画，基座板随后覆盖其顶部（近处遮挡远处）
  hydraulic-cylinder(OX + (C1A + C1B) / 2 * SC, OY + YC * SC - 0.05, OY + 1.02 * SC, 1.12 * SC, 1.12 * KV * SC)   // 供粉仓下方（上升）
  hydraulic-cylinder(OX + (C2A + C2B) / 2 * SC, OY + YC * SC - 0.05, OY + 1.02 * SC, 1.12 * SC, 1.12 * KV * SC)   // 成形仓下方（下降）
  // 基座板（承载两个粉仓的底板）
  ln3((C1A, YC, 0), (C2B, YC, 0), (C2B, YB, 0), (C1A, YB, 0), close: true, fill: PART, stroke: bold)     // 前面
  hatch(C1A, YC, C2B, YB, step: 0.34)

  // 活塞运动方向（源图红色箭头 + V）
  arrow(P(2.20, 0.30, 0), P(2.20, 1.34, 0))     // 供粉活塞上升
  arrow(P(14.20, 1.34, 0), P(14.20, 0.30, 0))   // 成形活塞下降
  lbl(OX + 14.74 * SC, OY + 0.80 * SC, [V], size: 11pt, anchor: "west", weight: "regular")

  // 铺粉辊（停在隔墙上方，红箭头示往复运动方向）
  roller((7.60, 5.02, 0.35), (7.60, 5.02, 4.70), 0.42)
  arrow(P(9.70, 5.80, 2.40), P(7.48, 5.80, 2.40))

  // 激光束 + 扫描方向
  laser-beam(11.80, 6.45, 2.20, 11.35, YFAB + 2.85, 2.20)

  // (a) 标签与指引线
  lbl(1.15, 20.45, [(a)], size: 13pt, anchor: "north-west", weight: "regular")
  lbl(6.05, 19.35, [Roller], size: 9.6pt)
  lead((7.50, 19.25), (11.30, 17.60))

  lbl(23.65, 20.25, [Part], size: 9.6pt)
  lead((22.80, 20.15), (19.85, 19.15))

  lbl2(4.35, 10.10, [Powder supply], [platform], size: 9.2pt)
  lead((4.80, 10.65), (5.30, 15.05))

  lbl2(12.30, 10.10, [Powder], [bed], size: 9.2pt)
  lead((12.30, 10.65), (13.20, 15.55))

  lbl2(22.45, 10.10, [Fabrication], [platform], size: 9.2pt)
  lead((21.85, 10.70), (19.70, 13.95))

  // (b)(c)(d) 点阵示意
  // 面板与点阵布局常量
  let PW = 8.20        // 面板宽
  let PH = 8.35        // 面板高
  let PGAP = 0.85      // 面板间距
  let PY = 0.35        // 面板底边
  let S = 1.42         // 点阵单元尺寸
  let PX(i) = 0.45 + i * (PW + PGAP)

  // 面板局部轴测：u 向右、v 向上、w 向纵深（与 (a) 同一投影方向）
  let Q(ox, oy, u, v, w) = (ox + (u + 0.62 * w) * S, oy + (v + 0.34 * w) * S)

  // (b) BCC / 开孔点阵：立方节点骨架 + 可见面斜撑（体心立方单元的杆件拓扑）
  let lattice-bcc(ox, oy, n, lv) = {
    // 竖杆
    for k in range(0, n + 1) {
      for i in range(0, n + 1) {
        line(Q(ox, oy, i, 0, k), Q(ox, oy, i, lv, k), stroke: lat)
      }
    }
    // 双向横杆，逐层
    for j in range(0, lv + 1) {
      for k in range(0, n + 1) {
        for i in range(0, n) { line(Q(ox, oy, i, j, k), Q(ox, oy, i + 1, j, k), stroke: lat) }
      }
      for i in range(0, n + 1) {
        for k in range(0, n) { line(Q(ox, oy, i, j, k), Q(ox, oy, i, j, k + 1), stroke: lat) }
      }
    }
    // 前面（w = 0）的交叉斜撑，对应 BCC 单元的体心对角杆
    for j in range(0, lv) {
      for i in range(0, n) {
        line(Q(ox, oy, i, j, 0), Q(ox, oy, i + 1, j + 1, 0), stroke: lat)
        line(Q(ox, oy, i + 1, j, 0), Q(ox, oy, i, j + 1, 0), stroke: lat)
      }
    }
  }

  // (c) 球形节点点阵：杆件骨架 + 节点球（球由后向前绘制，形成实体节点外观）
  let lattice-spheres(ox, oy, n, lv) = {
    let r = 0.33 * S
    // 杆件：竖杆 + 双向横杆
    for k in range(0, n + 1) {
      for i in range(0, n + 1) {
        line(Q(ox, oy, i, 0, k), Q(ox, oy, i, lv, k), stroke: lat)
      }
    }
    for j in range(0, lv + 1) {
      for k in range(0, n + 1) {
        for i in range(0, n) { line(Q(ox, oy, i, j, k), Q(ox, oy, i + 1, j, k), stroke: lat) }
      }
      for i in range(0, n + 1) {
        for k in range(0, n) { line(Q(ox, oy, i, j, k), Q(ox, oy, i, j, k + 1), stroke: lat) }
      }
    }
    // 节点球：由后往前逐层覆盖
    for k in range(lv, -1, step: -1) {
      for j in range(0, lv + 1) {
        for i in range(0, n + 1) {
          let c = Q(ox, oy, i, j, k)
          circle(c, radius: r, fill: white, stroke: lat)                                    // 球体
          circle(
            (c.at(0) - r * 0.32, c.at(1) + r * 0.32), radius: r * 0.15, stroke: lat,
          )                                                                                 // 球面孔洞
        }
      }
    }
  }

  // (d) TPMS 曲面点阵：两条正交的正弦曲面族交织，近似 gyroid 型连续极小曲面
  let lattice-tpms(ox, oy, n, lv) = {
    let amp = 0.52
    let seg = 18
    // 第一族：沿 u 方向的波浪曲线（每个 v 层、每个纵深各一条）
    for j in range(0, lv + 1) {
      for k in range(0, n + 1) {
        let pts = ()
        for t in range(0, seg + 1) {
          let u = n * t / seg
          pts.push(Q(ox, oy, u, j + amp * calc.sin(calc.pi * u), k))
        }
        line(..pts, stroke: lat)
      }
    }
    // 第二族：沿 w 方向的波浪曲线（相位差 90°，与第一族交织成连续曲面）
    for j in range(0, lv + 1) {
      for i in range(0, n + 1) {
        let pts = ()
        for t in range(0, seg + 1) {
          let w = n * t / seg
          pts.push(Q(ox, oy, i, j + amp * calc.cos(calc.pi * w), w))
        }
        line(..pts, stroke: lat)
      }
    }
    // 包围盒（浅灰细线）：交代样件的外形尺寸
    let box-stroke = (paint: rgb("#b4b4b4"), thickness: 0.6pt)
    for dv in (0, lv) {
      line(
        Q(ox, oy, 0, dv, 0), Q(ox, oy, n, dv, 0), Q(ox, oy, n, dv, n), Q(ox, oy, 0, dv, n),
        close: true, stroke: box-stroke,
      )
    }
    for (u, w) in ((0, 0), (n, 0), (n, n), (0, n)) {
      line(Q(ox, oy, u, 0, w), Q(ox, oy, u, lv, w), stroke: box-stroke)
    }
  }

  // 面板外框 + 标号 + 比例尺
  let panel(i, tag, scale: none, scalex: 0, bar: 0) = {
    let px = PX(i)
    rect((px, PY), (px + PW, PY + PH), fill: none, stroke: (paint: FRAME, thickness: 0.6pt))
    // 标号 (b)(c)(d)：面板左上角
    lbl(px + 0.20, PY + PH - 0.28, tag, size: 13pt, anchor: "north-west", weight: "regular")
    // 比例尺：横条 + 两端竖挡 + 数字（沿用源图 2mm / 10mm）
    if scale != none {
      let x0 = px + scalex
      let x1 = x0 + bar
      let y = PY + 0.30
      line((x0, y), (x1, y), stroke: (paint: INK, thickness: 0.8pt))
      line((x0, y - 0.11), (x0, y + 0.11), stroke: (paint: INK, thickness: 0.6pt))
      line((x1, y - 0.11), (x1, y + 0.11), stroke: (paint: INK, thickness: 0.6pt))
      lbl((x0 + x1) / 2, y + 0.30, scale, size: 8.6pt, weight: "regular")
    }
  }

  panel(0, [(b)], scale: [2mm], scalex: 5.85, bar: 0.80)
  panel(1, [(c)], scale: [10mm], scalex: 0.60, bar: 2.30)
  panel(2, [(d)])

  lattice-bcc(PX(0) + 0.85, PY + 1.25, 3, 3)
  lattice-spheres(PX(1) + 0.95, PY + 1.60, 3, 3)
  lattice-tpms(PX(2) + 0.85, PY + 1.30, 3, 3)
})
