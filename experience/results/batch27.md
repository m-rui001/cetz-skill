# batch27 结果

来源：Fleisch《A Students Guide to Vectors and Tensors》EPUB 图片缓存
（`D:/cetz-skill/work/fleisch/x/OEBPS/images`，编号 = `sorted(os.listdir())` 下标）

| 图 | idx | 结果 | 重试 | 说明 |
|---|---|---|---|---|
| fig82-masses | 82 | 通过 | 1 | 双面板，五个质量点 + a/2a 虚线构造线，斜置坐标轴 |
| fig83-slope | 83 | 通过 | 3 | 斜面上的物块 + Fn/Ff/Fg 三力，斜面线兼作 +x 轴 |
| fig84-rotaxes | 84 | 通过 | 1 | 旋转坐标系下同一矢量的两种分解：(a) 矩形、(b) 平行四边形 |

## 本批经验（详见 ../EXPERIENCE.md）

- 圆角矩形不要用 `curve: (cyclic: true, tension: 78%)`，会断角；改成 4 个角各采样 9 点的圆弧 + `line(path: true, close: true, ...)`，再整体用 `R(p)` 旋到斜面坐标系。
- `anchor` 必须连字符：`"south-west"`，写 `"south west"` 直接 panic。
- Typst 数组的 `+` 是拼接不是相加，`sc(u(28deg), -4.05) + (0.05, 0.18)` 会变成四维坐标而报"Failed to resolve coordinate system"；一律用自定义 `add(p, q)`。
- 斜面的边线可以直接当作 x 轴画（一条线 + `mark: (end: ">")`），不需要再单独画轴，位置天然重合。
- 旋转坐标系分解：primed 分量用投影 `a = dot(T, ex)`、`Cx = sc(ex, a)` 算，比手摆坐标稳。

## 跳过清单（本批筛查后放弃）

- idx 3 / 21：公式排版密度高，插图本身只是公式块，转 CeTZ 无意义。
- 灰度底纹照片类、手绘草图类：线条不规则，矢量还原性价比低。

## 下一步

- Fleisch 剩余候选需重新联系表筛查。
- **转向 `E:/pdf`**：objective 的另一半，本批尚未推进。
