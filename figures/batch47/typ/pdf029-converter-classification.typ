#set page(width:auto,height:auto,margin:2pt)
#import "@preview/cetz:0.4.2":canvas,draw
#set text(font:"Times New Roman",size:10.9pt,weight:"bold")
#set par(leading:0pt)
#canvas(length:1pt,{
  import draw:*
  let s=1.45
  let P=(x,y)=>(s*(x - 117),s*(145 - y))
  let box=(x,y,w,h,c,t)=>{
    rect(P(x,y),P(x + w,y + h),radius:3.5*s,fill:rgb(c),stroke:none)
    for (i,c) in t.enumerate() {content(P(x + w/2,y + 8.6 + i*10.4),c)}
  }
  let branch=(x)=>{
    let mid=289.28
    if x==mid {line(P(x,92.9),P(x,116.2),stroke:1.2pt)} else {
      let d=if x < mid {-1} else {1}
      line(P(mid,92.9),P(mid,102),stroke:1.2pt)
      bezier(P(mid,102),P(mid + 3*d,105.5),P(mid,105),P(mid + d,105.5),stroke:1.2pt)
      line(P(mid + 3*d,105.5),P(x - 3*d,105.5),stroke:1.2pt)
      bezier(P(x - 3*d,105.5),P(x,109),P(x,105.5),P(x,106.5),stroke:1.2pt)
      line(P(x,109),P(x,116.2),stroke:1.2pt)
    }
  }
  for x in (147.80,218.67,289.28,357.27,438.86) {branch(x)}
  box(258.738,66.692,61.08,26.203,"#e5b9b5",([Step-Up DC-DC],[Converter]))
  box(119.16,116.306,57.276,26.202,"#c0e4ba",([Non-Isolated /],[Isolated]))
  box(188.123,116.306,61.085,26.202,"#c0e4ba",([Unidirectional /],[Bidirectional]))
  box(260.988,116.206,56.604,26.302,"#c0e4ba",([Voltage-Fed /],[Current-Fed]))
  box(326.732,116.132,61.085,26.389,"#c0e4ba",([Hard Switched /],[Soft Switched]))
  box(398.563,116.220,80.597,26.301,"#c0e4ba",([Non-Minimum-Phase /],[Minimum-Phase]))
})
