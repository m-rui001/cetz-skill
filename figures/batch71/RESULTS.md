# batch71 结果（Guillemin–Pollack 线描插图，Agent-C）

| 图 | typ | overlay mean | ar(src/ren) | 结论 |
|---|---|---|---|---|
| dt2 双纽线（8 字，自交一次、下端开口） | typ/dt2-eight.typ | 0.50 px | 0.619 / 0.610 | 通过 |
| dt9 Source（中心实心点 + 6 条放射箭头 + 文字） | typ/dt9-source.typ | 0.59 px | 1.020 / 1.015 | 通过 |

两张都用 `work/batch70/tr.py`，没有再写提取脚本。

## dt2：开口曲线也能用海龟追踪，起点选自由端

`tr.trace(start, -90)` 从下端一个自由端出发，86 点后返回 `OPEN` 停在另一个自由端
（起点 (52.5,213) → 终点 (121,212.5)），中间的自交点靠"前视 ±55° 直行"直接穿过去。
**开口图形的起点必须取自由端**（这里是最后一行 `y=213` 的两个 run 中心之一），
否则从极值点起步会只追到一半。`CLOSED`/`OPEN` 两种返回值都要处理：`OPEN` 时不能把首尾再接一次。

## dt9：给 tr.py 加了通用 `arrow()`，直杆 + V 头一次拆对

```python
def arrow(mask, head_r=24.0):
    """Straight-shaft arrow with a V head -> (tail, tip, b1, b2)"""
    den = ndimage.gaussian_filter(mask.astype(float), 4.0)   # 头 = 局部墨最厚处
    head = argmax(den)
    sh  = 距 head > head_r 的墨点  ->  tail = 其中离 head 最远的
    u   = (head - tail) 单位向量, n = 法向
    hb  = 距 head <= head_r 的墨点 ->  tip = 沿 u 最远, b1/b2 = 沿 n 的两个极值
```

六个箭头全部一遍拆对（含两条**灰掉一半**的水平箭头——密度极值对灰度不敏感，所以照样定位）。
渲染就是三条 `line`：`tail→tip`、`tip→b1`、`tip→b2`，统一 1.15 pt。

第一版 `arrow()` 是错的：用"6 px 邻域计数"找最厚点，采样步长 7 导致选中了笔画拐角，
返回值 tip 和 tail 重合、barbs 为 0，渲染几乎空白（`ar 0.443`、`scale 10.37`）。
改成 `gaussian_filter(mask, 4.0)` 取 argmax 后一步到位。**找"最粗的地方"要用平滑密度，不要用硬邻域计数。**

## Typst 语法

`set line(...)` 不行：`only element functions can be used in set rules`——CeTZ 的 `line` 是绘图函数不是
Typst 元素，笔画只能逐条写在参数里。

## 延后 / 不适合

- dt79（球 + 两条经线 + 赤道虚弧）仍延后，原因与改法见 `batch70/RESULTS.md`。本轮又验证一次：
  外轮廓按 ±4 膨胀清除后，剩余墨迹是**一个** 5563 px 的连通块（两条经线 + 赤道前半在赤道处互相交叉、
  又在两极共点），"追一条清一条"在这里不收敛。
- 本批新扫的 12 张里：dt7/dt13 是整行公式无几何；dt10 墨迹占比 0.449（灰面）；dt3 含立体圆柱渲染；
  dt26 浸入 Klein 瓶带点画阴影——按既定判据都不做。dt1（Saddle 8 条弯曲箭头）、dt20（嵌套椭圆 + 虚线短弧）
  适合做，留下批。
