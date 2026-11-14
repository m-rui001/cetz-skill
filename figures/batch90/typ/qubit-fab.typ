// 300 mm 晶圆上的超导量子比特制造流程（五步等轴测工艺图）
// 源图：Advanced CMOS manufacturing of superconducting qubits on 300 mm wafers
//       (Nature 634, 2024)  Fig. 1e
//
// 版面：自左向右五步，每步三件套 ——
//   ① 上方椭圆：该步“工具 / 气氛”下晶圆的俯视样子（光刻时还会画出掩模与光锥）
//   ② 斜箭头：从晶圆指向本步结束后的器件
//   ③ 下方等轴测叠层：同一块芯片的剖视，能看到硅基底 / 底电极 / 势垒层 / 顶电极
//   左下角放大圈给出 junction 界面的细节，两条细引线把它连到器件上的对应位置。
//
// 重绘原则：
//   · 渲染图 / 照片一律改线稿，三维坐标全部由 iso() 等轴测投影生成，不手摆屏幕点；
//   · 五步共用 layer-stack()，只按步号切换材料颜色与是否新增膜层，保证形态一致；
//   · 配色严格对应底部图例四项（Aluminum / Silicon / AlOx native / AlOx barrier）。
#set page(width: auto, height: auto, margin: 6pt)
#import "@preview/cetz:0.4.2": canvas, draw
#set text(font: ("Times New Roman", "Segoe UI"), size: 8.6pt, fill: rgb("#141414"))

