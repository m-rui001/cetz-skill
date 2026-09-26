# batch58 — Fig.13 完整半波倍增整流器

来源：Forouzesh 等，*Step-Up DC–DC Converters: A Comprehensive Review of Voltage-Boosting Techniques, Topologies, and Applications*，IEEE TPEL 2017，DOI 10.1109/TPEL.2017.2652318，PDF14。只读来源与裁切范围见 SOURCE.json。

| 图与范围 | 自包含原生 CeTZ | 编译 | 最终实际目视结论 | 视觉重试 |
|---|---|---|---|---:|
| Fig.13 完整 (a)–(e) | typ/pdf040-half-wave-multiplier-rectifiers.typ | 300 ppi | 通过 | 1 |

1/1 完整图通过，无放弃；五面板不重复计五张。初稿和最终修正后的完整原图/渲染比较均实际查看。

## 范围与实际修改

- 完整保留 Greinacher doubler、改进型 doubler、quadrupler、CW doubler 和通用 CW multiplier。所有电容、二极管、节点、端口、接地、输入波形小符号、输出公式、名称、奇偶标记、级联省略号和黄底区域均保留。
- 三角支路中的二极管在导线的局部方向中构造三角形及横杆，跟随斜边指向。没有将斜向器件改为水平图标。
- (c) 左侧回接线穿过中性点导线，以原图跨线弧保留非连接；中性输出是实心点，顶/底输出是空心端口。Neutral/Point 分置中性线两侧。
- 第一稿二极管偏小、方波折线方向不同、(c) 紫色输入符号偏高；一次视觉修正统一了器件尺寸、方波方向，并把 (c) 符号下移到原位置。
- 最终 .typ 仅用 CeTZ 几何与 Typst 文字，不读取源图或 SVG，不依赖其他批次。原图 src/、300 ppi PNG png/、最终 cmp_、SOURCE.json 和编辑生成器已齐；预览 work/PDF-PREVIEW-15.png。

下一步同页 Fig.14 完整六组全波倍增整流器，pdf041 起。定量图排除、字体宽容和完整范围标准保持。
