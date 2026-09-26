# Batch 4 结果（2026-09-25）

来源：`E:\mathbook\散度、旋度、梯度释义（图解版）.pdf...` 第 55 页习题图
（PIL 自 150dpi 渲染裁出 `src/fig11-cube.png`、`src/fig12-quartercyl.png`）。
剔除：同书第 35 页（纯文字）、`deaux_figs/p51、p52`（纯文字页）。

| 图 | 原图 | CeTZ 源码 | 编译结果 | 状态 | 尝试 | 备注 |
|---|---|---|---|---|---|---|
| fig11 | `src/fig11-cube.png` | `typ/fig11-cube.typ` | `png/fig11-cube.png` | 通过 | 3 | 灰面立方体+三轴+O+三个 b 边标；失败原因：`draw.polygon` 是正多边形、无 `draw.path`，最终用 `draw.line(..., close: true, fill:)` |
| fig12 | `src/fig12-quartercyl.png` | `typ/fig12-quartercyl.typ` | `png/fig12-quartercyl.png` | 放弃 | 2 | 1/4 圆柱：两次尝试曲面朝向均与原图相反（原图曲面朝观者、棱在后；斜投影下弧的凸向难定）。按准则放弃 |
