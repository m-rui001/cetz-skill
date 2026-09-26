# batch24 结果（Fleisch《向量与张量》EPUB，新编号 60 / 62 / 71）

| 图 | 源索引 | 文件 | 重试 | 结论 |
|---|---|---|---|---|
| fig73-drag | idx 60 | `typ/fig73-drag.typ` | 1 | 通过 |
| fig74-parallelepiped | idx 62 | `typ/fig74-parallelepiped.typ` | 1 | 通过 |
| fig75-efield | idx 71 | `typ/fig75-efield.typ` | 2 | 通过 |

图源：`E:/EPUB/work/reocr_stage/A Students Guide to Vectors and Tensors*/render/*.epub`
按 `sorted()` 文件名编号的第 60、62、71 张（沿用 batch23 建立的新编号体系）。

## fig73-drag（三栏 Δv 图解，空气阻力方向）

A/B 两栏共用 `panel(ox, oy, ang, tag)` 闭包：内部先 `R(p)` 旋转再平移，
文字只跟着坐标走、本身保持水平。C 栏原书不是纯旋转版式（合矢量沿 v_final 方向、
圆标挪到两组箭头下方），和 batch23 fig71 的 C 栏同样处理：给 C 写显式坐标，
不往闭包里塞参数。

## fig74-parallelepiped（三面交线 / 平行六面体）

- 先画承载 B、C 的那张平面（四边形），再画六面体；被平面挡住的棱用
  `(dash: (array: (7pt, 5pt)), thickness: 1.2pt)` 的长划虚线。
- 顶点全部由基向量加法得到（`AB = add(A, B)`、`ABC = add(A, add(B, C))`），
  只手标 O/A/B/C 四个点，其余自动闭合，避免对不上。
- 矢量粗线 2.1pt、构造细线 1.3pt，两套 stroke 常量分开定义。

## fig75-efield（三个点电荷场 + 试探点）

三个电荷共用一个 `spokes(中心, 起始角, tipR, baseR, r2, wid, tail)` 闭包，
每个方向画"细轴 + 填充三角花瓣 + 末端短虚线"三层：

- 正电荷 q1：花瓣朝外（tip 半径 > base 半径），轴从中心外 0.22 起画。
- 负电荷 q2/q3：花瓣朝内（tip 半径 0.24–0.30，base 半径 1.0–1.3），
  视觉上就是原书那种"胖箭头扎进中心"的花。
- 花瓣胖瘦只由 `wid`（半宽）和 `baseR` 决定：q3 第一版 wid=0.37/baseR=1.10
  糊成一朵花，改成 0.29/1.28 才露出轴。

三次改动对应两次重试：
1. 第一次编译失败——`polygon()` 第一个位置参数是**边数**，画任意三角形要用
   `line(path: true, close: true, p1, p2, p3, fill: ..., stroke: none)`。
2. `content` 里的 `\\` 不会换行，会原样印出反斜杠；三行说明文字拆成三个
   `content()` 按 y 排。数学下标写 `$q_1$`，`start subscript` 在 math 简写里不可用。
3. 第二次：弯曲引线 bezier 的控制点横向摆幅太大（c1 偏左、c2 偏右）会打结，
   而且末端箭头跟着切向翻到反方向——把 c1/c2 收回起点与终点之间即恢复。

## 淘汰/跳过记录（新编号）

- idx 71 的原图是跨页裁切的半页（右半边被切掉），仍按可见部分转，未补全。
- 下一批候选（新编号）：81、86、96、1、13、17、27、33、36、47、45、63。
