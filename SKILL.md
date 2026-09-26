---
name: cetz-skill
description: High-quality scientific diagramming for Typst using CeTZ 0.4.2
---

# CeTZ Skill

CeTZ (CeTZ, ein Typst Zeichenpaket) is a powerful library for drawing with [Typst](https://typst.app). This skill focuses on high-quality scientific diagramming using CeTZ 0.4.2.


## Quick Start

To use CeTZ in a Typst document, import the library and use the `canvas` function:
```typ
#import "@preview/cetz:0.4.2"

#cetz.canvas({
  import cetz.draw: *
  
  // Draw a simple circle
  circle((0,0), radius: 1, fill: blue.lighten(80%), name: "c")
  
  // Draw a line with a marker relative to the circle
  line("c.east", (2,0), mark: (end: ">"))
  // Add some text
  content((1, 0.5), [Hello CeTZ!])
})
```

## Workflow (CRITICAL!)

Follow this process to maximize first-shot success:

1.  **Analyze & Plan**
    *   **Layout**: Choose between hierarchical (top-down), radial, or grid layouts.
    *   **Coordinate System**: For complex figures, establish a $(0,0)$ origin first.
    *   **Modularize**: Define repetitive structures (like neural network nodes) as Typst functions.

2.  **Draft Structure**
    *   Draw Nodes first, ignoring connections initially.
    *   Use `draw.content` or `draw.rect` to place core elements.
    *   *Tip*: Assign `name: "id"` to key elements for easy referencing.

3.  **Connect & Style**
    *   Connect nodes via anchors: `draw.line("nodeA.east", "nodeB.west")`.
    *   Add Marks: Arrows, ticks, or custom markers.
    *   Apply Styles: Unified colors and stroke widths.

4.  **Compile & Verify**
    *   Check for overlaps.
    *   Verify arrow directions.

5.  **Refine**
    *   Adjust `canvas(length: ...)` to scale the overall size.
    *   Fine-tune coordinates for perfect alignment.

## Correct Syntax (CRITICAL!)

| Feature | Correct Syntax (0.4.2) | Note |
| :--- | :--- | :--- |
| **Import** | `#import "@preview/cetz:0.4.2"` | Always use 0.4.2 for stability |
| **Canvas** | `#cetz.canvas({ ... })` | Drawing logic goes inside the block |
| **Coordinate** | `(x, y)` or `(x, y, z)` | Cartesian coordinates |
| **Relative** | `(rel: (1, 0))` | Relative to the previous point |
| **Anchors** | `"name.anchor"` | e.g., `"rect.north-east"` |
| **Styling** | `stroke: (paint: blue, thickness: 1pt)` | Detailed stroke control |
## 常见错误与修复 (Common Pitfalls - CRITICAL!)

### ❌ WRONG - Causes "Failed to resolve coordinate system"
```typ
// Complex stroke dictionary often fails
let arrow-style = (stroke: (paint: red, thickness: 1pt), mark: (end: ">"))
line("a.east", "b.west", arrow-style)  // ERROR!

// Missing draw. prefix (sometimes works, sometimes doesn't)
rect((0,0), (1,1))  // May fail
content((0,0), [Text])  // May fail
```

### ✅ CORRECT - Working Patterns
```typ
// Simple stroke - WORKS
draw.line("a.east", "b.west", stroke: 0.8pt)

// Named imports + draw. prefix - ALWAYS WORKS
#import "@preview/cetz:0.4.2": canvas, draw

draw.rect((0,0), (1,1), fill: blue, stroke: red)
draw.content((0,0), [Text], anchor: "center")
draw.circle((0,0), radius: 1)
draw.line((0,0), (1,1))
```

### 🔧 Import Patterns (Choose One)

**Pattern A: Full import (recommended for beginners)**
```typ
#import "@preview/cetz:0.4.2": *
```

**Pattern B: Named imports (recommended for reliability)**
```typ
#import "@preview/cetz:0.4.2": canvas, draw

canvas({
  draw.content((0,0), [More explicit, safer])
  draw.rect(...)
})
```

**Pattern C: Mixed (what examples often show)**
```typ
#import "@preview/cetz:0.4.2": canvas
#import "@preview/cetz:0.4.2": draw
#import draw: content, line, rect

canvas({
  content((0,0), [Works])  // from imported content
  draw.rect(...)            // from draw module
})
```

### 📋 Stroke Style Guide

| Style Need | Correct Syntax | Example |
| :--- | :--- | :--- |
| Simple line | `stroke: 0.8pt` | `draw.line((0,0), (1,1), stroke: 0.8pt)` |
| Colored line | `stroke: red` | `draw.line((0,0), (1,1), stroke: red)` |
| Custom thickness | `stroke: (paint: red, thickness: 2pt)` | Use only when simple version fails |
| With arrow marker | Use separate mark parameter | See examples |

### 🐛 Debugging Tips

1. **If you get "Failed to resolve coordinate system":**
   - Check if stroke style dictionary is malformed
   - Try simplifying to `stroke: 0.8pt`
   - Make sure you're using `draw.` prefix

2. **If content/rect/line not found:**
   - Add `#import draw: content, line, rect`
   - Or use `draw.content()`, `draw.rect()`

3. **If canvas not found:**
   - Use `#import "@preview/cetz:0.4.2": canvas`

## Categorized Examples

All examples are sourced from [janosh/diagrams](https://github.com/janosh/diagrams) (MIT License).

### Machine Learning (ML)
- [Self-Attention Mechanism](../../assets/ml-self-attention.typ)
- [Autoencoder Architecture](../../assets/ml-autoencoder.typ)
- [2D Convolution Operation](../../assets/ml-2d-convolution.typ)
- [Variational Autoencoder (VAE)](../../assets/ml-variational-autoencoder.typ)

### Quantum Mechanics (QM)
- [Bloch Sphere](../../assets/qm-bloch-sphere.typ)
- [Feynman Diagram](../../assets/qm-feynman-diagram.typ)

### Statistics (STAT Figure)
- [Maxwell-Boltzmann Distribution](../../assets/stat-maxwell-boltzmann.typ)
- [Bose-Einstein Distribution](../../assets/stat-bose-einstein.typ)
- [Statistical Energy Distribution](../../assets/stat-statistical-energy.typ)


### Chemistry (CHEM)
- [Periodic Table Component](../../assets/chem-periodic-table.typ)

### Common Diagrams (COMMON)
- [Heatmap](../../assets/common-heatmap.typ)
- [K-Nearest Neighbors (KNN)](../../assets/common-knn.typ)

## API Reference

For a detailed list of functions, coordinates, and styling options, see the [API Cheatsheet](../../references/api-cheatsheet.md).

## Copyright & License

- **CeTZ**: LGPL-3.0 License.
- **Diagram Examples**: Based on [janosh/diagrams](https://github.com/janosh/diagrams), MIT License.
- **Skill**: MIT License.
