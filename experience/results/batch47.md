# batch47：升压变换器分类与隔离结构

图源：Forouzesh 等，*Step-Up DC–DC Converters: A Comprehensive Review of Voltage-Boosting Techniques, Topologies, and Applications*，2017，DOI 10.1109/TPEL.2017.2652318。来源和页面裁切见 SOURCE.json。

| 文件 | 图号 / PDF 页 | 视觉重试 | 判定与证据 |
|---|---|---:|---|
| pdf029-converter-classification | Fig.1 / 3 | 1 | 通过：顶部粉色分类节点、底部五类绿色节点、圆角分支的端点与位置对应原图；修正初版多行文字挤压，改为逐行定位置。 |
| pdf030-converter-isolation-structures | Fig.2 / 4 | 3 | 通过：四组框图、PWM/三电平升压电路、单级/两级隔离结构全部保留；底部虚框内四个开关网络也逐项核对。补齐次级引线、修正开关断口与接点、耦合虚线及多行标题。二极管方向、实心/空心节点、两种接地符号和绕组数符合源图。 |

本批 **2/2 完整图通过**，均为独立可编辑原生 CeTZ，实际编译为 300 ppi PNG，并查看最终原图/渲染比较。没有嵌入 SVG、源图或生成 PNG。原始 PDF 只读。

字体与源图不要求完全一致；源图标签用正体/数学模式替代字体轮廓，线描、电路拓扑和布局为主要依据。没有把电路缩成只有模块的框图，全部对应电路保留。

编译修正：Typst 小于比较需要 `x < mid`，连续 `x<mid` 被解析为标签。此为编译期修正，不计视觉重试。

复现：`python ../pdf-candidates/build.py . pdf029-converter-classification pdf030-converter-isolation-structures`；`python compare.py`。缩略预览 work/PDF-PREVIEW-8.png。

本篇 34 个图号仍有其余内容待逐项处理，下一步 Fig.3 单向/双向电路，下一新图号 pdf031。总体范围未完成。

## 曲极板连接补正（2026-09-26 14:19，Codex / batch55 回查）

此前下引线端点与 Bézier 曲极板中点之间有细小空隙，现按实际中点补齐；已重新 300 ppi 编译、重建比较并实际查看，保持通过。通过图数不增加。

当前累计视觉重试：pdf030-converter-isolation-structures = 3。本章更新后的 SOURCE.json 和当前比较图为最终证据，早期收口叙述的次数属于历史。
