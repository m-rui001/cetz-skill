// 6G 智慧工厂（Industry 4.0）全景架构图
// 源图：Internet of things for smart factories in Industry 4.0, a review
//       (HAL hal-04087178, 2023) Fig. 1 "IoT in 6G based smart factory of the industry 4.0 system"
//
// 版面（自左向右 / 自上而下）：
//   第 1 行：Supply Management(卡车) → AGV → Mobile Robots(移动机械臂) → Flexible Assembly Line(输送线) → Sensors
//   第 2 行：AR/VR-based HMI → Process Monitoring & Control → Integration with Industrial Ethernet → Motion Control(CNC + 机械臂)
//   第 3 行：Digital Twin(蓝色面板) → Inventory Management(货架) → AGV → Delivery Management(卡车) + Drone
//   横向支撑层：Cloud/Edge(6G)、AI/ML 服务器、Blockchain 铺在底部，用无线波纹向上接入车间
//
// 说明：源图里的设备照片全部改为简洁线稿图标；区域划分、物流箭头方向、
//       无线（5G/6G）连接关系与源图一致。
#set page(width: auto, height: auto, margin: 6pt)
#import "@preview/cetz:0.4.2": canvas, draw
#set text(font: ("Segoe UI", "Arial"), size: 8.4pt)