#canvas({
  import draw: *

  // 一、配色与线型
  let INK    = rgb("#141414")   // 线稿墨色
  let SI     = rgb("#5cc6e2")   // Silicon（蓝）
  let ALU    = rgb("#a9b0b6")   // Aluminum（灰）
  let ALOX_N = rgb("#a344a6")   // AlOx (native)（紫）
  let ALOX_B = rgb("#e2a3d6")   // AlOx (barrier)（粉）
  let RED    = rgb("#cf2a26")   // Ar 等离子体 / 离子
  let GREEN  = rgb("#5fbf95")   // 氧化气氛
  let YEL    = rgb("#f4e98f")   // 光刻光束
  let YEL_HI = rgb("#fdfbd6")   // 晶圆上的光斑
  let GREY   = rgb("#d3d7da")   // 晶圆俯视（铝面）
  let WHITE  = rgb("#ffffff")

  let th   = (paint: INK, thickness: 0.6pt, cap: "round")   // 细节线 / 引线
  let mid  = (paint: INK, thickness: 0.7pt, cap: "round")   // 等轴测轮廓
  let bold = (paint: INK, thickness: 0.8pt, cap: "round")   // 放大圈 / 箭头

  // 二、等轴测投影
  //    x 轴指向屏幕左下、y 轴指向屏幕右下、z 轴竖直向上。
  //    S 为整体比例，KZ 为竖向夸张系数（把几十纳米厚的膜层画到看得见）。
  let S = 0.555
  let KZ = 2.1
  let c30 = calc.cos(30deg)
  let s30 = calc.sin(30deg)
  let iso(x, y, z, s: 1) = ((y - x) * c30 * S * s, (z * KZ - (x + y) * s30) * S * s)

  // 三维点 → 屏幕点；ox / oy 为该面板的投影原点
  let P3(ox, oy, x, y, z, s: 1) = {
    let p = iso(x, y, z, s: s)
    (ox + p.at(0), oy + p.at(1))
  }

  // 三、三维绘制工具

  // 一个三维多边形面（自动闭合）
  let face3(ox, oy, pts, fill, stroke: mid) = line(
    ..pts.map(p => P3(ox, oy, p.at(0), p.at(1), p.at(2))),
    close: true,
    fill: fill,
    stroke: stroke,
  )

  // 三维长方体：只画视线内可见的三个面（顶面、+x 面、+y 面）
  let box3(x0, y0, z0, w, d, h, fill, ox: 0, oy: 0, stroke: mid, shade: 12%) = {
    face3(ox, oy, (
      (x0, y0 + d, z0 + h), (x0 + w, y0 + d, z0 + h),
      (x0 + w, y0, z0 + h), (x0, y0, z0 + h),
    ), fill, stroke: stroke)                                                   // 顶面
    face3(ox, oy, (
      (x0 + w, y0, z0), (x0 + w, y0 + d, z0),
      (x0 + w, y0 + d, z0 + h), (x0 + w, y0, z0 + h),
    ), fill.darken(shade * 1.7), stroke: stroke)                               // +x 立面（朝左下）
    face3(ox, oy, (
      (x0, y0 + d, z0), (x0 + w, y0 + d, z0),
      (x0 + w, y0 + d, z0 + h), (x0, y0 + d, z0 + h),
    ), fill.darken(shade), stroke: stroke)                                     // +y 立面（朝右下）
  }

  // 竖直圆柱（junction 圆形电极）：顶面是完整圆，侧面只画可见的半个圆周
  let puck3(ox, oy, cx, cy, z0, h, r, fill, stroke: mid) = {
    let pt(z, a) = (cx + r * calc.cos(a), cy + r * calc.sin(a), z)
    let top = range(0, 24).map(k => pt(z0 + h, k * 15deg))       // 整圈：顶面
    let half-a = range(0, 13).map(k => pt(z0 + h, -45deg + k * 15deg))
    let half-b = range(0, 13).map(k => pt(z0, -45deg + k * 15deg))
    let proj(pts) = pts.map(p => P3(ox, oy, p.at(0), p.at(1), p.at(2)))
    line(..proj(half-a), ..proj(half-b).rev(), close: true,
      fill: fill.darken(18%), stroke: stroke)                                  // 侧面
    line(..proj(top), close: true, fill: fill, stroke: stroke)                 // 顶面
  }

  // 圆形电极顶面的一小块高光，暗示金属台是圆的
  let pad-shine(ox, oy, cx, cy, z, r, fill) = {
    let c = P3(ox, oy, cx, cy, z)
    circle((c.at(0) - r * S * 0.12, c.at(1) + r * S * 0.06), radius: r * S * 0.17,
      fill: fill.lighten(16%), stroke: none)
  }

  // 一圈细环（junction 界面的势垒环）：只描边不填充
  let ring3(ox, oy, cx, cy, z, r, stroke) = {
    let pts = range(0, 24).map(k => {
      let a = k * 15deg
      P3(ox, oy, cx + r * calc.cos(a), cy + r * calc.sin(a), z)
    })
    line(..pts, close: true, stroke: stroke)
  }

  // 铝球（junction 顶端的接触球）：圆 + 高光 + 底缘反光弧
  let sphere3(ox, oy, x, y, z, r, fill) = {
    let c = P3(ox, oy, x, y, z)
    let rr = r * S
    circle(c, radius: rr, fill: fill, stroke: mid)
    circle((c.at(0) - rr * 0.28, c.at(1) + rr * 0.30), radius: rr * 0.30,
      fill: fill.lighten(42%), stroke: none)
    arc((c.at(0), c.at(1)), start: 205deg, stop: 325deg, radius: rr * 0.72,
      stroke: (paint: fill.darken(28%), thickness: 0.6pt))
  }

  // 四、器件叠层（五步共用）
  //    硅基底上一条底电极：两条接地条 + T 形电极（横条 + 悬臂 + 圆形 junction 电极），
  //    再按步号决定表面是原生氧化层 / 洁净铝 / 势垒层 / 顶电极膜 / 图形化顶电极。
  let SW = 5.40   // 芯片沿 x 的宽度
  let SD = 4.60   // 沿 y 的深度
  let SH = 0.42   // 硅片厚度
  let EH = 0.40   // 电极厚度
  let FH = 0.22   // 顶电极膜厚

  let GROUND_FAR  = (0.12, 0.30, 0.42, 4.00)   // 远侧接地条 (x0, y0, 宽, 深)
  let BAR         = (1.10, 0.50, 1.30, 3.20)   // 底电极横条（T 的横）
  let ARM         = (2.40, 2.10, 1.65, 0.58)   // 悬臂（T 的竖），从横条伸向 junction
  let GROUND_NEAR = (4.98, 0.30, 0.40, 4.00)   // 近侧接地条
  let PAD = (4.05, 2.39)                       // 圆形 junction 电极的圆心，半径 0.50
  // 第 V 步顶电极的悬臂刻意收短，给 junction 让出圆形窗口
  let ARM_V = (2.40, 2.10, 0.90, 0.58)

  // 按“远 → 近”的顺序绘制四块金属图形（观察者在 +x / +y 一侧）
  let metal-parts = (GROUND_FAR, BAR, ARM, GROUND_NEAR)

  let layer-stack(ox, oy, step) = {
    // ① 硅基底
    box3(0, 0, 0, SW, SD, SH, SI, ox: ox, oy: oy, shade: 17%)

    // ② 底电极金属。第 I 步刚刻完，铝面被原生氧化层覆盖 → 整块画成紫色；
    //    第 II 步 Ar 等离子体把氧化层打掉 → 之后都是洁净铝的灰色。
    let metal = if step == 1 { ALOX_N } else { ALU }

    if step == 5 {
      // ⑤ 顶电极图形化：场上只剩“顶电极图形”本身（与底电极同形，故画成薄片），
      //    junction 处留出圆形窗口，窗口里露出电极台、势垒环和铝球。
      for part in (GROUND_FAR, BAR, ARM_V, GROUND_NEAR) {
        let (x0, y0, w, d) = part
        box3(x0, y0, SH, w, d, FH, metal, ox: ox, oy: oy)
      }
      puck3(ox, oy, PAD.at(0), PAD.at(1), SH, EH, 0.50, ALU)
      pad-shine(ox, oy, PAD.at(0), PAD.at(1), SH + EH, 0.50, ALU)
      ring3(ox, oy, PAD.at(0), PAD.at(1), SH + EH + 0.01, 0.50,
        (paint: ALOX_B, thickness: 0.8pt))
      sphere3(ox, oy, PAD.at(0), PAD.at(1), SH + EH + 0.19, 0.31, ALU)
    } else {
      // ② 底电极（横条 / 悬臂 / 两条接地条 / 圆形电极）
      for part in metal-parts {
        let (x0, y0, w, d) = part
        box3(x0, y0, SH, w, d, EH, metal, ox: ox, oy: oy)
      }
      puck3(ox, oy, PAD.at(0), PAD.at(1), SH, EH, 0.50, metal)
      pad-shine(ox, oy, PAD.at(0), PAD.at(1), SH + EH, 0.50, metal)

      if step == 3 {
        // ③ 受控氧化：洁净铝表面长出一层极薄的 AlOx 势垒层。
        //    画成比电极略微外扩的薄片，侧壁仍露出灰色铝，表示“只在表面生长”。
        for part in metal-parts {
          let (x0, y0, w, d) = part
          box3(x0 - 0.03, y0 - 0.03, SH + EH, w + 0.06, d + 0.06, 0.09,
            ALOX_B, ox: ox, oy: oy, stroke: th)
        }
        puck3(ox, oy, PAD.at(0), PAD.at(1), SH + EH, 0.09, 0.53, ALOX_B, stroke: th)
      }

      if step == 4 {
        // ④ 顶电极沉积：整片晶圆（含场区）覆盖一层铝膜；
        //    底电极的形貌透过薄膜顶起，形成 T 形脊和两条边缘脊。
        box3(0.03, 0.03, SH, SW - 0.06, SD - 0.06, FH, ALU, ox: ox, oy: oy)
        for part in metal-parts {
          let (x0, y0, w, d) = part
          box3(x0, y0, SH + FH, w, d, EH, ALU, ox: ox, oy: oy)
        }
        puck3(ox, oy, PAD.at(0), PAD.at(1), SH + FH, EH, 0.50, ALU)
        pad-shine(ox, oy, PAD.at(0), PAD.at(1), SH + FH + EH, 0.50, ALU)
      }
    }
  }

  // 五、放大圈：圆内画 junction 界面的放大细节，圈外用细引线连到器件
  let leader(target, c, r) = {
    let dx = target.at(0) - c.at(0)
    let dy = target.at(1) - c.at(1)
    let a0 = calc.atan2(dy, dx)
    for sgn in (-1, 1) {
      let a = a0 + sgn * 8deg
      line((c.at(0) + r * calc.cos(a), c.at(1) + r * calc.sin(a)), target, stroke: th)
    }
  }

  // detail 是“圈里画什么”的闭包；r 为放大圈半径
  let lens-circle(c, r, detail) = {
    circle(c, radius: r, fill: WHITE, stroke: bold)
    detail(c, r)
    circle(c, radius: r, fill: none, stroke: bold)   // 压在最上层，保证圆边完整
  }

  // 圈内的公共底：硅片表面（蓝）+ 一段电极指条（圆角块 + 顶面高光）
  let lens-finger(c, r, body, cap: none) = {
    let x0 = c.at(0) - r * 0.66
    let x1 = c.at(0) + r * 0.34
    let y0 = c.at(1) - r * 0.24
    let y1 = c.at(1) + r * 0.28
    if cap == none {
      rect((x0, y0), (x1, y1), radius: (y1 - y0) / 2, fill: body, stroke: mid)
    } else {
      // 先画一层更“胖”的膜（cap），再画里面的金属 —— 表示表面多了一层
      rect((x0 - r * 0.05, y0 - r * 0.05), (x1 + r * 0.04, y1 + r * 0.05),
        radius: (y1 - y0) / 2 + r * 0.05, fill: cap, stroke: th)
      rect((x0, y0), (x1, y1), radius: (y1 - y0) / 2, fill: body, stroke: mid)
    }
    // 顶面高光带：让指条看起来是圆柱面而不是平板
    rect((x0 + r * 0.10, y1 - r * 0.11), (x1 - r * 0.14, y1 - r * 0.03),
      radius: 0.04, fill: body.lighten(24%), stroke: none)
  }

  // 六、上方的“工具 / 气氛”图标

  // 晶圆俯视椭圆（外框 + 一层半透明高光，模拟源图的渐变）
  let env-wafer(px, ey, rx, ry, fill) = {
    circle((px, ey), radius: (rx, ry), fill: fill, stroke: bold)
    circle((px, ey + 0.13), radius: (rx - 0.24, ry - 0.13),
      fill: WHITE.transparentize(58%), stroke: none)
  }

  // 光刻：等轴测放置的方格掩模 + 打向晶圆的光锥 + 晶圆上的光斑
  let env-litho(px, ey, my) = {
    let a = 0.98
    let sc = 1.30
    let at(u, v) = P3(px, my, u, v, 0, s: sc)
    let l = (px - 0.32, ey + 0.40)   // 晶圆上的光斑四角
    let b = (px, ey + 0.24)
    let r_ = (px + 0.34, ey + 0.42)
    let t = (px, ey + 0.60)
    let cL = at(a, -a)
    let cB = at(a, a)
    let cR = at(-a, a)
    let cT = at(-a, -a)
    // 光锥：掩模四角连到光斑四角的四个梯形面
    for (p, q, qq, pp) in ((cL, cB, b, l), (cB, cR, r_, b), (cR, cT, t, r_), (cT, cL, l, t)) {
      line(p, q, qq, pp, close: true, fill: YEL.transparentize(62%), stroke: none)
    }
    // 掩模板 + 4×4 网格
    line(cL, cB, cR, cT, close: true, fill: YEL, stroke: (paint: INK, thickness: 0.6pt))
    for k in range(1, 4) {
      let u = -a + k * (2 * a / 4)
      line(at(u, -a), at(u, a), stroke: (paint: INK, thickness: 0.6pt))
      line(at(-a, u), at(a, u), stroke: (paint: INK, thickness: 0.6pt))
    }
    // 光斑（画在掩模之后、晶圆之上）
    line(l, b, r_, t, close: true, fill: YEL_HI, stroke: (paint: INK, thickness: 0.6pt))
  }

  // 等离子体辉光：椭圆上方几层半透明红，靠中心越叠越浓
  let env-plasma(px, ey, rx, ry) = {
    for (k, al) in ((1.02, 86%), (0.80, 82%), (0.56, 76%)) {
      circle((px, ey + ry * 0.50), radius: (rx * k, ry * k * 0.95),
        fill: RED.transparentize(al), stroke: none)
    }
  }

  // 气氛带：椭圆上方一条圆角带，靠上越浓（源图是从上到下的渐变）
  let env-band(px, ytop, fill) = {
    for (k, al) in ((0, 80%), (1, 78%), (2, 76%)) {
      let w = 1.98 - k * 0.22
      let h = 1.02 - k * 0.30
      rect((px - w, ytop - h), (px + w, ytop), radius: 0.42 - k * 0.10,
        fill: fill.transparentize(al), stroke: none)
    }
  }

  // 七、版面：五步排布
  let TITLE_Y = 16.85
  let MASK_Y  = 15.10   // 掩模中心（第 I / V 步）
  let EY      = 12.90   // 晶圆俯视椭圆中心
  let RX      = 2.24
  let RY      = 1.12
  let OY      = 9.10    // 器件投影原点（三维 (0,0,0) 的屏幕 y）
  let LENS_Y  = 6.00
  let LENS_R  = 1.50
  let LEGEND_Y = 1.45

  let PITCH = 5.05
  let PX = range(0, 5).map(i => 3.55 + i * PITCH)

  let TITLES = (
    [I. Pattern bottom electrode],
    [II. Ar plasma],
    [III. Controlled oxidation],
    [IV. Top electrode deposition],
    [V. Pattern top electrode],
  )

  for i in range(0, 5) {
    let px = PX.at(i)
    let step = i + 1
    let ox = px + 0.34
    let lens-c = (px - 1.25, LENS_Y)

    // ① 顶部：工具 / 气氛 + 晶圆俯视
    if step == 2 { env-plasma(px, EY, RX, RY) }
    if step == 3 { env-band(px, 15.75, GREEN) }
    if step == 4 { env-band(px, 15.75, GREY) }

    if step == 1 or step == 5 {
      env-wafer(px, EY, RX, RY, GREY)
      // 光束打到的位置泛黄（源图椭圆里有一块淡黄）
      circle((px, EY + 0.18), radius: (0.62, 0.34),
        fill: YEL.transparentize(50%), stroke: none)
      env-litho(px, EY, MASK_Y)
    } else {
      let fill = if step == 2 { rgb("#cfb4c6") } else if step == 3 {
        rgb("#e0b0d2")
      } else { GREY }
      env-wafer(px, EY, RX, RY, fill)
      if step == 2 {
        // 晶圆表面残留的等离子体红色 + 中间一块灰色的器件
        circle((px, EY + 0.42), radius: (RX * 0.82, RY * 0.62),
          fill: RED.transparentize(80%), stroke: none)
        circle((px + 0.55, EY - 0.10), radius: (0.52, 0.28), fill: ALU, stroke: th)
        for k in range(0, 5) {
          circle((px - 0.9 + k * 0.52, EY - 0.38 + calc.rem(k, 2) * 0.16),
            radius: 0.045, fill: RED, stroke: none)
        }
      }
      if step == 3 {
        // 氧化气氛：椭圆里再压一层粉色雾，表示表面正在氧化
        circle((px, EY + 0.10), radius: (RX * 0.80, RY * 0.66),
          fill: ALOX_B.transparentize(72%), stroke: none)
      }
    }

    // ② 晶圆 → 器件的斜箭头
    let dot = (px - 0.78, EY + 0.42)
    line(dot, (px + 0.30, 10.06), stroke: bold, mark: (end: ">", fill: INK, scale: 0.42))
    circle(dot, radius: 0.055, fill: INK, stroke: none)

    // ③ 等轴测叠层
    layer-stack(ox, OY, step)

    // 第 II 步：等离子体里的 Ar 离子（飘在晶圆上方）+ 三根轰击箭头
    if step == 2 {
      for k in range(0, 46) {
        let u = calc.rem(calc.abs(calc.sin(k * 12.9898) * 43758.545), 1)
        let v = calc.rem(calc.abs(calc.sin(k * 78.233 + 1.7) * 12543.21), 1)
        let w = calc.rem(calc.abs(calc.sin(k * 3.17 + 4.1) * 9871.33), 1)
        let q = P3(ox, OY, 0.25 + 4.9 * u, 0.30 + 4.1 * v, SH + EH + 0.08 + 0.90 * w)
        circle(q, radius: 0.018 + 0.020 * w, fill: RED.transparentize(12%), stroke: none)
      }
      for k in range(0, 3) {
        let xk = 1.35 + k * 0.95
        let yk = 1.05 + k * 0.85
        line(P3(ox, OY, xk, yk, SH + EH + 0.62), P3(ox, OY, xk, yk, SH + EH + 0.10),
          stroke: (paint: RED, thickness: 0.7pt), mark: (end: ">", fill: RED, scale: 0.34))
      }
    }

    // ④ 放大圈 + 引线
    let anchor = P3(ox, OY, PAD.at(0) + 0.50, PAD.at(1), SH + EH + 0.02)
    leader(anchor, lens-c, LENS_R)

    lens-circle(lens-c, LENS_R, (c, r) => {
      // 圈内底：硅片表面
      circle(c, radius: r, fill: SI, stroke: none)
      // 表面纹理：三条很浅的短弧，示意抛光面
      for k in range(0, 3) {
        arc((c.at(0) - r * 0.35 + k * r * 0.42, c.at(1) - r * 0.62),
          start: 20deg, stop: 160deg, radius: r * (0.30 + 0.16 * k),
          stroke: (paint: WHITE.transparentize(45%), thickness: 0.6pt))
      }
      if step == 1 {
        // 光刻后：电极侧壁整片被原生氧化层包住，所以画成纯紫的指条
        lens-finger(c, r, ALOX_N)
      } else if step == 2 {
        // Ar 等离子体轰击：表面被清干净，红点是打在表面上的氩离子
        for (dx, dy, rr) in ((0.30, 0.20, 0.070), (-0.42, 0.52, 0.050),
                             (0.68, -0.10, 0.045), (-0.55, -0.28, 0.038),
                             (0.10, -0.55, 0.055)) {
          circle((c.at(0) + dx * r, c.at(1) + dy * r), radius: rr * r,
            fill: RED, stroke: none)
        }
        lens-finger(c, r, ALU)
        for (dx, dy) in ((-0.20, 0.62), (0.55, 0.55)) {
          line((c.at(0) + dx * r, c.at(1) + (dy + 0.30) * r),
            (c.at(0) + dx * r, c.at(1) + dy * r),
            stroke: (paint: RED, thickness: 0.7pt), mark: (end: ">", fill: RED, scale: 0.32))
        }
      } else if step == 3 {
        // 受控氧化：铝表面覆盖一层粉色 AlOx 势垒层（外圈粉色 = 膜厚）
        lens-finger(c, r, ALU, cap: ALOX_B)
      } else if step == 4 {
        // 顶电极沉积：整段被新沉积的铝包住，表面变成圆鼓鼓的一片
        lens-finger(c, r, ALU)
        rect((c.at(0) - r * 0.86, c.at(1) - r * 0.52), (c.at(0) + r * 0.72, c.at(1) + r * 0.52),
          radius: r * 0.5, fill: ALU, stroke: mid)
        arc((c.at(0) - r * 0.10, c.at(1) + r * 0.02), start: 30deg, stop: 150deg,
          radius: r * 0.46, stroke: (paint: WHITE.transparentize(30%), thickness: 0.7pt))
      } else {
        // 顶电极图形化后：圆形电极台上坐着铝球，球底露出粉色的势垒环
        lens-finger(c, r, ALU)
        circle((c.at(0) + r * 0.28, c.at(1) + r * 0.16), radius: r * 0.40,
          fill: ALU.darken(6%), stroke: mid)
        arc((c.at(0) + r * 0.28, c.at(1) + r * 0.16), start: 232deg, stop: 308deg,
          radius: r * 0.40, stroke: (paint: ALOX_B, thickness: 0.8pt))
        circle((c.at(0) + r * 0.16, c.at(1) + r * 0.30), radius: r * 0.13,
          fill: WHITE.transparentize(35%), stroke: none)
      }
    })

    // ⑤ 标题
    content((px, TITLE_Y), anchor: "center",
      text(size: 9.6pt, weight: "bold", TITLES.at(i)))
  }

  // 八、I → II 之间：破真空
  //    源图在光刻后要破真空，把晶圆送进等离子体腔做原位清洗。
  content((5.92, 11.22), anchor: "center", text(size: 8.4pt, [Vacuum break]))
  line((6.35, 10.98), (7.30, 10.02), stroke: bold, mark: (end: ">", fill: INK, scale: 0.42))

  // 九、底部图例（源图四项必须保留）
  let legend-item(x, fill, label) = {
    rect((x, LEGEND_Y - 0.21), (x + 0.42, LEGEND_Y + 0.21), fill: fill, stroke: mid)
    content((x + 0.56, LEGEND_Y), anchor: "west", text(size: 9.4pt, label))
  }
  legend-item(6.95, ALU, [Aluminum])
  legend-item(10.45, SI, [Silicon])
  legend-item(13.10, ALOX_N, [AlO#sub[x] (native)])
  legend-item(16.85, ALOX_B, [AlO#sub[x] (barrier)])
})
