# CeTZ 0.4.2 API Cheatsheet

## 1. Importing

**Recommended:**
```typst
#import "@preview/cetz:0.4.2": canvas, draw
```

**Import specific submodules:**
```typst
#import "@preview/cetz:0.4.2": canvas, draw, palette
#import "@preview/cetz:0.4.2": chart, plot, angle // Explicit import for advanced features
```

---

## 2. Basic Elements

All drawing commands must be within the `canvas` block and called via `draw`.

| Command | Syntax Example | Description |
| :--- | :--- | :--- |
| `line` | `draw.line((0,0), (1,1), stroke: red)` | Line segment |
| `circle` | `draw.circle((0,0), radius: 1, fill: blue)` | Circle |
| `rect` | `draw.rect((0,0), (2,2), stroke: 2pt)` | Rectangle |
| `content` | `draw.content((0,0), [Hello])` | Renders Typst content |
| `bezier` | `draw.bezier((0,0), (2,0), (1,1))` | Bezier curve (Start, End, Control) |

---

## 3. Coordinates & Anchors

- **Absolute:** `(x, y)` or `(x, y, z)` - e.g., `(0, 0)`
- **Relative:**
    - `(rel: (dx, dy))` - Relative to the previous point.
    - `(rel: (dx, dy), to: (px, py))` - Relative to a specific point `to`.
- **Polar:** `(angle: 45deg, radius: 2)`
- **Anchors (Named Elements):**
    - Define name first: `draw.rect((0,0), (2,2), name: "box")`
    - Reference anchor: `"box.top"`, `"box.bottom-right"`, `"box.center"`
    - Common anchors: `.north`, `.south`, `.east`, `.west`, `.center`, `.top-left`, etc.

## 4. Styling Guide

All drawing functions accept styling parameters:

| Property | Syntax Example | Description |
| :--- | :--- | :--- |
| **Stroke** | `stroke: 1pt` | Line thickness |
| | `stroke: red` | Color |
| | `stroke: (paint: blue, dash: "dashed")` | Dashed lines ("dashed", "dotted") |
| **Fill** | `fill: red` | Fill color |
| | `fill: blue.lighten(50%)` | Transparent fill |
| **Mark** | `mark: (end: ">")` | Arrowhead |
| | `mark: (start: "o", end: "stealth")` | Dual markers |

---

## 5. Pitfalls & Warnings

### ⚠️ Mark Syntax
**WRONG:** `mark: ">"` or `mark: "stealth"`
**CORRECT:** Must use a dictionary.
```typst
draw.line((0,0), (1,0), mark: (end: ">"))
draw.line((0,0), (1,0), mark: (start: "stealth", end: "latex", fill: red))
```

### ⚠️ Fill Color
CeTZ `fill` usually requires explicit colors. Use `.lighten()` for transparency.
```typst
draw.circle((0,0), fill: blue.lighten(80%))
```

### ⚠️ Submodule Imports
Complex modules like `cetz.angle` are not auto-exported in `draw`.
```typst
#import "@preview/cetz:0.4.2": angle
// Use angle.angle(...) instead of draw.angle(...)
```

### ⚠️ Stroke Style
**Issue:** Complex stroke dictionaries can cause "Failed to resolve coordinate system" errors.

| Scenario | Correct Syntax | Wrong Syntax |
| :--- | :--- | :--- |
| Simple line | `stroke: 0.8pt` | - |
| Colored line | `stroke: red` | - |
| Weight + Color | `stroke: (paint: red, thickness: 2pt)` | Use only if simple fails |

```typst
// ✅ Correct - Simple syntax (Recommended)
draw.line((0,0), (1,1), stroke: 0.8pt)
draw.line((0,0), (1,1), stroke: red)

// ❌ Wrong - Complex dictionaries might fail
let style = (stroke: (paint: red, thickness: 1pt), mark: (end: ">"))
draw.line((0,0), (1,1), style)  // ERROR!
```

### ⚠️ Debugging "Failed to resolve coordinate system"
1. Check if the stroke style dictionary is malformed.
2. Try simplifying to `stroke: 0.8pt`.
3. Ensure the `draw.` prefix is used.
4. Check for dangling commas or brackets.

### ⚠️ Always use `draw.` prefix (Recommended)
To avoid naming conflicts and unexpected errors, always use the prefix:
```typst
// ✅ Recommended
draw.line(...)
draw.rect(...)
draw.content(...)
draw.circle(...)

// ⚠️ May cause errors (depending on import)
line(...)
rect(...)
content(...)
```

---

## 6. Mark Types

| Name | Description |
| :--- | :--- |
| `">"` | Standard Arrow |
| `"|"` | Vertical Line |
| `"stealth"` | Stealth/Streamlined Arrow |
| `"latex"` | LaTeX-style Arrow |
| `"circle"` | Dot |

---

## 7. Plotting (CeTZ-Plot)

Plotting requires the `plot.plot` environment.

```typst
#import "@preview/cetz:0.4.2": canvas, plot

#canvas({
  plot.plot(size: (4, 4),
    x-tick-step: 1,
    y-tick-step: 1,
    {
      plot.add(domain: (-2, 2), x => calc.pow(x, 2))
    })
})
```

---

## 8. Layout & Groups

Use `draw.group` to encapsulate local coordinates for modular drawing.

```typst
draw.group({
  draw.scale(0.5)           // Local scale
  draw.rotate(30deg)        // Local rotation
  draw.translate((2, 0))    // Offset origin
  
  // Draw in local coordinates
  draw.rect((-1, -1), (1, 1), stroke: blue)
})
```

---

## 9. Connecting Nodes

Use anchors to connect elements automatically, ideal for flowcharts.

```typst
// 1. Define nodes
draw.content((0, 0), [Start], name: "start")
draw.content((0, -2), [Process], name: "proc")

// 2. Connect at edges
draw.line("start.south", "proc.north", mark: (end: ">"))

// 3. Complex path
draw.line("start.east", (rel: (1,0)), "proc.east", mark: (end: ">"))
```

---

## 10. Simple Plot library

Simplified plotting based on CeTZ 0.4.2.

**Import:**
```typst
#import "@preview/simple-plot:0.3.0": plot
```

**Example:**
```typst
#import "@preview/cetz:0.4.2": canvas
#import "@preview/simple-plot:0.3.0": plot

#canvas({
  plot.plot(
    data: ((0, 0), (1, 1), (2, 4)),
    size: (6, 4),
    x-label: [Time],
    y-label: [Value],
    title: [Simple Plot Example]
  )
})
```