#canvas({
  import draw: *

  // 配色与线型
  let INK = rgb("#1f4a4e")        // 线稿主墨色（源图深青色线条）
  let PALE = rgb("#eef2d8")       // 设备浅灰绿填充
  let GREYF = rgb("#dfe4e3")      // 料箱 / 货物浅灰填充
  let ACCENT = rgb("#bfa63c")     // 指示灯黄
  let GREY = rgb("#9aa8ab")       // 外框 / 分隔线
  let BAND = rgb("#f5f7f7")       // 支撑层底色
  let BLUEF = rgb("#d3e3ee")      // Digital Twin 面板蓝
  let BLUEINK = rgb("#3f6f88")    // Digital Twin 面板边框
  let FLOW = rgb("#d9bfa2")       // 物流虚线（源图米色虚线）
  let LINK = rgb("#6d9dbe")       // 5G/6G 无线链路（蓝色虚线）
  let RED = rgb("#c0392b")        // 顶部标题

  let thin = (paint: INK, thickness: 0.8pt, cap: "round")    // 图标主线条
  let thinn = (paint: INK, thickness: 0.6pt, cap: "round")   // 图标细线条

  // 标签
  let lbl(x, y, body, size: 8.4pt, anchor: "center", fill: INK, weight: "regular", style: "normal") = content(
    (x, y), anchor: anchor, text(size: size, fill: fill, weight: weight, style: style, body),
  )

  // 无线信号波纹：一个信号点 + 三道向上张开的圆弧（源图中每台设备头上的 wifi 符号）
  let wifi(x, y, r: 0.30, paint: INK) = {
    circle((x, y), radius: 0.045, fill: paint, stroke: none)
    for k in range(1, 4) {
      arc((x, y), radius: r * k / 3, start: 38deg, stop: 142deg,
        stroke: (paint: paint, thickness: 0.6pt, cap: "round"))
    }
  }

  // 物流虚线（米色）：无箭头段
  let flow(a, b) = line(
    a, b,
    stroke: (paint: FLOW, thickness: 0.8pt, cap: "round", dash: (2.4pt, 1.8pt)),
  )
  // 物流虚线 + 末端箭头（箭头方向按源图）
  let flow-to(a, b) = line(
    a, b,
    stroke: (paint: FLOW, thickness: 0.8pt, cap: "round", dash: (2.4pt, 1.8pt)),
    mark: (end: "stealth", fill: FLOW, scale: 0.75),
  )

  // 5G/6G 虚线链路（蓝色）
  let link(a, b) = line(
    a, b,
    stroke: (paint: LINK, thickness: 0.7pt, cap: "round", dash: (1.8pt, 1.4pt)),
  )

  // 圆形凸起：以 p→q 为弦、向外鼓出半圆，用 14 段折线逼近（画云朵轮廓用）
  let bump(p, q, paint, n: 14) = {
    let dx = q.at(0) - p.at(0)
    let dy = q.at(1) - p.at(1)
    let len = calc.sqrt(dx * dx + dy * dy)
    let nx = -dy / len
    let ny = dx / len
    let pts = ()
    for i in range(n + 1) {
      let t = i / n * calc.pi
      let u = (1 - calc.cos(t)) / 2
      let v = calc.sin(t) / 2
      pts.push((p.at(0) + dx * u + nx * len * v, p.at(1) + dy * u + ny * len * v))
    }
    line(..pts, stroke: (paint: paint, thickness: 0.8pt, cap: "round", join: "round"))
  }

  // 图标函数（照片 → 线稿）

  // 卡车：侧视重型卡车（车厢 + 驾驶室 + 挡风玻璃 + 三轴车轮）；对应 Supply / Delivery 的物流照片
  let truck(cx, cy) = {
    // 车轮（后双轴 + 前单轴）
    for wx in (-1.60, -0.80, 1.42) {
      circle((cx + wx, cy + 0.26), radius: 0.26, fill: white, stroke: thin)
      circle((cx + wx, cy + 0.26), radius: 0.09, stroke: thinn)
    }
    // 车厢
    line(
      (cx - 2.10, cy + 0.46), (cx + 0.62, cy + 0.46), (cx + 0.62, cy + 1.86),
      (cx - 2.10, cy + 1.86), close: true, fill: PALE, stroke: thin,
    )
    // 驾驶室（前部斜顶）
    line(
      (cx + 0.62, cy + 0.46), (cx + 1.92, cy + 0.46), (cx + 1.92, cy + 1.14),
      (cx + 1.52, cy + 1.70), (cx + 0.62, cy + 1.70), close: true, fill: PALE, stroke: thin,
    )
    // 挡风玻璃与侧窗
    line(
      (cx + 1.16, cy + 1.12), (cx + 1.16, cy + 1.60), (cx + 1.50, cy + 1.60),
      (cx + 1.84, cy + 1.14), close: true, fill: white, stroke: thinn,
    )
    line((cx + 0.88, cy + 0.50), (cx + 0.88, cy + 1.66), stroke: thinn)
    // 车头灯
    circle((cx + 1.84, cy + 0.62), radius: 0.07, fill: white, stroke: thinn)
  }

  // AGV：激光/叉车式自动搬运车（车体 + 门架 + 货叉上的两个料箱）；对应源图的 AGV 照片
  let agv(cx, cy) = {
    // 驱动轮
    circle((cx - 0.80, cy + 0.16), radius: 0.16, fill: white, stroke: thin)
    circle((cx + 0.24, cy + 0.16), radius: 0.16, fill: white, stroke: thin)
    // 车体
    line(
      (cx - 1.00, cy + 0.28), (cx + 0.60, cy + 0.28), (cx + 0.60, cy + 0.76),
      (cx - 1.00, cy + 0.76), close: true, fill: PALE, stroke: thin,
    )
    // 驾驶座：坐垫 + 靠背
    line((cx - 0.86, cy + 0.76), (cx - 0.50, cy + 0.76), (cx - 0.50, cy + 0.88),
      (cx - 0.86, cy + 0.88), close: true, fill: white, stroke: thinn)
    line((cx - 0.90, cy + 0.88), (cx - 0.90, cy + 1.22), (cx - 0.76, cy + 1.22),
      (cx - 0.76, cy + 0.88), close: true, fill: white, stroke: thinn)
    // 门架（双立柱 + 顶梁）
    line((cx + 0.26, cy + 0.76), (cx + 0.26, cy + 1.46), stroke: thin)
    line((cx + 0.42, cy + 0.76), (cx + 0.42, cy + 1.46), stroke: thin)
    line((cx + 0.24, cy + 1.46), (cx + 0.44, cy + 1.46), stroke: thin)
    // 两根货叉（上下各一根，前端封口）
    line((cx + 0.34, cy + 1.00), (cx + 1.34, cy + 1.00), stroke: thin)
    line((cx + 0.34, cy + 1.12), (cx + 1.34, cy + 1.12), stroke: thinn)
    line((cx + 1.34, cy + 1.00), (cx + 1.34, cy + 1.12), stroke: thinn)
    // 两个料箱落在货叉上
    rect((cx + 0.48, cy + 1.12), (cx + 1.30, cy + 1.40), fill: GREYF, stroke: thinn)
    rect((cx + 0.48, cy + 1.42), (cx + 1.30, cy + 1.68), fill: GREYF, stroke: thinn)
  }

  // 移动机器人：轮式底盘 + 小型六轴机械臂（源图 Mobile Robots 照片）
  let mobile-robot(cx, cy) = {
    // 移动底盘与轮子
    rect((cx - 0.52, cy + 0.14), (cx + 0.52, cy + 0.44), radius: 0.06, fill: PALE, stroke: thin)
    circle((cx - 0.30, cy + 0.14), radius: 0.13, fill: white, stroke: thin)
    circle((cx + 0.30, cy + 0.14), radius: 0.13, fill: white, stroke: thin)
    // 回转座
    rect((cx - 0.22, cy + 0.44), (cx + 0.22, cy + 0.62), fill: PALE, stroke: thin)
    // 大臂、小臂
    line((cx, cy + 0.62), (cx + 0.40, cy + 1.26), stroke: (paint: INK, thickness: 0.9pt, cap: "round"))
    line((cx + 0.40, cy + 1.26), (cx + 0.80, cy + 1.50), stroke: (paint: INK, thickness: 0.9pt, cap: "round"))
    // 关节
    circle((cx, cy + 0.62), radius: 0.09, fill: white, stroke: thin)
    circle((cx + 0.40, cy + 1.26), radius: 0.08, fill: white, stroke: thin)
    // 末端夹爪：横向腕板 + 两根平行指
    line((cx + 0.74, cy + 1.56), (cx + 0.84, cy + 1.42), stroke: thinn)
    line((cx + 0.74, cy + 1.56), (cx + 0.89, cy + 1.65), stroke: thinn)
    line((cx + 0.84, cy + 1.42), (cx + 0.99, cy + 1.51), stroke: thinn)
  }

  // 机械臂：落地底座 + 大臂 / 小臂 + 夹爪（源图 Motion Control 照片，dir 控制朝向）
  let robot-arm(cx, cy, dir: 1) = {
    // 底座
    line(
      (cx - 0.62, cy), (cx + 0.62, cy), (cx + 0.44, cy + 0.38),
      (cx - 0.44, cy + 0.38), close: true, fill: PALE, stroke: thin,
    )
    // 回转体
    circle((cx, cy + 0.44), radius: 0.17, fill: white, stroke: thin)
    // 大臂（上扬）与小臂（前伸）
    line((cx, cy + 0.44), (cx + 0.52 * dir, cy + 1.52), stroke: (paint: INK, thickness: 0.9pt, cap: "round"))
    line((cx + 0.52 * dir, cy + 1.52), (cx + 1.30 * dir, cy + 1.42), stroke: (paint: INK, thickness: 0.9pt, cap: "round"))
    // 肘关节
    circle((cx + 0.52 * dir, cy + 1.52), radius: 0.11, fill: white, stroke: thin)
    // 手腕与两指夹爪
    circle((cx + 1.30 * dir, cy + 1.42), radius: 0.08, fill: white, stroke: thinn)
    line((cx + 1.30 * dir, cy + 1.42), (cx + 1.46 * dir, cy + 1.42), stroke: thin)
    line((cx + 1.46 * dir, cy + 1.50), (cx + 1.66 * dir, cy + 1.52), stroke: thinn)
    line((cx + 1.46 * dir, cy + 1.34), (cx + 1.66 * dir, cy + 1.32), stroke: thinn)
  }

  // 输送线：环形线体 + 五个滚轮 + 支腿（源图 Flexible Assembly Line 照片的滚筒线）
  let conveyor(cx, cy, w: 3.4) = {
    let x0 = cx - w / 2
    let x1 = cx + w / 2
    // 支腿
    line((x0 + 0.36, cy + 0.10), (x0 + 0.26, cy - 0.30), stroke: thinn)
    line((x1 - 0.36, cy + 0.10), (x1 - 0.26, cy - 0.30), stroke: thinn)
    // 上下边梁
    line((x0, cy + 0.10), (x1, cy + 0.10), stroke: thin)
    line((x0, cy + 0.54), (x1, cy + 0.54), stroke: thin)
    line((x0, cy + 0.10), (x0, cy + 0.54), stroke: thinn)
    line((x1, cy + 0.10), (x1, cy + 0.54), stroke: thinn)
    // 滚轮
    for i in range(5) {
      circle((x0 + w * (i + 0.5) / 5, cy + 0.32), radius: 0.10, fill: white, stroke: thinn)
    }
  }

  // 料箱：线体上的工件盒（顶面稍带透视）
  let crate(x, y, w: 0.52, h: 0.34) = {
    line((x, y), (x + w, y), (x + w, y + h), (x, y + h), close: true, fill: GREYF, stroke: thinn)
    line((x, y + h), (x + 0.10, y + h + 0.10), (x + w + 0.10, y + h + 0.10), (x + w, y + h), stroke: thinn)
  }

  // 货架仓库：三层层板 × 四列货箱的托盘货架（源图 Inventory Management 照片）
  let warehouse(cx, cy) = {
    let h = 1.72
    rect((cx - 1.10, cy), (cx + 1.10, cy + h), fill: white, stroke: thin)
    for k in (1, 2) {
      line((cx - 1.10, cy + h * k / 3), (cx + 1.10, cy + h * k / 3), stroke: thin)
    }
    // 每层四列货箱
    for k in range(3) {
      let yb = cy + h * k / 3 + 0.10
      for j in range(4) {
        let xb = cx - 1.00 + j * 0.52
        rect((xb, yb), (xb + 0.42, yb + 0.40), fill: GREYF, stroke: thinn)
        line((xb, yb + 0.24), (xb + 0.42, yb + 0.24), stroke: thinn)
      }
    }
  }

  // 数控机床：机身 + 观察窗（内有工件与主轴）+ 侧置控制面板（表示机器控制 / 加工单元）
  let cnc(cx, cy) = {
    // 机身
    rect((cx - 0.95, cy + 0.22), (cx + 0.95, cy + 1.82), radius: 0.06, fill: PALE, stroke: thin)
    // 底脚
    line((cx - 0.74, cy + 0.22), (cx - 0.74, cy), (cx - 0.44, cy), stroke: thin)
    line((cx + 0.44, cy), (cx + 0.74, cy), (cx + 0.74, cy + 0.22), stroke: thin)
    // 观察窗
    rect((cx - 0.78, cy + 0.72), (cx + 0.06, cy + 1.64), fill: white, stroke: thinn)
    // 窗内：工作台、工件、主轴
    line((cx - 0.66, cy + 0.92), (cx - 0.10, cy + 0.92), stroke: thinn)
    rect((cx - 0.56, cy + 0.92), (cx - 0.30, cy + 1.08), fill: GREYF, stroke: thinn)
    line((cx - 0.43, cy + 1.64), (cx - 0.43, cy + 1.22), stroke: thin)
    line((cx - 0.51, cy + 1.22), (cx - 0.35, cy + 1.22), stroke: thin)
    // 控制面板：小屏 + 两个按钮
    rect((cx + 0.18, cy + 0.86), (cx + 0.78, cy + 1.56), fill: white, stroke: thinn)
    rect((cx + 0.26, cy + 1.20), (cx + 0.70, cy + 1.48), fill: rgb("#eef4f8"), stroke: thinn)
    circle((cx + 0.32, cy + 1.02), radius: 0.06, fill: ACCENT, stroke: thinn)
    circle((cx + 0.56, cy + 1.02), radius: 0.06, fill: white, stroke: thinn)
  }

  // 无人机：四旋翼 + 机身 + 挂载货箱（Delivery 的空中配送）
  let drone(cx, cy) = {
    // 机身
    rect((cx - 0.34, cy), (cx + 0.34, cy + 0.30), radius: 0.12, fill: PALE, stroke: thin)
    // 机臂
    line((cx - 0.26, cy + 0.26), (cx - 0.72, cy + 0.50), stroke: thin)
    line((cx + 0.26, cy + 0.26), (cx + 0.72, cy + 0.50), stroke: thin)
    // 四个旋翼（横杆 + 弧线）
    for ex in (-0.72, 0.72) {
      line((cx + ex - 0.19, cy + 0.50), (cx + ex + 0.19, cy + 0.50), stroke: thin)
      arc((cx + ex, cy + 0.51), radius: 0.17, start: 20deg, stop: 160deg, stroke: thinn)
    }
    // 起落架
    line((cx - 0.20, cy), (cx - 0.26, cy - 0.16), (cx - 0.10, cy - 0.16), stroke: thinn)
    line((cx + 0.20, cy), (cx + 0.26, cy - 0.16), (cx + 0.10, cy - 0.16), stroke: thinn)
    // 挂载货箱
    rect((cx - 0.14, cy - 0.34), (cx + 0.14, cy - 0.02), fill: GREYF, stroke: thinn)
  }

  // 云：三段圆弧 + 底边，表示 Cloud / Edge 计算（源图 5G/6G 云）
  let cloud(cx, cy) = {
    let y0 = cy + 0.05
    let a = (cx - 1.15, y0)
    let p1 = (cx - 0.60, y0 + 0.82)
    let p2 = (cx + 0.16, y0 + 0.96)
    let p3 = (cx + 0.86, y0 + 0.56)
    let e = (cx + 1.13, y0)
    bump(a, p1, INK)
    bump(p1, p2, INK)
    bump(p2, p3, INK)
    bump(p3, e, INK)
    line(a, e, stroke: (paint: INK, thickness: 0.8pt, cap: "round"))
  }

  // 服务器机架：三层 1U 单元 + 插槽 + 指示灯，表示边缘 AI/ML 推理节点
  let server(cx, cy) = {
    rect((cx - 0.62, cy), (cx + 0.62, cy + 1.80), radius: 0.08, fill: white, stroke: thin)
    for k in range(3) {
      let yb = cy + 0.12 + k * 0.56
      rect((cx - 0.50, yb), (cx + 0.50, yb + 0.44), fill: PALE, stroke: thinn)
      line((cx - 0.38, yb + 0.13), (cx + 0.10, yb + 0.13), stroke: thinn)
      line((cx - 0.38, yb + 0.25), (cx + 0.10, yb + 0.25), stroke: thinn)
      circle((cx + 0.32, yb + 0.31), radius: 0.045, fill: ACCENT, stroke: none)
      circle((cx + 0.32, yb + 0.14), radius: 0.045, fill: white, stroke: thinn)
    }
  }

  // 区块链：三个首尾相连的区块（块内为哈希短横线），表示分布式账本
  let blockchain(cx, cy) = {
    let s = 0.52
    let gap = 0.34
    for i in range(3) {
      let x = cx - 1.05 + i * (s + gap)
      let y = cy + 0.26
      rect((x, y), (x + s, y + s), radius: 0.05, fill: PALE, stroke: thin)
      line((x + 0.11, y + 0.34), (x + s - 0.11, y + 0.34), stroke: thinn)
      line((x + 0.11, y + 0.20), (x + s - 0.24, y + 0.20), stroke: thinn)
      if i < 2 {
        line((x + s, y + s / 2), (x + s + gap, y + s / 2), stroke: (paint: INK, thickness: 0.8pt))
      }
    }
    // 链尾回到首块的虚线（环状账本）
    line((cx + 1.05, cy + 0.26), (cx + 1.05, cy + 0.04), (cx - 1.05, cy + 0.04), stroke: thinn)
  }

  // 数字孪生：实体厂房立方体 + 虚线虚拟副本 + 双向同步箭头
  let digital-twin(cx, cy) = {
    let s = 0.76
    let dx = 0.32
    let dy = 0.26
    let box(x, y, fill, dashed) = {
      let st = if dashed {
        (paint: INK, thickness: 0.8pt, dash: (1.8pt, 1.3pt))
      } else {
        (paint: INK, thickness: 0.8pt)
      }
      line((x, y), (x + s, y), (x + s, y + s), (x, y + s), close: true, fill: fill, stroke: st)
      line((x, y + s), (x + dx, y + s + dy), (x + s + dx, y + s + dy), (x + s, y + s), close: true, fill: fill, stroke: st)
      line((x + s, y), (x + s + dx, y + dy), (x + s + dx, y + s + dy), stroke: st)
    }
    // 实体（左）
    box(cx - 1.16, cy + 0.10, PALE, false)
    // 虚拟副本（右，虚线）
    box(cx + 0.42, cy + 0.32, none, true)
    // 双向同步箭头
    line(
      (cx - 0.06, cy + 0.66), (cx + 0.34, cy + 0.66),
      stroke: (paint: BLUEINK, thickness: 0.8pt),
      mark: (start: ">", end: ">", fill: BLUEINK, scale: 0.65),
    )
  }

  // 过程监控终端：显示器（屏内趋势曲线）+ 底座 + 放大镜（源图 Process Monitoring 的笔记本电脑）
  let monitor(cx, cy) = {
    rect((cx - 1.02, cy + 0.52), (cx + 0.62, cy + 1.78), radius: 0.08, fill: white, stroke: thin)
    rect((cx - 0.92, cy + 0.62), (cx + 0.40, cy + 1.68), fill: rgb("#eef4f8"), stroke: thinn)
    // 屏内曲线
    line(
      (cx - 0.86, cy + 0.98), (cx - 0.68, cy + 1.24), (cx - 0.50, cy + 0.86),
      (cx - 0.26, cy + 1.38), (cx - 0.04, cy + 0.98), (cx + 0.18, cy + 1.22),
      stroke: (paint: LINK, thickness: 0.8pt, cap: "round"),
    )
    // 屏内数据行
    line((cx - 0.86, cy + 0.78), (cx + 0.10, cy + 0.78), stroke: thinn)
    // 支架与底板
    line((cx - 0.36, cy + 0.52), (cx - 0.36, cy + 0.28), stroke: thin)
    line((cx + 0.02, cy + 0.52), (cx + 0.02, cy + 0.28), stroke: thin)
    line((cx - 0.54, cy + 0.28), (cx + 0.20, cy + 0.28), stroke: thin)
    // 放大镜
    circle((cx + 0.80, cy + 0.88), radius: 0.22, fill: none, stroke: thin)
    line((cx + 0.95, cy + 0.72), (cx + 1.14, cy + 0.52), stroke: thin)
  }

  // 无线传感节点：小型带透镜的传感器 + 安装杆（源图 Sensors / Industrial Ethernet 上的节点）
  let sensor-node(cx, cy) = {
    rect((cx - 0.24, cy), (cx + 0.24, cy + 0.46), radius: 0.10, fill: PALE, stroke: thin)
    circle((cx, cy + 0.23), radius: 0.09, fill: white, stroke: thinn)
    line((cx, cy), (cx, cy - 0.18), stroke: thin)
  }

  // AR/VR 头显工人：安全帽 + 护目镜 + 肩部轮廓（源图 AR/VR-based HMI 照片）
  let hmi-helmet(cx, cy) = {
    // 肩部
    line(
      (cx - 0.72, cy), (cx - 0.64, cy + 0.52), (cx - 0.30, cy + 0.64),
      (cx + 0.30, cy + 0.64), (cx + 0.64, cy + 0.52), (cx + 0.72, cy),
      close: true, fill: PALE, stroke: thin,
    )
    // 头部
    circle((cx, cy + 1.04), radius: 0.34, fill: white, stroke: thin)
    // 安全帽
    line(
      (cx - 0.40, cy + 1.20), (cx - 0.34, cy + 1.52), (cx + 0.34, cy + 1.52),
      (cx + 0.40, cy + 1.20), close: true, fill: GREYF, stroke: thin,
    )
    line((cx - 0.50, cy + 1.20), (cx + 0.50, cy + 1.20), stroke: thin)
    // 护目镜（AR/VR 头显）
    line((cx - 0.28, cy + 1.06), (cx + 0.28, cy + 1.06), stroke: thin)
    // 帽侧通讯灯
    circle((cx + 0.44, cy + 1.36), radius: 0.07, fill: ACCENT, stroke: thin)
  }

  // 版面常量
  let X_TITLE = 14.45        // 标题中心
  let Y_TITLE = 21.35
  let FRAME_L = 0.60         // 车间外框
  let FRAME_R = 28.35
  let FRAME_B = 6.30
  let FRAME_T = 20.40
  let BAND_B = 0.55          // 支撑层
  let BAND_T = 4.85
  let FY1 = 17.40            // 第 1 行（供应链 / AGV / 机器人 / 产线 / 传感）落地线
  let FY2 = 11.90            // 第 2 行（HMI / 监控 / 工业以太网 / 运动控制）落地线
  let FY3 = 7.60             // 第 3 行（数字孪生 / 库存 / AGV / 交付）落地线
  let FLOW1_Y = 17.15        // 物流主线（上层）
  let FLOW3_Y = 7.45         // 物流主线（下层）

  // 顶部标题 + 车间外框
  lbl(X_TITLE, Y_TITLE, [6G-based Smart Factory], size: 15.5pt, fill: RED, weight: "bold")
  rect((FRAME_L, FRAME_B), (FRAME_R, FRAME_T), radius: 0.55, fill: none,
    stroke: (paint: GREY, thickness: 0.9pt))

  // 物流虚线主线（米色，方向按源图）
  // 上层：供应链 → AGV → 移动机器人 → 柔性产线 → 传感器
  flow((5.55, FLOW1_Y), (25.35, FLOW1_Y))
  flow-to((13.30, FLOW1_Y), (13.90, FLOW1_Y))
  // 右侧转折：传感器 → 向下 → 运控（源图右上角的折线）
  flow((25.35, FLOW1_Y), (25.35, 13.75))
  flow-to((25.35, 16.40), (25.35, 15.90))
  flow-to((25.35, 13.75), (24.10, 13.75))
  // 下层：库存 → AGV → 交付
  flow((7.95, FLOW3_Y), (22.35, FLOW3_Y))
  flow-to((13.10, FLOW3_Y), (13.70, FLOW3_Y))
  flow-to((19.90, FLOW3_Y), (20.50, FLOW3_Y))

  // 第 1 行左侧：Supply Management（卡车物流）
  truck(3.30, FY1)
  lbl(2.95, 19.96, [Supply], size: 9.2pt)
  lbl(2.95, 19.58, [Management], size: 9.2pt)
  wifi(4.95, 19.30)

  // 第 1 行：AGV 自动搬运车
  agv(8.45, FY1)
  wifi(7.60, 18.80)
  lbl(8.45, 16.55, [AGV], size: 9.2pt)

  // 第 1 行：Mobile Robots（两台移动机械臂）
  mobile-robot(11.40, FY1)
  mobile-robot(13.80, FY1)
  wifi(11.40, 19.28)
  wifi(13.80, 19.28)
  rect((11.45, 19.62), (14.05, 20.12), radius: 0.22, fill: rgb("#f3f5ea"),
    stroke: (paint: GREY, thickness: 0.6pt))
  lbl(12.75, 19.87, [Mobile Robots], size: 8.6pt)

  // 第 1 行：Flexible Assembly Line（柔性装配线）
  conveyor(16.90, FY1, w: 3.40)
  crate(15.55, 17.94)
  crate(16.55, 17.94)
  crate(17.55, 17.94)
  wifi(18.90, 18.20)
  lbl(16.90, 16.80, [Flexible], size: 8.8pt)
  lbl(16.90, 16.44, [Assembly Line], size: 8.8pt)

  // 第 1 行右侧：Sensors（无线传感节点）
  sensor-node(22.10, 17.58)
  wifi(22.10, 18.12)
  lbl(22.10, 16.55, [Sensors], size: 9.2pt)

  // 第 2 行左：AR/VR-based HMI（工人头显）
  hmi-helmet(3.10, FY2)
  wifi(4.10, 13.30)
  lbl(2.60, 14.62, [AR/VR-based], size: 9.2pt)
  lbl(2.60, 14.22, [HMI], size: 9.2pt)

  // 第 2 行中：Process Monitoring & Control（监控终端）
  // 浅黄绿色圆角框（源图为浅色发光框，强调该区域为监控中枢）
  rect((7.20, 11.55), (12.40, 14.15), radius: 0.28, fill: none,
    stroke: (paint: rgb("#c3cc63"), thickness: 0.8pt))
  monitor(9.80, 11.80)
  wifi(9.80, 14.30)
  // 左右两侧的无线波纹（与源图一致：框外两侧各一组）
  arc((6.72, 12.85), radius: 0.30, start: 38deg, stop: 142deg, stroke: (paint: INK, thickness: 0.6pt, cap: "round"))
  arc((6.72, 12.85), radius: 0.20, start: 38deg, stop: 142deg, stroke: (paint: INK, thickness: 0.6pt, cap: "round"))
  arc((6.72, 12.85), radius: 0.10, start: 38deg, stop: 142deg, stroke: (paint: INK, thickness: 0.6pt, cap: "round"))
  arc((12.90, 12.85), radius: 0.30, start: 38deg, stop: 142deg, stroke: (paint: INK, thickness: 0.6pt, cap: "round"))
  arc((12.90, 12.85), radius: 0.20, start: 38deg, stop: 142deg, stroke: (paint: INK, thickness: 0.6pt, cap: "round"))
  arc((12.90, 12.85), radius: 0.10, start: 38deg, stop: 142deg, stroke: (paint: INK, thickness: 0.6pt, cap: "round"))
  lbl(9.80, 10.95, [Process Monitoring &], size: 9.0pt)
  lbl(9.80, 10.58, [Control], size: 9.0pt)

  // 第 2 行中右：Integration with Industrial Ethernet
  line((14.05, 12.05), (18.35, 12.05), stroke: (paint: INK, thickness: 0.9pt, cap: "round"))
  for i in range(4) {
    let x = 14.40 + i * 1.15
    line((x, 12.05), (x, 11.72), stroke: thinn)
    rect((x - 0.11, 11.54), (x + 0.11, 11.72), fill: GREYF, stroke: thinn)
  }
  sensor-node(16.35, 12.05)
  wifi(16.35, 12.80)
  lbl(16.20, 10.95, [Integration with], size: 9.0pt)
  lbl(16.20, 10.58, [Industrial Ethernet], size: 9.0pt)

  // 第 2 行右：Motion Control（机械臂）
  robot-arm(22.20, FY2, dir: -1)
  wifi(22.80, 14.30)
  lbl(22.60, 11.05, [Motion Control], size: 9.2pt)

  // 第 3 行左：Factory overview（源图为工厂等轴测照片，这里改线稿）
  rect((0.90, 7.10), (6.30, 9.80), radius: 0.10, fill: BLUEF,
    stroke: (paint: BLUEINK, thickness: 0.8pt))
  lbl(3.60, 9.44, [Factory overview], size: 9.2pt, weight: "bold", fill: BLUEINK)
  // 三个等轴测工位，示意车间总览
  let cell(cx, cy) = {
    line((cx, cy), (cx + 0.55, cy + 0.28), (cx + 1.10, cy), (cx + 0.55, cy - 0.28),
      close: true, fill: white, stroke: thinn)
    line((cx + 0.22, cy + 0.02), (cx + 0.22, cy + 0.42), (cx + 0.55, cy + 0.60),
      (cx + 0.88, cy + 0.42), (cx + 0.88, cy + 0.02), stroke: thinn)
    line((cx + 0.22, cy + 0.42), (cx + 0.55, cy + 0.28), (cx + 0.88, cy + 0.42),
      stroke: thinn)
    line((cx + 0.46, cy + 0.04), (cx + 0.46, cy + 0.34), stroke: thinn)
  }
  cell(1.35, 8.10)
  cell(2.85, 8.10)
  cell(4.35, 8.10)

  // 第 3 行：Inventory Management（托盘货架）
  warehouse(9.30, FY3)
  wifi(9.30, 9.50)
  lbl(9.30, 7.06, [Inventory], size: 9.2pt)
  lbl(9.30, 6.69, [Management], size: 9.2pt)

  // 第 3 行：AGV（产线到出库）
  agv(16.30, FY3)
  wifi(16.05, 9.46)
  lbl(16.30, 6.88, [AGV], size: 9.2pt)

  // 第 3 行右：Delivery Management
  truck(24.60, FY3)
  wifi(25.85, 9.58)
  lbl(23.10, 7.06, [Delivery], size: 9.2pt)
  lbl(23.10, 6.69, [Management], size: 9.2pt)

  // 图注（源图左下角）
  lbl(1.10, 5.10, [Source: 5G-ACIA WP], size: 7.8pt, anchor: "west", fill: rgb("#5b6b6e"))
})
