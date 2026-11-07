// FZG 齿轮试验台侧视示意图（剖视）
// 源图：Influence of Oil Degradation on Power Losses and Thermal Behavior of a
//       Gear Transmission Test Rig（HAL hal-05194416, 2025）Figure 4
//       "Scheme of the FZG test rig"
//
// 从左到右：Test box (TB) → 传动轴 → Loading system（中间加载/联接）→ Slave box (SB)
//           → Torquemeter（扭矩仪）→ Motor。两箱体剖视，箱内各一对齿轮上下啮合，
//           轴上四端轴承（蓝）、轴颈密封（灰）、腔内润滑油（黄）。
// 坐标约定：直接沿用源图像素坐标系（y 向下），绘制时统一除以 150 换成 cm，
//           因此所有数字都能在源图上量到，便于逐件对照。
#set page(width: auto, height: auto, margin: 6pt)
#import "@preview/cetz:0.4.2": canvas, draw
#set text(font: "Arial", size: 8pt)

#canvas({
  import draw: *

  // ---------------- 坐标系与调色板 ----------------
  // 源图像素 → 画布 cm：1 单位 = 150 px，原点取源图 (483, 1160) 左下角
  let SCALE = 150.0
  let OX = 483.0
  let OY = 1160.0
  let ux(x) = (x - OX) / SCALE
  let uy(y) = (OY - y) / SCALE
  let P(x, y) = (ux(x), uy(y))

  let INK = rgb("#222222")      // 所有结构线（黑）
  let PANEL = rgb("#f1f2f1")    // 试验台底板（浅灰）
  let HATCH = rgb("#d5d5d5")    // 箱体剖面线（浅灰斜线）
  let STEEL = rgb("#d8d9d8")    // 轴 / 电机外壳 / 扭矩仪端块
  let PLATE = rgb("#efefed")    // 箱体未剖的盖板
  let GEAR = rgb("#ff0000")     // 齿轮（红，图例）
  let BEARING = rgb("#0e57d5")  // 轴承（蓝，图例）
  let SEAL = rgb("#9e9f9e")     // 密封（灰，图例）
  let OIL = rgb("#ffc000")      // 润滑油（黄，图例）
  let RIB = rgb("#7f7f7f")      // 电机散热筋
  let PITCH = rgb("#8c1010")    // 齿轮节线（红底上的暗红虚线）

  let ink(t) = (paint: INK, thickness: t)

  // 归一化矩形：两个角点顺序任意，均按源图像素给出
  let rct(x0, y0, x1, y1, fill: none, stroke: ink(0.45pt), radius: 0) = {
    let (ax, bx) = (calc.min(x0, x1), calc.max(x0, x1))
    let (ay, by) = (calc.min(y0, y1), calc.max(y0, y1))
    rect(P(ax, ay), P(bx, by), fill: fill, stroke: stroke, radius: radius)
  }

  // 45° 剖面线：把 x + y = c 的平行线裁到矩形范围内（源图斜线方向为↘）
  let hatch(x0, y0, x1, y1, gap: 20, t: 2pt) = {
    let ax = ux(x0)
    let bx = ux(x1)
    let ay = uy(y1)                       // 翻转后矩形下边
    let by = uy(y0)                       // 翻转后矩形上边
    let g = gap / SCALE
    let n = int((ax + ay - (bx + by)) * -1 / g + 0.5)
    for i in range(n + 1) {
      let c = ax + ay + i * g
      let xa = calc.max(ax, c - by)
      let xb = calc.min(bx, c - ay)
      if xa < xb {
        line((xa, c - xa), (xb, c - xb), stroke: (paint: HATCH, thickness: t))
      }
    }
  }

  // ---------------- 底板 ----------------
  // 试验台底衬：浅灰大矩形，仅托住 TB / SB 与传动轴，不含电机
  rct(483, 320, 2226, 1073, fill: PANEL, stroke: none)

  // ---------------- 剖视箱体 ----------------
  // 箱体 = 外壁（32px 厚，45° 剖面线带）+ 内腔（润滑油）+ 侧盖板 + 盖上两个工艺孔。
  // plate-side 指明未剖盖板在哪一侧：TB 在右，SB 在左（两箱镜像）。
  let box(x0, y0, x1, y1, plate-side: "right") = {
    let wall = 32
    let cy0 = y0 + 25
    let cy1 = y1 - 30
    let cx0 = if plate-side == "right" { x0 + wall } else { x0 + 149 }
    let cx1 = if plate-side == "right" { x1 - 149 } else { x1 - wall }
    let (px0, px1) = if plate-side == "right" { (cx1 + wall, x1) } else { (x0, cx0 - wall) }

    // 壁带：上、下两条横贯整箱，左右两条夹住内腔；白底 + 45° 剖面线
    for b in ((x0, y0, x1, cy0), (x0, cy1, x1, y1), (x0, cy0, cx0, cy1), (cx1, cy0, cx1 + wall, cy1)) {
      rct(b.at(0), b.at(1), b.at(2), b.at(3), fill: white, stroke: none)
      hatch(b.at(0), b.at(1), b.at(2), b.at(3))
    }
    // 侧盖板压在壁带之上（未剖，故不画剖面线），遮住壁带在盖板侧的部分
    rct(px0, y0, px1, y1, fill: PLATE, stroke: ink(0.45pt))
    // 箱壁轮廓（轴颈处随后被轴盖住，与源图一致）
    rct(x0, y0, x1, y1, fill: none, stroke: ink(0.55pt))
    // 内腔：整腔注满润滑油
    rct(cx0, cy0, cx1, cy1, fill: OIL, stroke: ink(0.45pt))
    // 盖板上的两个圆孔（上下各一，源图为工艺/观察孔）
    let ccx = if plate-side == "right" { 873 } else { 1805 }
    for cyy in (508, 870) {
      circle(P(ccx, cyy), radius: 30 / SCALE, fill: white, stroke: ink(0.4pt))
    }
  }

  // Test box (TB)：左箱，未剖盖板在右
  box(593, 393, 927, 990, plate-side: "right")
  // Slave box (SB)：右箱，未剖盖板在左（与 TB 镜像）
  box(1751, 393, 2086, 990, plate-side: "left")

  // ---------------- 齿轮 ----------------
  // 单个齿轮（剖视，源图为端面朝外的侧视）：窄轮缘 + 靠轴的宽轮毂环 + 齿顶短竖线。
  // 轮缘 63px 宽（齿轮作用宽度），轮毂环 90px 宽（贴轴的那一圈凸缘）。
  // 齿数、模数不复刻，只保证"一对齿轮 + 啮合位置"与源图一致。
  let gear(cx, cy, tip, root: 36, width: 63, hub-w: 90, hub: (25, 36), ticks: 5) = {
    let hw = width / 2
    let hh = hub-w / 2
    for sgn in (1, -1) {
      // 轮缘（自轮毂环外缘一直到齿顶）
      rct(cx - hw, cy - sgn * root, cx + hw, cy - sgn * tip, fill: GEAR, stroke: ink(0.45pt))
      // 轮毂环（贴轴，比轮缘宽，形成台阶）
      rct(cx - hh, cy - sgn * hub.at(0), cx + hh, cy - sgn * hub.at(1), fill: GEAR, stroke: ink(0.45pt))
      // 齿形短线：齿顶带上的短竖线
      for i in range(ticks) {
        let x = cx - hw + width * (i + 0.5) / ticks
        line(P(x, cy - sgn * (tip - 12)), P(x, cy - sgn * tip), stroke: ink(0.32pt))
      }
    }
  }

  // 一对啮合齿轮：大轮装在上方快轴上、小轮装在下方慢轴上，两齿顶在 y≈705 处相切
  let gear-pair(cx, y-fast, y-slow, tip-fast: 104, tip-slow: 70, window: 60) = {
    // 上齿轮（大轮，位于上方快轴）
    gear(cx, y-fast, tip-fast, root: 35, width: 63, hub-w: 90, hub: (25, 34))
    // 下齿轮（小轮，位于下方慢轴）
    gear(cx, y-slow, tip-slow, root: 38, width: 63, hub-w: 90, hub: (25, 37))
    // 节线：两轮在啮合点相切，剖视下节圆退化为过啮合点的一条公切线（点划线）
    // 源图此处只有一条细实线，这里用点划线把它标成"节线"，便于读出啮合位置
    let ymesh = (y-fast + tip-fast + y-slow - tip-slow) / 2
    line(
      P(cx - window, ymesh), P(cx + window, ymesh),
      stroke: (paint: PITCH, thickness: 0.4pt, dash: (2pt, 1.2pt, 0.4pt, 1.2pt)),
    )
  }

  gear-pair(700, 600, 775)
  gear-pair(1977, 600, 775)

  // ---------------- 轴承 ----------------
  // 轴承符号：箱壁轴承孔内上下各一块蓝色方块，块内十字分四格；
  // 上下两块夹住轴，合起来即一个轴端轴承。
  let bearing(x0, x1, yc) = {
    for (ya, yb) in ((yc - 54, yc - 25), (yc + 26, yc + 55)) {
      rct(x0, ya, x1, yb, fill: BEARING, stroke: ink(0.35pt))
      line(P((x0 + x1) / 2, ya), P((x0 + x1) / 2, yb), stroke: ink(0.35pt))
      line(P(x0, (ya + yb) / 2), P(x1, (ya + yb) / 2), stroke: ink(0.35pt))
    }
  }

  // ---------------- 密封 ----------------
  // 密封符号：箱壁外侧轴颈处的灰色小方块，内画一条对角线。
  let seal(x0, y0) = {
    rct(x0, y0, x0 + 23, y0 + 23, fill: SEAL, stroke: ink(0.35pt))
    // 源图的密封符号：一条对角线 + 右侧一道竖线
    line(P(x0 + 4, y0 + 3), P(x0 + 19, y0 + 19), stroke: ink(0.35pt))
    line(P(x0 + 19, y0 + 3), P(x0 + 19, y0 + 19), stroke: ink(0.35pt))
  }

  // ---------------- 轴端端盖 ----------------
  // 轴伸出箱壁处的阶梯端盖（源图为两级凸台），只在 TB 左侧 / SB 右侧出现。
  let end-cover(x-wall, yc, dir) = {
    let a = x-wall + dir * 52
    let b = x-wall + dir * 20
    rct(x-wall, yc - 78, a, yc + 78, fill: white, stroke: ink(0.4pt))
    rct(b, yc - 52, x-wall + dir * 4, yc + 52, fill: white, stroke: ink(0.4pt))
  }

  // TB 左侧端盖 + 两侧轴承 + 密封
  end-cover(593, 600, -1)
  end-cover(593, 775, -1)
  bearing(593, 624, 600)
  bearing(780, 810, 600)
  bearing(593, 624, 775)
  bearing(780, 810, 775)
  // SB 右侧端盖 + 轴承 + 密封
  end-cover(2086, 600, 1)
  end-cover(2086, 775, 1)
  bearing(1868, 1899, 600)
  bearing(2055, 2086, 600)
  bearing(1868, 1899, 775)
  bearing(2055, 2086, 775)
  // 密封：每根轴每侧箱壁上下各一个（TB 左/右、SB 左/右）
  for x in (569, 812, 1844, 2087) {
    for yc in (600, 775) {
      seal(x, yc - 47)
      seal(x, yc + 26)
    }
  }

  // ---------------- 传动轴 ----------------
  // 长轴：灰色实心 + 黑轮廓；上轴贯穿 TB→SB→扭矩仪，下轴贯穿 TB→SB（右端止于 SB 端盖）。
  let shaft(x0, x1, yc, d: 48) = {
    rct(x0, yc - d / 2, x1, yc + d / 2, fill: STEEL, stroke: ink(0.45pt))
  }

  shaft(507, 2169, 600)   // 快轴：TB 上齿轮 → SB 上齿轮 → 扭矩仪
  shaft(507, 2137, 775)   // 慢轴：TB 下齿轮 → 加载系统 → SB 下齿轮

  // ---------------- 中间加载 / 联接系统 ----------------
  // Loading system：两片加载盘夹在中间，两侧各一个轮毂套在慢轴上，右盘带压紧螺栓。
  let coupling(cx, yc) = {
    // 两侧轮毂
    rct(cx - 74, yc - 51, cx - 39, yc + 55, fill: white, stroke: ink(0.45pt))
    rct(cx + 39, yc - 51, cx + 74, yc + 55, fill: white, stroke: ink(0.45pt))
    // 两片加载盘（上下凸出到轴外）
    rct(cx - 37, yc - 124, cx - 1, yc + 124, fill: white, stroke: ink(0.55pt))
    rct(cx + 1, yc - 124, cx + 37, yc + 124, fill: white, stroke: ink(0.55pt))
    // 压紧螺栓：右盘上下各一组斜撑 + 螺帽
    for sgn in (1, -1) {
      let y0 = yc - sgn * 67
      let y1 = yc - sgn * 109
      line(P(cx + 37, y0), P(cx + 45, y0 - sgn * 11), P(cx + 45, y1 + sgn * 11), P(cx + 37, y1), stroke: ink(0.4pt))
      rct(cx + 47, yc - sgn * 71, cx + 63, yc - sgn * 101, fill: white, stroke: ink(0.4pt))
    }
  }

  coupling(1377, 775)

  // ---------------- 扭矩仪 ----------------
  // Torquemeter：两端灰色联轴块，中间一段黑白相间的测量栅；下方箭头引出标签。
  let torquemeter(x0, yc) = {
    rct(x0, yc - 55, x0 + 163, yc + 56, fill: white, stroke: ink(0.45pt))
    rct(x0 + 4, yc - 53, x0 + 49, yc + 53, fill: STEEL, stroke: ink(0.4pt))
    rct(x0 + 118, yc - 53, x0 + 163, yc + 53, fill: STEEL, stroke: ink(0.4pt))
    for i in range(4) {
      let x = x0 + 56 + i * 15
      rct(x, yc - 53, x + 4, yc + 53, fill: INK, stroke: none)
    }
    // 测量栅与两侧联轴块的分界线
    line(P(x0 + 50, yc - 53), P(x0 + 50, yc + 53), stroke: ink(0.4pt))
    line(P(x0 + 113, yc - 53), P(x0 + 113, yc + 53), stroke: ink(0.4pt))
    // 引出箭头：从标签竖直指到扭矩仪底部
    line(P(x0 + 117, yc + 272), P(x0 + 117, yc + 104), stroke: ink(1pt))
    line(P(x0 + 108, yc + 116), P(x0 + 117, yc + 97), P(x0 + 126, yc + 116), close: true, fill: INK, stroke: none)
  }

  torquemeter(2170, 600)

  // ---------------- 电机 ----------------
  // Motor：左端轴 + 两端圆角端盖 + 中段带散热筋的机壳（两条压紧环）。
  let motor(x0, yc) = {
    // 输入轴
    rct(x0, yc - 24, x0 + 38, yc + 24, fill: STEEL, stroke: ink(0.45pt))
    // 左端盖
    rct(x0 + 38, yc - 162, x0 + 139, yc + 162, fill: STEEL, stroke: ink(0.45pt), radius: (west: 0.24, rest: 0))
    // 压紧环
    rct(x0 + 141, yc - 162, x0 + 156, yc + 162, fill: STEEL, stroke: ink(0.4pt))
    rct(x0 + 515, yc - 162, x0 + 530, yc + 162, fill: STEEL, stroke: ink(0.4pt))
    // 机壳：白底 + 水平散热筋
    rct(x0 + 157, yc - 172, x0 + 513, yc + 172, fill: white, stroke: ink(0.45pt))
    for i in range(23) {
      let y = yc - 169 + i * 15
      line(P(x0 + 157, y), P(x0 + 513, y), stroke: (paint: RIB, thickness: 0.8pt))
    }
    // 右端盖
    rct(x0 + 532, yc - 170, x0 + 696, yc + 171, fill: STEEL, stroke: ink(0.45pt), radius: (east: 0.24, rest: 0))
  }

  motor(2333, 600)

  // ---------------- 文字标注 ----------------
  // 五个部件名，位置与源图一致（箱体名在箱体上方，加载系统/扭矩仪在下方）
  let lbl(x, y, body, size: 8.6pt) = content(P(x, y), anchor: "center", text(size: size, body))

  lbl(761, 264, [Test box (TB)])
  lbl(1951, 262, [Slave box (SB)])
  lbl(2658, 374, [Motor], size: 9.6pt)
  lbl(1379, 941, [Loading system])
  lbl(2413, 894, [Torquemeter])

  // ---------------- 图例 ----------------
  // 图例色块：Gears 红 / Bearings 蓝 / Seals 灰 / Lubricant 黄（与正文配色同源）
  let legend-swatch(x, y, color, body) = {
    rct(x, y, x + 62, y + 48, fill: color, stroke: ink(0.35pt))
    content(P(x + 107, y + 24), anchor: "west", text(size: 8pt, body))
  }

  legend-swatch(721, 1109, GEAR, [Gears])
  legend-swatch(1018, 1109, BEARING, [Bearings])
  legend-swatch(1378, 1109, SEAL, [Seals])
  legend-swatch(1668, 1109, OIL, [Lubricant])
})
