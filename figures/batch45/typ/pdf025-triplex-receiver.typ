#set page(width:auto,height:auto,margin:2pt)
#import "@preview/cetz:0.4.2":canvas,draw
#set text(font:"Arial",size:9pt)
#set par(leading:0pt)
#canvas(length:1pt,{
  import draw:*
  let s=1
  let P=(x,y)=>(s*x,s*(145 - y))
  let poly=(pts,c)=>line(..pts.map(p=>P(..p)),close:true,fill:rgb(c),stroke:none)
  let wave=(pts,t:1.1,c:"#f4f3ef")=>line(..pts.map(p=>P(..p)),stroke:(paint:rgb(c),thickness:s*t*1pt))
  let curve=(a,b,c,d,t:1.1,color:"#f4f3ef")=>bezier(P(..a),P(..b),P(..c),P(..d),stroke:(paint:rgb(color),thickness:s*t*1pt))
  let label=(x,y,c,size:7,fill:white)=>content(P(x,y),text(size:s*size*1pt,fill:fill,c))
  let box=(x,y,w,h,c)=>rect(P(x,y),P(x + w,y + h),fill:rgb(c),stroke:none)
  let heater=(x,y,w,h)=>{
    box(x,y,w,h,"#b1a057")
    box(x + 1,y + .8,w - 2,h - 1.6,"#e6c24c")
  }
  let mz=(x1,x2,y,r:4)=>{
    curve((x1,y),(x1 + 12,y - r),(x1 + 5,y),(x1 + 5,y - r))
    wave(((x1 + 12,y - r),(x2 - 12,y - r)))
    curve((x2 - 12,y - r),(x2,y),(x2 - 5,y - r),(x2 - 5,y))
    curve((x1,y),(x1 + 12,y + r),(x1 + 5,y),(x1 + 5,y + r))
    wave(((x1 + 12,y + r),(x2 - 12,y + r)))
    curve((x2 - 12,y + r),(x2,y),(x2 - 5,y + r),(x2 - 5,y))
  }

  // Coordinates are relative to the cropped (3)b panel.
  poly(((21,23),(545,23),(578,118),(4,118)),"#151735")
  poly(((4,118),(578,118),(566,123),(8,123)),"#06091e")
  // Lower tunable beam splitter, then the phase decoder branches.
  wave(((7,99),(32,99)))
  wave(((12,82),(32,82)))
  mz(32,123,90.5,r:8.5)
  wave(((123,90.5),(137,82),(164,82)))
  wave(((123,90.5),(137,99),(571,99)))
  wave(((16,66),(164,66)))
  mz(164,250,74,r:8)
  wave(((250,74),(258,74)))
  mz(258,291,74,r:8)
  wave(((291,66),(507,66)))
  wave(((291,82),(507,82)))
  mz(507,546,74,r:8)
  wave(((546,66),(560,66)))
  wave(((546,82),(565,82)))
  heater(72,97,27,5)
  heater(197,80,26,5)
  heater(380,80,27,5)
  label(46,82,[DC],size:8.5)
  label(209,53,[L-BAL],size:8.8)
  label(300,75,[MZI],size:8.8)
  label(393,92,[TOPS],size:9.2)
  label(86,137,[TBS],size:11.5,fill:black)
  label(355,137,[PH.DEC],size:11.5,fill:black)
  // Seven serpentine delay cells. Each loop is continuous and squared.
  let pts=((279,61),(279,38),)
  for i in range(7) {
    let x=279 + i*32
    pts+=((x,37),(x + 22,37),(x + 26,40),(x + 26,56),(x + 21,57),(x + 12,57),(x + 9,54),(x + 9,48),(x + 13,45),(x + 20,45),(x + 20,42),(x + 6,42),(x + 5,46),(x + 5,59),(x + 10,61),(x + 28,61))
    if i<6 {pts+=((x + 32,61),(x + 32,38))}
  }
  pts+=((507,61),(507,66))
  wave(pts,t:1.7)
  wave(((279,66),(507,66)),t:1.3)
  for x in (277,312,377,503) {circle(P(x,62),radius:2.7,fill:rgb("#dcdcc8"),stroke:(paint:rgb("#85867b"),thickness:.5pt))}
  rect(P(373,31),P(505,71),stroke:(paint:rgb("#b6bcc5"),thickness:.65pt,dash:"dotted"),fill:none)
  line(P(373,31),P(393,17),stroke:(paint:rgb("#b6bcc5"),thickness:.65pt,dash:"dotted"))
  line(P(505,31),P(587,1),stroke:(paint:rgb("#b6bcc5"),thickness:.65pt,dash:"dotted"))
  label(463,9,[T-DEL],size:11.4,fill:black)
  label(582,29,[b],size:16,fill:black)
  // The three SPD ports leave the chip as independent waveguides.
  for (x,y) in ((579,66),(584,83),(590,100)) {
    circle(P(x + 5,y),radius:(7,7.3),fill:rgb("#171a17"),stroke:none)
    wave(((x + 10,y),(x + 25,y)),t:2,c:"#171a17")
  }
  label(585,137,[SPDs],size:11.5,fill:black)

})
