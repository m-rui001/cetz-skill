# batch32 结果（Fourier 书 `work/fourier/`，前缀 ft）

认领见 `community.md` §9。源图 idx 18 / 39 / 56，均为线描、无灰底。

| 文件 | 源 idx | 内容 | 结果 | 编译次数 |
|---|---|---|---|---|
| `typ/ft18-spectrum.typ` | 18 | 线状谱：奇次谐波向上、偶次位置在轴下短划，`ν₀…6ν₀` 标签 | 通过 | 2 |
| `typ/ft39-uncertainty.typ` | 39 | 复平面 ā+b̄=c̄，c̄ 末端斜纹不确定区 + 三支双向弧箭头 | 通过 | 3 |
| `typ/ft56-comb-h.typ` | 56 | 矩形脉冲列 + 高度 `h` 断口双向箭头 + `x` 轴箭头 | 通过 | 2 |

3/3 通过，无放弃。对比图 `cmp_ft18-spectrum.png` / `cmp_ft39-uncertainty.png` / `cmp_ft56-comb-h.png`。

## 各图返工原因

- **ft18**：`$2nu_0$` 这类标签先写成 `${k}nu_0$`，`$...$` 内不是 content 插值语法，
  原样打出 `{k}`；改成先 `let lbl = str(k)` 再 `$#lbl nu_0$`。另外标签 y 从 -0.3 下移到 -1.05，
  否则压在轴下的短划上。
- **ft39**：三处坑。① `path((closed: true), ...)` 在 0.4.2 里报 "expected path or string, found dictionary"，
  多边形闭合要用 `line(close: true, ..verts)`；② `dash: "6pt"` 非法，只能给关键字或长度数组；
  ③ 斜纹区先把虚线和双向箭头盖住才像原图（见 EXPERIENCE 的"白色填充遮中段"）。
- **ft56**：`h` 的横向短划原书只有 1.1 个单位宽，我画成 2.2 显得像第二条轴；`x` 轴箭头改回常规粗细。

## 本批跳过 / 不选

- Fourier 书里纯公式块与照片类不选。

## 下一批候选

Fourier 书剩余可画线描图已明显变少，先做全书接触表复筛（idx 0–58）；
不够就转向 `E:\mathbook` 未开采书目。`E:/pdf` 侧等 Codex 回产能定调。
