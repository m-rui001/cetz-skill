# batch46：Fig.6 的平面局部示意

| 文件 | 来源 | 视觉重试 | 判定 |
|---|---|---:|---|
| pdf026-bob-polarization-optics | Fig.6 (4) Bob 接收光路，xref1113 右侧裁切 | 1 | 通过：50:50 BS 分至两组偏振控制器/PBS，再到四个 SNSPD；原始位置、支路颜色和标签对应，修正探测器端口的小间隙。 |
| pdf027-alice-input-optics | Fig.6 (4) Alice 输入链，xref1119 左侧裁切 | 0 | 通过：Laser、Intensity Mod.、三个偏振控制元件与黄色输出光纤保持源图位置和比例。仅验收进入芯片之前的平面链。 |
| pdf028-polarization-sphere | Fig.6 (2)d，xref1127 局部 | 1 | 通过：球面轮廓、两条主要调制弧、方向箭头、四个 CDM 及态标签位置对应；补齐纵向弧的向下箭头。淡色球面辅助曲线近似。 |

本批 **3/3 局部示意通过**，均独立原生 CeTZ、300 ppi 编译并查看实际最终比较图。没有嵌入源图或渲染位图。字体按用户要求只需清楚。

**范围**：原图参考没有修改，Bob/Alice 图中的地图摄影背景已明确筛查排除，比较的是叠加的平面光路。Alice 的邻接透视芯片不在本次范围。两个光路文字由白色改为黑色以便在白底辨认，器件文字仍白色。不能据此宣称完整 Fig.6 复刻通过。

本篇 20 图号已逐项处理：13 整图通过，Fig.8/6 可用局部通过，其余部分筛查排除，5 数据曲线按用户要求排除。Fig.6 密集立体芯片和材质截面已按用户最新意见筛查排除；batch45 两个失败视觉尝试和一个终止草稿保持单独记录。

复现：`python ../pdf-candidates/build.py . pdf026-bob-polarization-optics pdf027-alice-input-optics pdf028-polarization-sphere`；`python compare.py`。裁切位置与来源见 SOURCE.json。继续从 PDF 语料选下一篇适合 CeTZ 的插图，下一图号 pdf029；整体目标仍未完成。
