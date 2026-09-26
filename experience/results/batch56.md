# batch56 结果（Guillemin–Pollack《Differential Topology》线描插图）

来源：`E:/EPUB/[Guillemin,Pollack]Differential_Topology(1974)/.../render/*.epub`，
`src/NN-raw.png` 由 `grab.py <zip序号>` 导出。负责人：Agent-C（Qoder 绘图进程）。
日期：2026-09-26。

## 通过

| 图 | 源序号 | 内容 | overlay 偏移 | 备注 |
|---|---|---|---|---|
| `dt44-curves` | 44 | "Curves in R²"：Transversal / Nontransversal 两栏共 6 条开曲线 + 2 个实心点 + 3 段文字 | 0.37 px，scale 2.6129，ar 3.159/3.191 | 一次几何通过，文字字号重标一次 |
| `dt32-deform` | 32 | "Small deformation of f"：z 轴 + 摆动曲线 f(x) + 2 条虚线形变 + 2 条带箭头指示线 | 0.73 px，scale 2.6421，ar 2.725/2.699 | 一次通过；虚线周期实测 19px/8px → `(3.6pt, 1.5pt)` |

2/2 提交，0 放弃。

## 本批不做 / 已排除

- dt44 下行：带阴影的曲面，按 13:02 规则（不复刻立体芯片/材质效果图）剔除。
- dt33：同上，shaded 3D 曲面。
- dt43：嵌套 K 集 + 斜线填充环带。几何本身不复杂，但阴影线（hatch）的周期与相位需要单独标定，
  留给下一批或时间富余时再做。
- dt55：S¹ 切向量场 + 螺旋线。切向量短线段数量多，属"密集小元素"，overlay 指标会被
  单像素抖动抬高（batch51 gt030 的教训：23 个箭头即使全对，mean dist 也停在 1.4 px 左右），
  判定收益低，暂缓。
- dt39：数据曲线图，按 master 规则不纳入统计。

## 剩余候选（本书）

0, 8, 15, 28, 31, 43, 55, 59, 62–65, 67, 73, 76–78。
已完成：47, 50, 14, 37, 12, 41, 69, 72, 80, 54, 18, 24, 44, 32（分属 batch43/48/52/56）。

## QC 命令

```bash
cd /d/cetz-skill/work/batch56
typst compile --root . --font-path /c/Windows/Fonts typ/NAME.typ png/NAME.png
python ../ov2.py . NAME      # 注意：用 ov2.py，不是 ov.py
python psk.py NAME
```
