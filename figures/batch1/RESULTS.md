# Batch 1 结果（2026-09-25）

来源：`E:\EPUB\work\deaux_figs\`（复平面线描图，扫描书提页）。
比对方式：Read 原图与 `png/` 下编译结果逐元素目视核对。

| 图 | 原图 | CeTZ 源码 | 编译结果 | 状态 | 尝试次数 | 备注 |
|---|---|---|---|---|---|---|
| fig1 | `deaux_figs/p26_5e2b98de.png` | `typ/fig1-ray.typ` | `png/fig1-ray.png` | 通过 | 1 | 轴+射线+三点 A/Z/Z′ |
| fig2 | `deaux_figs/p20_01ff02f3.png`（裁剪 `src/fig2_inversion.png`） | `typ/fig2-inversion.typ` | `png/fig2-inversion.png` | 通过 | 3 | 反演构造 Fig.6；失败原因依次：arc 误传圆心、arc 用 end 参数、`bar` 渲染成竖线 |
| fig3 | `deaux_figs/p28_4d147d5b.png` | `typ/fig3-line-d.typ` | `png/fig3-line-d.png` | 通过 | 1 | 轴+直线 d+三点 Z/M/Z′ |

剔除：`p46_0943a22b.png`、`p48_95c8d7da.png`（纯文字页，无插图）。
