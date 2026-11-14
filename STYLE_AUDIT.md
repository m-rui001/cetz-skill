# Typst 源码风格审计 — figure-as-code

整改分支 `style-typst`。审计脚本 `tools/style_audit.py`，标准 `tools/TYPST_STYLE.md`。
只动源码形态，不改变图的内容与版式；每条改动以编译通过为准。

```
python -X utf8 tools/style_audit.py . --glob "figures/**/*.typ" > /tmp/style.csv
python -X utf8 tools/compile_all.py --jobs 4
```

## 修前 → 修后

361 个 `.typ` 文件（一个文件一幅图）。

| 指标 | 修前 | 修后 |
| --- | ---: | ---: |
| >120 字符的代码行 | 421 | 361 |
| 装饰性注释横幅（`// =====`） | 496 | 0 |
| 裸 LaTeX 命令（`\frac`、`\alpha` 等） | 30 | 28 |
| 手调空白 `#v(...)`/`#h(...)` | 6 | 6 |

编译门槛：**361/361 编译成功，0 失败，36 条警告**（字体回退），与整改前一致。

## 改了什么

- 删除 496 条纯装饰分隔横幅，保留说明绘图依据与坐标的注释。
- 超长 `#figure(...)`/`#canvas(...)` 调用在参数逗号处折行，缩进 2 空格。
- Christoffel 图里的 `$\hat(e)_r$` 改为 Typst 写法 `$hat(e)_r$`（原来会渲染成字面 `\hat`）。

## 剩余项与判定

- **>120 字符 361 行**：每个文件一条，是 `#figure(...)` 调用或 canvas 主体；
  再折会打断图元列表的可读性，保留。
- **裸 LaTeX 28 处**：全部在 `//` 注释内（原图配色定义、原图标题），不渲染。
- **`#v/#h` 6 处**：canvas 内标签的刻意间距，属版式代码。
