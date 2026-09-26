# Batch 3 结果（2026-09-25）

来源 A：`E:\EPUB\work\deaux_figs\p26_ab054341.png`（复平面旋转构造）。
来源 B：`E:\mathbook\A Students Guide to Vectors and Tensors ...pdf` 第 30 页
Figure 2.1，PIL 裁出 (a)(b) 两个子图（`src/fig10-twovec.png`、`src/fig9-proj.png`）。
剔除：`deaux_figs/p47_cead64bc.png`（纯文字页）、同书第 60 页（无图）。

| 图 | 原图 | CeTZ 源码 | 编译结果 | 状态 | 尝试 | 备注 |
|---|---|---|---|---|---|---|
| fig8 | `src/fig8-rotation.png` | `typ/fig8-rotation.typ` | `png/fig8-rotation.png` | 通过 | 1 | 虚线射线 AZ/AZ′、α 虚线角弧带箭头、"+" 旋转方向弯箭 |
| fig9 | `src/fig9-proj.png` | `typ/fig9-proj.typ` | `png/fig9-proj.png` | 通过 | 2 | 点积投影：θ 弧、虚线垂足+直角记号、bezier 近似下花括号；首败因 `vec()` 渲染成圆括号 |
| fig10 | `src/fig10-twovec.png` | `typ/fig10-twovec.typ` | `png/fig10-twovec.png` | 通过 | 2 | 双向量夹角；同 vec() 问题 |
