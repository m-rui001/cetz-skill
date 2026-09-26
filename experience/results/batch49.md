# batch49：完整单向/双向与电压/电流馈电结构

| 文件 | 来源 | 视觉重试 | 判定与证据 |
|---|---|---:|---|
| pdf031-directional-converters | Fig.3，PDF 5 页 | 3 | 通过：完整 (a) 单向 Buck/Boost、(b) 双向 Boost、(c) 全桥及二极管整流、(d) 双有源桥，保留四组总线框图、电流路径、功率流箭头、黄色器件区域和 MOSFET 等效图例。修正绕组间距、漏感尺寸、MOSFET 体二极管尾线和开关位置。 |
| pdf032-voltage-current-fed | Fig.4，PDF 6 页 | 3 | 通过：完整 (a) 输入/开关/整流选择、(b) 电压源馈电全桥、(c) 电流源馈电全桥、(d) 辅助变压器方案；两类输入源、不同滤波位置、桥臂、蓝色关系箭头、端口及标签齐全。修正绕组凸出与磁芯间距、多行标题避让。 |

本批 **2/2 完整图通过**，均为自包含原生 CeTZ，实际编译为 300 ppi PNG，并查看完整图和四处放大比较。文字不要求字体完全相同，器件轮廓、连接、断口、布局及方向按原图核对。

变压器用贝塞尔半环与双磁芯线，电路交叉用跨线小弧表示不相连，节点用实心点。电路符号由原生局部函数构建，没有导入图片或 SVG。图中器件层数/数量保留，未用大模块框图替换详细电路。

Fig.4 图内含 (d) 辅助变压器面板，图注仅列前三项；按实际图面保留 (d)，不因图注省略而漏画。

目录协调：Agent-C 在源提取前先建立 batch48；原子 mkdir 返回占用，我之后误继续生成了自己的 PDF 文件。现只将 4 个 pdf031/pdf032 文件和我的 draw.py 移至独占创建的 batch49，其他 dt 产物仍在 batch48。最终两图已从 batch49 路径重新编译。该错误和正确停止顺序已总结至 EXPERIENCE.md。

来源及裁切见 SOURCE.json。原图 `src/`、源码 `typ/`、编译结果 `png/`、完整比较 `cmp_*.png`。`detail-*.png` 是第二版的放大检查，不替代第三版的最终完整比较。

复现：`python draw.py`；`python ../pdf-candidates/build.py . pdf031-directional-converters pdf032-voltage-current-fed`；`python compare.py`。预览 work/PDF-PREVIEW-9.png。

本篇已通过 Fig.1–4，仍有其余图号待逐项处理，下一步 Fig.5 谐振/软开关网络，下一新图号 pdf033。整体目标保持未完成。

## 曲极板连接补正（2026-09-26 14:19，Codex / batch55 回查）

此前下引线端点与 Bézier 曲极板中点之间有细小空隙，现按实际中点补齐；已重新 300 ppi 编译、重建比较并实际查看，保持通过。通过图数不增加。

当前累计视觉重试：pdf031-directional-converters = 3、pdf032-voltage-current-fed = 3。本章更新后的 SOURCE.json 和当前比较图为最终证据，早期收口叙述的次数属于历史。
