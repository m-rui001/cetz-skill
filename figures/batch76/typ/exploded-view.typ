// ═══════════════════════════════════════════════════════════════════════
// Fig.8  爆炸视图装配引导线（Exploded view guideline generation）
// 论文：An Automatic Generation Method of Exploded View Based on Projection
//       Manufacturing Technology, 2021, DOI 10.21062/mft.2021.067, Fig.8
//
// 重绘说明：
//   * 全部几何写在「板坐标」(x, y, z) 里，再由 iso() 做等轴测投影，
//     不出现手写透视魔数；改尺寸只动常量即可。
//   * 源图是带灰阶明暗的 CAD 渲染，这里改成干净的线稿：
//     朝上的面近白、朝前的面浅灰，其余全部省略。
//   * 装配逻辑：盖板沿等轴测方向拔出，4 个内六角沉头螺钉再往外拔一级；
//     虚线＝装配引导线（孔轴竖直虚线 + 孔→盖板孔→螺钉的斜向引导线）。
// ═══════════════════════════════════════════════════════════════════════
#set page(width: auto, height: auto, margin: 6pt)
#import "@preview/cetz:0.4.2": canvas, draw
#set text(font: "Arial", size: 7pt)

#canvas({
  import draw: *

  // ═══════════════════ 1. 等轴测投影助手 ═══════════════════
  // 板坐标：x 轴指向画面左下，y 轴指向画面右下，z 轴竖直向上。
  // iso 是线性映射且 iso(0,0,0)=(0,0)，所以也可直接当方向向量用。
  let C30 = calc.cos(30deg) // 0.8660
  let S30 = calc.sin(30deg) // 0.5000
  let iso(x, y, z) = ((y - x) * C30, z - (x + y) * S30)

  // ═══════════════════ 2. 画线工具 ═══════════════════
  let INK = rgb("#111111")
  let TOP = rgb("#fafafa") // 朝上的面
  let SIDE = rgb("#e6e6e6") // 朝前的立面
  let DEEP = rgb("#cfcfcf") // 孔底 / 通孔
  let GHOST = rgb("#4a4a4a") // 引导线
  let LW = 0.6pt

  let pen(t: LW) = (paint: INK, thickness: t, cap: "round", join: "round")
  let ghost = (paint: GHOST, thickness: 0.55pt, dash: "dashed", cap: "round")

  // 水平面（z 为常数）内半径 r 的圆 → 等轴测椭圆（采样成折线，
  // 这样平面内的任何曲线都严格走 iso，不用另写椭圆公式）。
  let ring(f, cx, cy, z, r, n: 64) = range(n).map(i => {
    let a = 2 * calc.pi * i / n
    f(cx + r * calc.cos(a), cy + r * calc.sin(a), z)
  })

  // 圆上一段弧：角度 a0 → a1（弧度）
  let ring-arc(f, cx, cy, z, r, a0, a1, n: 28) = range(n + 1).map(i => {
    let a = a0 + (a1 - a0) * i / n
    f(cx + r * calc.cos(a), cy + r * calc.sin(a), z)
  })

  // 等轴测椭圆在画面上的最左 / 最右点（竖直圆柱的侧影线用）
  let HR = calc.sqrt(2) / 2
  let ring-left(f, cx, cy, z, r) = f(cx + r * HR, cy - r * HR, z) // 画面最左
  let ring-right(f, cx, cy, z, r) = f(cx - r * HR, cy + r * HR, z) // 画面最右

  // 竖直圆柱：两条侧影竖线 + 底面前半圈（可见部分）
  let cylinder(f, cx, cy, z0, z1, r, fill, t: LW) = {
    let pts = (ring-left(f, cx, cy, z1, r), ring-right(f, cx, cy, z1, r))
    pts += ring-arc(f, cx, cy, z0, r, 3 * calc.pi / 4, -calc.pi / 4)
    line(..pts, close: true, fill: fill, stroke: pen(t: t))
  }

  // 水平面内的正六边形（螺钉内六角孔）
  let hexagon(f, cx, cy, z, r) = range(6).map(i => {
    let a = calc.pi / 6 + i * calc.pi / 3
    f(cx + r * calc.cos(a), cy + r * calc.sin(a), z)
  })

  // ═══════════════════ 3. 尺寸常量（板坐标） ═══════════════════
  // —— 底板：主方块 + 靠 +y 侧下沉一级的台阶 ——
  let BX = 10.4 // x 向长
  let BY = 9.4 // y 向长
  let BT = 2.8 // 主方块顶面高度（= 板厚）
  let LY = 7.9 // 台阶分界线 y
  let LT = 1.5 // 台阶顶面高度

  // —— 4 个沉头孔的位置（底板孔与盖板孔同一套坐标）——
  let HX1 = 2.5
  let HX2 = 8.0
  let HY1 = 2.2
  let HY2 = 5.2
  let CB_R = 0.90 // 沉孔口半径（外圈）
  let CB_D = 0.35 // 沉孔深度
  let TH_R = 0.46 // 通孔半径（内圈）

  // —— 盖板 ——
  let PX0 = 0.6
  let PX1 = 9.9
  let PY0 = 0.6
  let PY1 = 6.8
  let PL_T = 0.5 // 盖板厚
  let PL_DY = -3.0 // 爆炸位移（沿 -y，画面上朝左上）
  let PL_Z0 = 5.0 // 爆炸后盖板底面高度
  let PL_Z1 = PL_Z0 + PL_T // 盖板顶面高度
  let SR = 1.15 // 半圆缺口半径
  let SC1_Y = 3.9 // 缺口 1（在 x=PX1 的边上）的 y 位置
  let SC2_X = 5.9 // 缺口 2（在 y=PY1 的边上）的 x 位置

  // —— 螺钉（比盖板再沿同一等轴测方向拔出一级）——
  let HEAD_R = 0.92
  let HEAD_H = 0.30
  let SHANK_R = 0.42
  let SHANK_L = 1.55
  let HEX_R = 0.30
  // 螺钉比盖板再往外一级（同一等轴测方向，拉得更远），
  // 这样钉杆落在盖板轮廓之外、不压住盖板。
  let SCREW_DY = -7.2
  let SCREW_Z = 7.1 // 螺钉头顶面高度

  // ═══════════════════════════════════════════════════════════════
  // 零件 1：底板 —— 主方块 + 一级台阶，顶面开 4 个沉头孔
  // ═══════════════════════════════════════════════════════════════
  let base-block() = {
    // 台阶立面的下半段（+y 侧面）
    line(
      iso(0, BY, 0), iso(BX, BY, 0), iso(BX, BY, LT), iso(0, BY, LT),
      close: true, fill: SIDE, stroke: pen(),
    )
    // 左前立面（+x 侧面），轮廓随台阶拐一次
    line(
      iso(BX, 0, 0), iso(BX, BY, 0), iso(BX, BY, LT), iso(BX, LY, LT),
      iso(BX, LY, BT), iso(BX, 0, BT),
      close: true, fill: SIDE, stroke: pen(),
    )
    // 台阶立面：主方块在 y = LY 处露出的前墙
    line(
      iso(0, LY, LT), iso(BX, LY, LT), iso(BX, LY, BT), iso(0, LY, BT),
      close: true, fill: SIDE, stroke: pen(),
    )
    // 台阶顶面
    line(
      iso(0, LY, LT), iso(BX, LY, LT), iso(BX, BY, LT), iso(0, BY, LT),
      close: true, fill: TOP, stroke: pen(),
    )
    // 主顶面：4 个沉头孔的安装面
    line(
      iso(0, 0, BT), iso(BX, 0, BT), iso(BX, LY, BT), iso(0, LY, BT),
      close: true, fill: TOP, stroke: pen(),
    )
  }

  // 底板上单个沉头孔：外圈沉孔口 + 内圈孔底（两圈椭圆）
  let base-hole(hx, hy) = {
    line(..ring(iso, hx, hy, BT, CB_R), close: true, fill: white, stroke: pen(t: 0.55pt))
    line(..ring(iso, hx, hy, BT - CB_D, TH_R), close: true, fill: DEEP, stroke: pen(t: 0.55pt))
  }

  // ═══════════════════════════════════════════════════════════════
  // 零件 2：盖板 —— 已沿等轴测方向拔出；两条前缘各有一个半圆缺口
  // ═══════════════════════════════════════════════════════════════
  // 盖板局部坐标 → 画布：整体平移 (0, PL_DY, PL_Z0)
  let PP(x, y, z) = iso(x, y + PL_DY, PL_Z0 + z)

  // 盖板可见的两条前缘（x=PX1 与 y=PY1），绕过两个半圆缺口
  let plate-front(z) = {
    let ps = (PP(PX1, PY0, z),)
    // x = PX1 边上的半圆缺口（向内凹）
    ps += ring-arc(PP, PX1, SC1_Y, z, SR, 3 * calc.pi / 2, calc.pi / 2)
    ps.push(PP(PX1, PY1, z))
    // y = PY1 边上的半圆缺口（向内凹）
    ps += ring-arc(PP, SC2_X, PY1, z, SR, 0, -calc.pi)
    ps.push(PP(PX0, PY1, z))
    ps
  }

  let plate() = {
    // 板厚方向的侧壁
    let band = plate-front(PL_T) + plate-front(0).rev()
    line(..band, close: true, fill: SIDE, stroke: none)
    // 底面前缘
    line(..plate-front(0), stroke: pen())
    // 三条可见竖棱
    for q in ((PX1, PY0), (PX1, PY1), (PX0, PY1)) {
      line(PP(q.at(0), q.at(1), 0), PP(q.at(0), q.at(1), PL_T), stroke: pen())
    }
    // 缺口两端的短竖棱
    for q in ((PX1, SC1_Y - SR), (PX1, SC1_Y + SR), (SC2_X + SR, PY1), (SC2_X - SR, PY1)) {
      line(PP(q.at(0), q.at(1), 0), PP(q.at(0), q.at(1), PL_T), stroke: pen(t: 0.5pt))
    }
    // 顶面
    let top = plate-front(PL_T)
    top += (PP(PX0, PY0, PL_T),)
    line(..top, close: true, fill: TOP, stroke: pen())
    // 4 个锥沉孔
    for hy in (HY1, HY2) {
      for hx in (HX1, HX2) {
        line(..ring(PP, hx, hy, PL_T, CB_R), close: true, fill: white, stroke: pen(t: 0.55pt))
        line(..ring(PP, hx, hy, PL_T - 0.22, TH_R), close: true, fill: DEEP, stroke: pen(t: 0.55pt))
      }
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // 零件 3：内六角沉头螺钉（扁圆头 + 圆柱杆 + 六角孔）
  // ═══════════════════════════════════════════════════════════════
  let screw(sx, sy, zt) = {
    // 杆
    cylinder(iso, sx, sy, zt - HEAD_H - SHANK_L, zt - HEAD_H, SHANK_R, rgb("#d5d5d5"))
    // 头：沉头锥面（上圈大、下圈小），两侧接画面最左/最右的侧影
    let hz = zt - HEAD_H
    let cone = (ring-left(iso, sx, sy, zt, HEAD_R), ring-right(iso, sx, sy, zt, HEAD_R))
    cone += ring-arc(iso, sx, sy, hz, HEAD_R * 0.60, 3 * calc.pi / 4, -calc.pi / 4)
    line(..cone, close: true, fill: rgb("#f2f2f2"), stroke: pen())
    // 头顶面
    line(..ring(iso, sx, sy, zt, HEAD_R), close: true, fill: white, stroke: pen())
    // 内六角
    line(..hexagon(iso, sx, sy, zt, HEX_R), close: true, fill: rgb("#c8c8c8"), stroke: pen(t: 0.5pt))
  }

  // ═══════════════════════════════════════════════════════════════
  // 装配引导线（虚线）：孔轴竖直虚线 + 孔 → 盖板孔 → 螺钉 的斜向线
  // ═══════════════════════════════════════════════════════════════
  let guide(hx, hy) = {
    // (a) 孔轴：底板孔口到装配位的竖直虚线
    line(iso(hx, hy, BT), iso(hx, hy, PL_Z1), stroke: ghost)
    // (b) 装配引导折线：底板孔 → 盖板孔 → 螺钉轴线
    line(
      iso(hx, hy, BT),
      iso(hx, hy + PL_DY, PL_Z1),
      iso(hx, hy + SCREW_DY, SCREW_Z),
      stroke: ghost,
    )
  }

  // ═══════════════════════════════════════════════════════════════
  // 左下角坐标三轴
  // ═══════════════════════════════════════════════════════════════
  let axis-triad(ox, oy, len) = {
    let o = (ox, oy)
    let dirs = (
      (iso(len, 0, 0), "x", (-0.28, 0.34)),
      (iso(0, len, 0), "y", (0.30, 0.30)),
      (iso(0, 0, len), "z", (0.0, 0.32)),
    )
    for (v, name, off) in dirs {
      let tip = (ox + v.at(0), oy + v.at(1))
      line(o, tip, stroke: pen(t: 0.7pt), mark: (end: "stealth", fill: INK, scale: 2.2))
      content(
        (tip.at(0) + off.at(0), tip.at(1) + off.at(1)),
        text(style: "italic", size: 7pt, name),
        anchor: "center",
      )
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // 组装顺序：底板 → 沉头孔 → 盖板 → 装配引导线 → 螺钉 → 坐标三轴
  // ═══════════════════════════════════════════════════════════════
  base-block()
  for hy in (HY1, HY2) {
    for hx in (HX1, HX2) { base-hole(hx, hy) }
  }

  plate()

  for hy in (HY1, HY2) {
    for hx in (HX1, HX2) { guide(hx, hy) }
  }

  for hy in (HY1, HY2) {
    for hx in (HX1, HX2) { screw(hx, hy + SCREW_DY, SCREW_Z) }
  }

  axis-triad(-7.4, -9.6, 1.9)
})
