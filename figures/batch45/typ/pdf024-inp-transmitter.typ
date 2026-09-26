#set page(width:auto,height:auto,margin:2pt)
#import "@preview/cetz:0.4.2":canvas,draw
#set text(font:"Arial",size:9pt)
#set par(leading:0pt)
#canvas(length:1pt,{
  import draw:*
  let s=1.6
  let P=(x,y)=>(s*x,s*(110 - y))
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

  poly(((29,25),(359,25),(359,81),(7,81)),"#655277")
  poly(((7,81),(359,81),(359,88),(13,89)),"#211d35")
  poly(((13,80),(359,80),(359,84),(9,84)),"#4c3c68")
  wave(((23,32),(54,32)))
  mz(54,128,36,r:4.3)
  wave(((128,36),(136,36)))
  mz(136,247,36,r:4.3)
  wave(((247,36),(257,36)))
  mz(257,324,36,r:4.3)
  wave(((324,36),(330,32),(359,32)))
  for (x,w) in ((84,28),(169,39),(278,24)) {
    box(x,28,w,4,"#8c8291")
    box(x,41,w,3,"#7c708e")
    for xx in (x - 2,x + w - 2) {box(xx,27,5,4,"#a29aa6")}
  }
  label(94,12,[P.MOD],size:11,fill:black)
  label(194,12,[PH.RAND],size:11,fill:black)
  label(291,12,[I.M],size:11,fill:black)
  label(4,10,[a],size:16,fill:black)
  // Integrated laser feeds the pulse-modulator chain.
  curve((57,36),(40,51),(38,36),(46,46))
  wave(((40,51),(51,53),(130,53)),t:1.3)
  for (x,w) in ((54,20),(78,23),(120,7)) {heater(x,52,w,9)}
  wave(((48,65),(132,65),(132,53)))
  rect(P(46,49),P(143,69),stroke:(paint:rgb("#ececf0"),thickness:.7pt,dash:"dotted"),fill:none)
  label(160,50,[PD],size:7.7)
  label(191,42,[EOPM],size:7.7)
  label(309,47,[MMI],size:6.2)
  curve((330,42),(327,51),(344,42),(344,51))
  wave(((327,51),(239,51)))
  curve((239,51),(238,60),(222,51),(222,60))
  mz(239,316,65,r:4.5)
  wave(((7,70),(239,70)))
  wave(((316,65),(326,60),(359,60)))
  wave(((316,65),(326,69),(359,69)))
  box(265,56,29,3,"#9a8d9c")
  box(265,71,29,3,"#9a8d9c")
  rect(P(233,51),P(330,78),stroke:(paint:rgb("#ececf0"),thickness:.7pt,dash:"dotted"),fill:none)
  label(89,102,[LASER],size:11,fill:black)
  label(311,102,[PH.ENC],size:11,fill:black)
  line(P(46,69),P(3,110),stroke:(paint:rgb("#b1b1b1"),thickness:.5pt,dash:"dotted"))
  line(P(143,69),P(203,110),stroke:(paint:rgb("#b1b1b1"),thickness:.5pt,dash:"dotted"))
  line(P(233,78),P(289,110),stroke:(paint:rgb("#b1b1b1"),thickness:.5pt,dash:"dotted"))
  line(P(330,78),P(365,99),stroke:(paint:rgb("#b1b1b1"),thickness:.5pt,dash:"dotted"))

})
