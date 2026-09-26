# Batch 2 结果（2026-09-25）

来源 A：`E:\EPUB\out\mathbook\An Illustrative Guide to Multivariable and Vector Calculus....epub`
解包 228 张图，按饱和度<0.12 且墨量 0.02–0.25 筛出 164 张黑白候选；
彩色曲面/灰度照片图按准则放弃（如 3D 彩色 mesh 曲面）。
来源 B：`E:\pdf\pdfonly-stem\pdfcorpus\out\pdfs\`（哈希命名论文 PDF），
用 pymupdf 按"矢量绘图数多且无嵌入图"定位插图页。

| 图 | 原图 | CeTZ 源码 | 编译结果 | 状态 | 尝试 | 备注 |
|---|---|---|---|---|---|---|
| fig4 | EPUB `a671ce….png`（`src/fig4-projection.png`） | `typ/fig4-projection.typ` | `png/fig4-projection.png` | 通过 | 1 | 向量投影：u/v 射线、垂足直角记号、θ 弧、双箭头度量线 |
| fig5 | EPUB `d2b587….png`（`src/fig5-bowl.png`） | `typ/fig5-bowl.typ` | `png/fig5-bowl.png` | 通过 | 2 | 碗形极小值：bezier 主曲线+椭圆口+点线经线+弯曲引线箭头 |
| fig6 | EPUB `45f5f1….png`（`src/fig6-dome.png`） | `typ/fig6-dome.typ` | `png/fig6-dome.png` | 通过 | 2 | 穹顶极大值，同 fig5 技法 |
| fig7 | `E:\pdf\…\bur\4e\4e2c3d….pdf` 第 9 页 Fig.3(a)（`src/fig7-attack.png`） | `typ/fig7-attack.typ` | `png/fig7-attack.png` | 通过 | 3 | 脉冲轨迹图；失败原因：decimal 不能入 content、脚本补丁误删绘制循环、首版脉冲分布不像 |

放弃记录：EPUB 彩色 3D mesh 曲面 3 张（不可矢量重绘）；`pdfA`（灰度机翼照片）、
`pdfB`（纯文字页）、`pdfC`（世界地图+彩条图）按筛选准则放弃。
