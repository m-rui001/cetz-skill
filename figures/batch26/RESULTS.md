# batch26 结果（Fleisch《向量与张量》EPUB，新编号 5 / 11 / 7）

| 图 | 源索引 | 文件 | 重试 | 结论 |
|---|---|---|---|---|
| fig79-rays | idx 5 | `typ/fig79-rays.typ` | 0 | 通过 |
| fig80-twotriad | idx 11 | `typ/fig80-twotriad.typ` | 0 | 通过 |
| fig81-wire | idx 7 | `typ/fig81-wire.typ` | 1 | 通过 |

图源：`work/fleisch/x/OEBPS/images`（EPUB 解包缓存），按 `sorted()` 文件名取第 5、11、7 张。

## fig79-rays（正/负点电荷的八向射线）

和 batch24 fig75 的"花瓣箭头"是同一类放射图，但这本图画的是**开口 V 形箭头**
（细线两笔），不是填充三角。V 不用算旋转矩阵，直接按极角加减：

```typ
let d = if out { a + 180deg } else { a }
line(tip, add(tip, sc(u(d + 32deg), leg)), stroke: tr)
line(tip, add(tip, sc(u(d - 32deg), leg)), stroke: tr)
```

`out` 一个布尔就把 (a) 朝外、(b) 朝内两栏统一了。射线起点留 `r0 = .32` 的空隙，
中心放 `$+$` / `$-$`，正是原书那个"断心"画法。

## fig80-twotriad（两套坐标架 + 一个矢量）

`triad(ox, oy, L, pr)` 闭包画 z 上 / y 右 / x 左下 225° 的标准三轴，
`pr` 传 `"'"` 时标签自动变 `$z'$`、`$y'$`、`$x'$`。
带撇的原点系要**手拆**：原书 z′ 轴中段有一处断口（两栏重叠留下的），
闭包给不了这个细节，所以在外面把 z′ 改写成两段 `line`。
经验：闭包负责"结构相同"，断口/缺口这类版式细节在调用处破例，别往闭包里加参数。

## fig81-wire（载流直导线与同心磁场圈）

椭圆环上的切向箭头没法用 `arc`（`arc` 只认圆），改成**参数化点列 + `line(path:)`**：

```typ
let ell = (rx, ry, a0, a1, n) => { ... pts.push((cx + rx*cos(t), cy + ry*sin(t))) }
line(path: true, close: true, ..ell(rx, ry, 0deg, 360deg, 73), stroke: te)
line(path: true, ..ell(rx, ry, 148deg, 170deg, 7), stroke: te, fill: luma(18%), mark: (end: ">"))
```

- 整环：0→360°、73 点、`close: true`。
- 箭头：只取 148→170°（左侧）和 328→350°（右侧）一小段，末端 `mark: (end: ">")`，
  切向自动正确——左侧朝左下（出纸面）、右侧朝右上（入纸面），和 B 标签呼应。
- **`mark` 的箭头要实心必须给这条线加 `fill:`**，只写 stroke 会画成空心 V。
- 扁率 `ry = rx * 0.265`；第一版用 0.30 显得环太鼓、箭头是空心的，重试一次。

## 淘汰/跳过记录（新编号）

- idx 2：三维灰面网格曲面 → 跳过。
- idx 9 / 19 / 25 / 31：公式为主体 → 跳过。
- idx 23：角动量图，5 个质量点 + 6 个矢量标签 + 进出纸面符号 → 密度超门槛，跳过。
- idx 21：立方体 + 六个方位标签 + 虚线对角 → 暂缓（可下批再试）。
- 下一批候选（新编号）：3、17、29、63、21。
