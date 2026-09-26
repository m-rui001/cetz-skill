#set page(width: 260pt, height: 430pt, margin: 0pt)
#import "@preview/cetz:0.4.2": canvas, draw
#canvas({
  import draw: *
  let strs = ([∞], [$i$], [$k$], [$i = k$], [summation], [area], [∞ ∞])
  for i in range(strs.len()) {
    content((100.0pt, 400.0pt - 55.0pt * i), anchor: "center",
      [#text(size: 10pt)[#strs.at(i)]])
  }
})
