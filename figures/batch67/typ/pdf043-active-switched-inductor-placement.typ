#set page(width:auto,height:auto,margin:2pt)
#set text(font:"Times New Roman",size:7.5pt)
#import "@preview/cetz:0.4.2":canvas,draw
#canvas(length:1pt,{
  import draw:*
  let P=(x,y)=>(x*.5,(480 - y)*.5)
  let wire=(pts)=>line(..pts.map(p=>P(..p)),stroke:.7pt)
  let lab=(x,y,c)=>content(P(x,y),c)
  let dot=(x,y)=>circle(P(x,y),radius:1,fill:black,stroke:none)
  let port=(x,y)=>circle(P(x,y),radius:1.35,fill:white,stroke:.7pt)
  let dh=(x,y)=>{
    wire(((x - 12,y),(x + 12,y)))
    line(P(x + 5,y),P(x - 5,y - 5),P(x - 5,y + 5),close:true,fill:black,stroke:none)
    wire(((x + 6,y - 6),(x + 6,y + 6)))
  }
  let dv=(x,y)=>{
    wire(((x,y - 12),(x,y + 12)))
    line(P(x,y - 5),P(x - 5,y + 5),P(x + 5,y + 5),close:true,fill:black,stroke:none)
    wire(((x - 6,y - 6),(x + 6,y - 6)))
  }
  let cap=(x,y,top,bot)=>{
    wire(((x,top),(x,y)));wire(((x - 8,y),(x + 8,y)))
    bezier(P(x - 8,y + 8),P(x + 8,y + 8),P(x - 7,y + 1),P(x + 7,y + 1),stroke:.7pt)
    wire(((x,y + 2.75),(x,bot)))
  }
  let coil=(x,y,n:4,gray:false)=>{
    let pitch=if gray {5} else {7}
    for i in range(n) {bezier(P(x + i*pitch,y),P(x + (i + 1)*pitch,y),P(x + i*pitch,y - 7),P(x + (i + 1)*pitch,y - 7),stroke:(paint:if gray {rgb("#999999")} else {black},thickness:.7pt))}
  }
  let winding=(x,y)=>{
    for i in range(4) {bezier(P(x,y + i*7),P(x,y + (i + 1)*7),P(x + 7,y + i*7),P(x + 7,y + (i + 1)*7),stroke:.7pt)}
  }
  let battery=(x,y,top,bot)=>{
    wire(((x,top),(x,y - 3)));wire(((x,y + 3),(x,bot)))
    wire(((x - 11,y - 3),(x + 11,y - 3)));wire(((x - 5,y + 3),(x + 5,y + 3)))
    lab(x - 22,y,[$V_"in"$])
  }
  let res=(x,y,top,bot)=>{
    wire(((x,top),(x,y - 10),(x + 4,y - 7),(x - 4,y - 3),(x + 4,y + 1),(x - 4,y + 5),(x + 4,y + 8),(x,y + 11),(x,bot)))
  }
  let block=(x,y,w,h,c)=>{
    rect(P(x,y),P(x + w,y + h),radius:2.5pt,fill:rgb("#dcedf0"),stroke:.7pt)
    content(P(x + w/2,y + h/2),text(size:10pt,c))
  }

  wire(((768,387),(809,387)));wire(((870,387),(955,387)))
  wire(((768,463),(809,463)));wire(((870,463),(955,463)))
  battery(768,424,387,463);dh(907,387);cap(927,424,387,463);res(955,425,387,463)
  block(809,377,61,94,[A-SL])
  for (x,y) in ((794,387),(794,463),(884,387),(884,463)) {port(x,y)}
  for (x,y) in ((927,387),(927,463)) {dot(x,y)}
  lab(794,399,[A]);lab(794,453,[B]);lab(884,399,[A′]);lab(884,453,[B′]);lab(907,374,[$D_o$]);content(P(910,427),text(size:6.5pt,[$C_o$]));content(P(943,427),text(size:6pt,[$R_o$]));lab(972,427,[$V_"out"$])
})
