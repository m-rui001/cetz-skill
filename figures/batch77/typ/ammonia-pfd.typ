// 氨厂工艺流程图（PFD）—— 15 台主要设备与管线网络
// 源图：Process Flow Diagram of an Ammonia Plant as a Complex Network
//       (arXiv physics/0504177) Figure 1
//
// 重绘原则：设备顺序、管线分支、编号位置与源图语义一致；
// 设备符号全部由命名函数抽象（vessel / packed-column / tray-column /
// reactor / compressor / tank / chiller），线宽统一 0.6–0.7pt，纯黑白线稿。
#set page(width: auto, height: auto, margin: 6pt)
#import "@preview/cetz:0.4.2": canvas, draw
#set text(font: ("Times New Roman", "DejaVu Serif"), size: 6pt)

#canvas({
  import draw: *

  // ---------------- 基础笔触、文字与箭头 ----------------
  // 主线 0.7pt、细线（塔板 / 阴影 / 支撑环等）0.6pt
  let LW = 0.7pt
  let ink = (paint: black, thickness: LW, cap: "round")
  let thin = (paint: black, thickness: 0.6pt, cap: "round")
  let dash = (paint: black, thickness: 0.6pt, dash: "dashed")

  // 居中文字：设备编号 1–15
  let lbl(x, y, body, size: 10pt) = content((x, y), anchor: "center", text(size: size, body))
  // 左对齐文字：Steam / Oil / Air / Oxygen 入口标签
  let tag(x, y, body, size: 10pt) = content((x, y), anchor: "west", text(size: size, body))

  // 实心流向箭头：尖端在 tip，方向 dir
  let head(tip, dir, s: 0.17) = {
    let dx = dir.at(0)
    let dy = dir.at(1)
    let L = calc.sqrt(dx * dx + dy * dy)
    let ux = dx / L
    let uy = dy / L
    let bx = tip.at(0) - ux * s
    let by = tip.at(1) - uy * s
    let hw = s * 0.42
    line(
      tip, (bx - uy * hw, by + ux * hw), (bx + uy * hw, by - ux * hw),
      close: true, fill: black, stroke: none,
    )
  }

  // 正交折线管线
  let pl(..pts) = line(..pts, stroke: ink)

  // 45° 斜线阴影，限定在矩形 [xl,xr]×[yb,yt] 内
  let hatch(xl, xr, yb, yt, gap: 0.15) = {
    let w = xr - xl
    let hb = yt - yb
    let s = -hb + gap
    while s < w {
      let ya = if s < 0 { yb - s } else { yb }
      let yb2 = if s + hb > w { yb + (w - s) } else { yt }
      if yb2 - ya > 0.03 {
        line((xl + s + (ya - yb), ya), (xl + s + (yb2 - yb), yb2), stroke: thin)
      }
      s = s + gap
    }
  }

  // ---------------- 设备符号函数 ----------------
  // 立式筒体：左右母线 + 上下椭圆封头（y0 为底，h 为总高）
  let vessel(cx, y0, w, h, head-r: 0.30) = {
    let xl = cx - w / 2
    let xr = cx + w / 2
    let yt = y0 + h
    line((xl, y0 + head-r), (xl, yt - head-r), stroke: ink)
    line((xr, y0 + head-r), (xr, yt - head-r), stroke: ink)
    // 下封头
    bezier((xl, y0 + head-r), (xr, y0 + head-r), (xl, y0 - head-r / 3), (xr, y0 - head-r / 3), stroke: ink)
    // 上封头
    bezier((xl, yt - head-r), (xr, yt - head-r), (xl, yt + head-r / 3), (xr, yt + head-r / 3), stroke: ink)
  }

  // 填料塔：筒体 + 上下填料层界线 + 交叉填料线
  let packed-column(cx, y0, w, h, zone: (0.42, 2.34), head-r: 0.30) = {
    vessel(cx, y0, w, h, head-r: head-r)
    let xl = cx - w / 2
    let xr = cx + w / 2
    let ya = y0 + zone.at(0)
    let yb = y0 + zone.at(1)
    line((xl, ya), (xr, ya), stroke: ink)
    line((xl, yb), (xr, yb), stroke: ink)
    line((xl, ya), (xr, yb), stroke: thin)
    line((xl, yb), (xr, ya), stroke: thin)
  }

  // 板式塔：筒体 + 均布水平塔板（实线或虚线）
  let tray-column(cx, y0, w, h, trays: 4, dashed: true, head-r: 0.30) = {
    vessel(cx, y0, w, h, head-r: head-r)
    let xl = cx - w / 2
    let xr = cx + w / 2
    let st = if dashed { dash } else { thin }
    for i in range(trays) {
      let y = y0 + h * (0.22 + 0.60 * i / calc.max(1, trays - 1))
      line((xl, y), (xr, y), stroke: st)
    }
  }

  // 反应器：筒体 + 中部 45° 斜线阴影；horizontal 为卧式（两端半圆封头）
  let reactor(x0, y0, w, h, hatch-zone: (), horizontal: false) = {
    if horizontal {
      let r = h / 2
      let xl = x0 + r
      let xr = x0 + w - r
      let yt = y0 + h
      line((xl, y0), (xr, y0), stroke: ink)
      line((xl, yt), (xr, yt), stroke: ink)
      // 两端半圆封头
      bezier((xl, y0), (xl, yt), (xl - 4 * r / 3, y0), (xl - 4 * r / 3, yt), stroke: ink)
      bezier((xr, y0), (xr, yt), (xr + 4 * r / 3, y0), (xr + 4 * r / 3, yt), stroke: ink)
      // 阴影区（x 范围）与两条界线
      if hatch-zone.len() == 2 {
        let ha = hatch-zone.at(0)
        let hb = hatch-zone.at(1)
        line((ha, y0), (ha, yt), stroke: ink)
        line((hb, y0), (hb, yt), stroke: ink)
        hatch(ha, hb, y0, yt)
      }
    } else {
      let cx = x0 + w / 2
      vessel(cx, y0, w, h)
      if hatch-zone.len() == 2 {
        let ha = hatch-zone.at(0)
        let hb = hatch-zone.at(1)
        line((x0, ha), (x0 + w, ha), stroke: ink)
        line((x0, hb), (x0 + w, hb), stroke: ink)
        hatch(x0, x0 + w, ha, hb)
      }
    }
  }

  // 压缩机：梯形叶轮室 + 叶轮轴 + 扩张锥 + 锥内流向箭头
  let compressor(x0, xw, xc0, xc1, cy) = {
    line((x0, cy - 0.48), (x0, cy + 0.48), (xw, cy + 0.76), (xw, cy - 0.76), close: true, stroke: ink)
    line((xw, cy), (xc0, cy), stroke: ink)
    line((xc0, cy - 0.70), (xc0, cy + 0.70), (xc1, cy + 0.32), (xc1, cy - 0.32), close: true, stroke: ink)
    line((xc0 + 0.35, cy), (xc1 - 0.34, cy), stroke: thin)
    head((xc1 - 0.34, cy), (1, 0), s: 0.14)
  }

  // 储罐：矩形罐体 + 斜肩 + 顶部瓶颈
  let tank(cx, y0, w, h) = {
    let xl = cx - w / 2
    let xr = cx + w / 2
    let yt = y0 + h
    line(
      (xl, y0), (xl, yt), (cx - 0.40, yt + 0.30), (cx - 0.40, yt + 0.70),
      (cx + 0.40, yt + 0.70), (cx + 0.40, yt + 0.30), (xr, yt), (xr, y0),
      close: true, stroke: ink,
    )
  }

  // 冷冻机组：卧式壳体（短立壁 + 斜肩）+ 两端管板法兰 + 两道支撑环 + 折流板 + 中部膨胀节
  let chiller(x0, y0, x1, y1) = {
    let ym = (y0 + y1) / 2
    let yf = ym - 0.24          // 端部管板法兰中心（略偏下，与源图一致）
    let hw = 0.34               // 法兰半高
    // 壳体：底边 + 两端短立壁 + 斜肩 + 顶边
    line(
      (x0, y0), (x0, y0 + 0.61), (x0 + 1.10, y1), (x1 - 1.10, y1),
      (x1, y0 + 0.61), (x1, y0), close: true, stroke: ink,
    )
    // 左 / 右端管板法兰（半圆封头的小筒体，ox 为壳体端向外方向）
    for (sx, ox) in ((x0, -1), (x1, 1)) {
      line((sx - 0.25 * ox, yf - hw), (sx + 0.55 * ox, yf - hw), stroke: ink)
      line((sx - 0.25 * ox, yf + hw), (sx + 0.55 * ox, yf + hw), stroke: ink)
      bezier(
        (sx + 0.55 * ox, yf - hw), (sx + 0.55 * ox, yf + hw),
        (sx + 1.10 * ox, yf - hw), (sx + 1.10 * ox, yf + hw), stroke: ink,
      )
      line((sx - 0.25 * ox, yf - hw), (sx - 0.25 * ox, yf + hw), stroke: ink)
      line((sx + 0.55 * ox, yf), (sx - 0.25 * ox, yf), stroke: thin)
    }
    // 两道支撑环
    for rx in (x0 + 1.40, x1 - 1.40) {
      rect((rx - 0.20, y0 - 0.15), (rx + 0.20, y1 + 0.15), stroke: thin)
    }
    // 折流板
    for bx in (x0 + 2.20, x1 - 1.80) {
      line((bx, y0), (bx, ym + 0.42), stroke: thin)
    }
    // 中部膨胀节（两条交叉 S 形波纹线，中间收腰）
    let cx = (x0 + x1) / 2
    bezier((cx - 0.30, y1), (cx + 0.30, y0), (cx + 0.28, y1 - 0.45), (cx - 0.28, y0 + 0.45), stroke: ink)
    bezier((cx + 0.30, y1), (cx - 0.30, y0), (cx - 0.28, y1 - 0.45), (cx + 0.28, y0 + 0.45), stroke: ink)
  }

  // ================= 设备（1–15，各调用一次）=================
  // 1 号 气化反应器：立式带斜线阴影，顶部另有喷头
  reactor(4.05, 7.29, 1.60, 2.22, hatch-zone: (7.59, 9.09))
  // 1 号附属：顶部喷头小筒（筒内小圆为喷孔）
  vessel(4.69, 9.19, 0.53, 1.10, head-r: 0.26)
  circle((4.69, 10.02), radius: 0.075, stroke: thin)
  line((4.69, 9.94), (4.69, 9.52), stroke: thin)
  // 1 号附属：并排的余热锅炉（长筒，源图未编号）
  vessel(6.30, 7.54, 0.70, 3.07, head-r: 0.35)

  // 2 号 碳洗塔：填料塔
  packed-column(8.52, 6.99, 1.35, 2.65, zone: (0.42, 2.34))
  // 3 号 H2S 吸收塔：板式塔
  tray-column(11.12, 6.99, 1.35, 2.65, trays: 3, dashed: false)
  // 4 号 增湿器：填料塔
  packed-column(13.65, 6.99, 1.30, 2.65, zone: (0.42, 2.34))
  // 5 号 变换炉：带斜线阴影的反应器
  reactor(15.65, 6.99, 1.20, 2.65, hatch-zone: (7.59, 9.04))
  // 6 号 脱水器：填料塔
  packed-column(18.72, 6.99, 1.25, 2.65, zone: (0.42, 2.34))
  // 7 号 CO2 吸收塔：板式塔
  tray-column(21.40, 6.99, 1.30, 2.65, trays: 4, dashed: true)

  // 8 号 空气压缩机
  compressor(2.20, 3.45, 4.00, 9.45, 3.39)
  // 9 号 压力塔（空分）：板式塔
  tray-column(10.95, 1.94, 1.30, 2.60, trays: 4, dashed: true)
  // 10 号 氮气压缩机
  compressor(12.40, 13.30, 14.00, 20.00, 3.39)
  // 11 号 氮洗塔：细高板式塔
  tray-column(21.60, 1.94, 0.70, 4.20, trays: 5, dashed: true)

  // 12 号 合成气压缩机
  compressor(23.50, 24.75, 25.40, 29.90, 8.89)
  // 13 号 氨合成塔：卧式反应器，中部斜线阴影
  reactor(23.80, 4.89, 6.20, 1.60, hatch-zone: (25.40, 28.20), horizontal: true)
  // 14 号 冷冻机组
  chiller(24.00, 2.69, 29.60, 4.19)
  // 15 号 液氨储罐
  tank(33.08, 3.19, 3.10, 2.85)

  // ================= 管线网络 =================
  // Steam：由左侧进入 1 号反应器顶部喷头
  pl((2.00, 9.94), (4.40, 9.94))
  head((4.40, 9.94), (1, 0))
  // Steam 支路：自下方（Oxygen 汇合点）上升并入蒸汽线
  pl((3.80, 9.94), (3.80, 5.59))
  head((3.80, 7.30), (0, 1))
  // Oil：左下方进入，绕到 1 号反应器顶部
  pl((2.00, 5.79), (3.30, 5.79), (3.30, 9.63), (4.40, 9.63))
  head((4.40, 9.63), (1, 0))
  // Air：进入 8 号空气压缩机入口
  pl((2.00, 5.19), (4.70, 5.19), (4.70, 4.09))
  head((4.70, 4.05), (0, -1))
  // Oxygen：横向干线向左输送，并折向下进入 9 号压力塔下部
  pl((3.80, 5.59), (12.37, 5.59))
  head((6.60, 5.59), (-1, 0))
  pl((12.37, 5.59), (12.37, 4.93))
  pl((12.37, 4.75), (12.37, 2.64), (11.60, 2.64))
  // 1 号反应器 → 余热锅炉（带两只法兰短节）
  pl((5.65, 8.09), (5.95, 8.09))
  rect((5.66, 8.01), (5.75, 8.17), stroke: thin)
  rect((5.86, 8.01), (5.95, 8.17), stroke: thin)
  // 余热锅炉 → 2 号碳洗塔
  pl((6.65, 7.79), (7.85, 7.79))
  head((7.85, 7.79), (1, 0))
  // 2 号塔顶气相 → 3 号塔下部进料
  pl((8.52, 9.64), (8.52, 10.59), (9.80, 10.59), (9.80, 7.74), (10.45, 7.74))
  head((9.80, 9.10), (0, -1))
  head((10.45, 7.74), (1, 0))
  // 3 号塔顶气相 → 4 号塔下部进料
  pl((11.12, 9.64), (11.12, 10.59), (12.35, 10.59), (12.35, 7.74), (13.00, 7.74))
  head((12.35, 9.10), (0, -1))
  head((13.00, 7.74), (1, 0))
  // 4 号塔顶气相 → 汇合点（向左）
  pl((13.65, 9.64), (13.65, 10.59), (14.95, 10.59))
  head((14.60, 10.59), (1, 0))
  // 5 号塔顶气相 → 同一汇合点（向右），合并后向下进入 5 号塔下部
  pl((16.25, 9.64), (16.25, 10.59), (14.95, 10.59))
  head((15.30, 10.59), (-1, 0))
  pl((14.95, 10.59), (14.95, 7.74), (15.65, 7.74))
  head((14.95, 9.60), (0, -1))
  head((15.65, 7.74), (1, 0))
  // 5 号塔底回流 → 6 号塔下部进料
  pl((16.25, 6.99), (16.25, 6.84), (17.70, 6.84), (17.70, 7.64), (18.10, 7.64))
  head((17.70, 7.30), (0, 1))
  head((18.10, 7.64), (1, 0))
  // 6 号塔顶气相 → 7 号塔下部进料
  pl((18.72, 9.64), (18.72, 10.59), (19.85, 10.59), (19.85, 7.74), (20.75, 7.74))
  head((19.85, 9.10), (0, -1))
  head((20.75, 7.74), (1, 0))
  // 7 号塔顶气相 → 沿右侧长立管下行 → 11 号氮洗塔中部
  pl((21.40, 9.64), (21.40, 10.59), (22.55, 10.59), (22.55, 3.32), (21.95, 3.32))
  head((21.95, 3.32), (-1, 0))
  // 顶部长回流线：自右侧（13/14 出口立管）向左横穿全图 → 11 号塔顶
  pl((30.85, 10.59), (22.87, 10.59))
  head((28.20, 10.59), (-1, 0))
  head((23.60, 10.59), (-1, 0))
  pl((22.87, 10.59), (22.87, 6.61))
  pl((22.87, 6.61), (22.68, 6.61))
  pl((22.42, 6.61), (21.60, 6.61), (21.60, 6.14))
  // 长回流线支路：下行进入 12 号合成气压缩机入口
  pl((25.43, 10.59), (25.43, 9.59))
  head((25.43, 9.59), (0, -1))
  // 12 号压缩机出口 → 13 号合成塔左端
  pl((29.90, 8.57), (29.90, 7.14), (23.50, 7.14), (23.50, 5.49), (23.80, 5.49))
  head((29.90, 7.90), (0, -1))
  head((23.80, 5.49), (1, 0))
  // 13 号合成塔右端出口 → 上部立管
  pl((30.00, 5.69), (30.85, 5.69))
  head((30.85, 5.69), (1, 0))
  // 13/14 出口汇合立管，向上接入顶部回流线
  pl((30.85, 4.54), (30.85, 10.59))
  head((30.85, 6.70), (0, 1))
  head((30.85, 8.60), (0, 1))
  // 14 号冷冻机组顶部出口 → 向右并入同一立管
  pl((24.45, 3.62), (24.45, 4.54), (30.85, 4.54))
  head((27.10, 4.54), (1, 0))
  // 13 号塔底 → 14 号冷冻机组左端
  pl((23.95, 4.89), (23.95, 3.54))
  head((23.95, 4.20), (0, -1))
  // 11 号氮洗塔底 → 14 号冷冻机组左端管板
  pl((21.95, 2.55), (23.95, 2.55), (23.95, 2.86))
  // 14 号冷冻机组底部出口 → 15 号液氨储罐顶部
  pl((29.10, 2.69), (29.10, 2.05), (31.30, 2.05), (31.30, 7.04), (32.80, 7.04), (32.80, 6.74))
  head((32.80, 6.74), (0, -1))
  // 8 号空气压缩机出口 → 9 号压力塔下部
  pl((9.45, 3.39), (9.45, 2.27), (10.12, 2.27), (10.12, 3.29), (10.30, 3.29))
  head((10.30, 3.29), (1, 0))
  // 9 号压力塔顶氮气 → 10 号氮气压缩机入口
  pl((10.30, 4.27), (10.00, 4.27), (10.00, 4.84), (15.00, 4.84), (15.00, 4.09))
  head((13.40, 4.84), (1, 0))
  head((15.00, 4.03), (0, -1))
  // 10 号氮气压缩机出口 → 11 号氮洗塔上部
  pl((20.00, 3.39), (20.00, 2.09), (20.65, 2.09), (20.65, 5.59), (21.25, 5.59))
  head((20.65, 4.90), (0, 1))
  head((21.25, 5.59), (1, 0))

  // ================= 入口标签 =================
  tag(1.20, 10.19, "Steam")
  tag(1.00, 5.92, "Oil")
  tag(1.00, 5.42, "Air")
  tag(6.85, 6.19, "Oxygen")

  // ================= 设备编号 1–15 =================
  lbl(5.55, 6.74, "1")
  lbl(8.52, 6.54, "2")
  lbl(11.12, 6.54, "3")
  lbl(13.65, 6.54, "4")
  lbl(16.25, 6.54, "5")
  lbl(18.72, 6.54, "6")
  lbl(21.40, 6.55, "7")
  lbl(4.50, 1.94, "8")
  lbl(10.95, 1.50, "9")
  lbl(16.20, 1.94, "10")
  lbl(21.60, 1.50, "11")
  lbl(26.00, 7.80, "12")
  lbl(29.05, 5.19, "13")
  lbl(26.60, 2.02, "14")
  lbl(33.08, 2.72, "15")
})
