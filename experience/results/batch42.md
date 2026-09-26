# batch42 结果（dg 书 + 新开的 Guillemin–Pollack《Differential Topology》）

| 图 | 源文件 | 结果 | 渲染次数 | 关键参数 |
| --- | --- | --- | --- | --- |
| dg27-geodesics | `src/dg27-raw.png` 1927×1028 | 通过 | 5 | 64pt / 6.5pt / S=148 |
| dt80-yjunction | `src/dt80-raw.png` 556×415 | 通过 | 2 | 9.5pt / 1.15pt / S=148 |
| dt69-simplex-field | `src/dt69-raw.png` 622×559 | 通过 | 4 | 无文字 / 1.5pt / S=148 |

3/3 通过，0 放弃。新前缀 `dt` = Guillemin & Pollack《Differential Topology》，
接触表 `work/batch42/sheet_dt.png` 有 37 张候选，是继 Fleisch、James 之后第三个可长期挖的书源。

## 记录两条

- 带下标的标签，字号要按"整框高度"而不是主字母高度来定。dg27 的 P₁ 框高 383px（P 235 +
  下标 1 另占一段），按整框算出 64pt 一次到位；中途按主字母猜成 74/80pt，反而来回试了两版。
  标定值：整框 ≈ 6.0 px/pt（S=148）。
- `mark: (pos: 0.55, end: hd)` 会把线从箭头处截断，箭头后面出现空白，不适合"箭头压在线中段"
  的原图样式。改法是整条线不带 mark，再单独画一段极短的共线小段只带 end 箭头，
  小段与主线重合不会留下可见笔迹。dt69 顶部/底部两条竖线即如此。
- 纯直线+箭头的图（dt69）比自由曲线好还原，但箭头尺寸要单独收：源图箭头约 25px 长、12px 宽，
  换算到 S=148 是 `length: 5pt, width: 2.2pt`；第一版按 8pt/5pt 画出来整个图被箭头吃掉。

## 未做

- `src/dg72-raw.png`（三张曲面+测地三角形，Gauss–Bonnet 配图）已取源但判为高难度：
  左侧鞍面外轮廓是不规则带缺口曲线，还混有虚线隐藏线。留到后面单开一批做，本批不计为放弃。
