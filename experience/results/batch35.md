# batch35：两种量子中继示意图

来源：《Advances in Quantum Cryptography》。精确路径、页码和裁切范围见 `SOURCE.json`；源 PDF 只读。

| 文件 | 原图 | 视觉重试 | 判定及依据 |
|---|---|---:|---|
| pdf010-repeater-levels | Fig.17，PDF 83 页 | 1 | 通过：上部通用 n 层网络、下部两层 BSM 演变、青色节点、虚线双向连接、红圈、弯曲进程箭头和距离表达式保持原图布局。 |
| pdf011-probabilistic-repeaters | Fig.18，PDF 84 页 | 1 | 通过：量子存储器阵列、红色纠缠链、两组 BSM、括号、断续列和总距离/单段距离的对应关系接近原图。 |

本批 **2/2 通过，0 视觉放弃**。两张均实际编译为 300 ppi PNG，并查看了上下排列的原图/渲染对比；首稿后修正了双向箭头的方向与实心头部、旋转文字方向和纠缠链环幅度。字体按用户要求只保证清楚且符号正确。

编译修正：CeTZ 的椭圆须写 `circle(center, radius: (rx, ry))`，并非 `ellipse`。编译工具补充自动创建 `png` 目录。

用户新增范围：**数据曲线图不需要复刻**。Fig.3 的未编译草稿与原始裁切已归档到 `skipped-data-plots/`，不计入尝试/通过/放弃，后续不继续制作。图号 pdf012 保留给该跳过记录，下一新图从 pdf013 起。

文件：`typ/` 独立 CeTZ 源码，`src/` 原图，`png/` 成品，`cmp_*.png` 比对。复现命令：`python ../pdf-candidates/build.py . pdf010-repeater-levels pdf011-probabilistic-repeaters`，然后 `python compare.py`。
