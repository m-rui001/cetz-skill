# Batch 5 结果（2026-09-25）

来源：`E:\mathbook\Introduction to the Geometry of Complex Numbers by Roland Deaux, Howard Eves (z-lib.org).pdf`（扫描书，每页 1 张整页图，pymupdf 按 get_drawings 密度排序定位候选页）。
裁剪：`pdftoppm -png -r 150` 整页 → PIL 裁图区 → `src/`。

| 图 | 原图 | CeTZ | 编译 PNG | 尝试 | 结论 |
|---|---|---|---|---|---|
| fig13 旋转（书 Fig.8, p27） | src/fig13-rotation.png | typ/fig13-rotation.typ | png/fig13-rotation.png | 1 | 通过 |
| fig14 位似（书 Fig.9, p27） | src/fig14-homothety.png | typ/fig14-homothety.typ | png/fig14-homothety.png | 1 | 通过 |
| fig15 反演直线 d（书 Fig.12, p29） | src/fig15-inversion.png | typ/fig15-inversion.typ | png/fig15-inversion.png | 1 | 通过 |
| fig16 调和四边形轴（书 Fig.16, p35） | src/fig16-quad.png | typ/fig16-quad.typ | png/fig16-quad.png | 2 | 通过 |
| fig17 绕 Z 旋转双弧（书 Fig.28, p69） | src/fig17-rot28.png | typ/fig17-rot28.typ | png/fig17-rot28.png | 1 | 通过 |

合计 5/5 通过。

## 尝试记录
- fig13：一次通过。虚线射线 + `draw.arc` 角弧（箭头落在 Z' 射线端）+ 左侧旋转方向 bezier 弯箭 + "+" 号，元素齐。
- fig14：一次通过。A→箭头端单直线穿三点，点用 `circle(radius: .06, fill: black)`。
- fig15：一次通过。直线起点故意伸出 y 轴左侧（原图如此），d 标在箭头旁。
- fig16：第 1 次失败——`content(..., [Z_1])` 是 markup，下划线原样输出 "Z_1"；改 `$Z_1$` 后通过。结构（4 点、4 连线、4 条带箭头的轴 a13/a23/a24/a14、交叉）与原图一致。
- fig17：一次通过。7 条实线 + 2 条以 Z 为心的虚线旋转弧（箭头落在 B'、C'），交叉拓扑与原图一致。弧半径取 |ZB| 与 |ZB'| 的均值即可，扫描畸变不必精确。

## 拒绝的页/图
- `E:\EPUB\work\deaux_figs\p49_6449e010.png`：纯文字习题页，无插图。
- 本书 p126（印页 127）、p42（印页 43）：纯公式排版页，无插图（get_drawings 高是因为公式框线）。

## 经验
- 扫描书里 get_drawings 计数高 ≠ 有矢量插图：框线公式页也会高分，必须整页渲染目视确认。
- markup 方括号里写 `Z_1` 不会排下标，必须 `$Z_1$`；这与之前 `$arrow(A)$`、`$overline(Z)$` 属同一类坑：content 标签一律走 math 模式。
