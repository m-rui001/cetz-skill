#set page(width:auto,height:auto,margin:2pt)
#import "@preview/cetz:0.4.2":canvas,draw
#set text(font:"Arial",size:8pt)
#set par(leading:0pt)
#canvas(length:1pt,{
  import draw:*
  let s=2.1
  let P=(x,y)=>(s*x,s*(78 - y))
  let wire=(pts,c,t:1.1)=>line(..pts.map(p=>P(..p)),stroke:(paint:rgb(c),thickness:s*t*1pt))
  let curve=(a,b,c,d)=>bezier(P(..a),P(..b),P(..c),P(..d),stroke:(paint:rgb("#becd08"),thickness:s*1.2pt))
  let label=(x,y,c,size:5.4)=>content(P(x,y),text(size:s*size*1pt,c))
  // The map layer is excluded; coordinates retain the original optical overlay.
  curve((213,76),(168,40),(213,51),(193,40))
  curve((143,33),(122,20),(137,32),(135,15))
  curve((143,37),(122,56),(133,39),(135,56))
  wire(((122,20),(70,20)),"#becd08")
  wire(((122,56),(70,56)),"#becd08")
  for y in (20,56) {
    wire(((74,y),(123,y)),"#4b7099",t:2.6)
    wire(((74,y),(123,y)),"#9fb1cf",t:1)
    for x in (87,100,113) {
      circle(P(x,y - 8.2),radius:3.8*s,fill:rgb("#91a8c7"),stroke:(paint:rgb("#547595"),thickness:.8pt))
      circle(P(x,y - 8.2),radius:2.5*s,stroke:(paint:rgb("#b9c8dc"),thickness:.4pt))
    }
    rect(P(35,y - 5),P(74,y + 5),fill:rgb("#ae5c71"),stroke:(paint:rgb("#724556"),thickness:.55pt))
    content(P(54.5,y),text(size:s*5.5pt,fill:white,[PBS]))
    wire(((35,y),(14,y - 12)),"#ad5868",t:1)
    wire(((35,y),(14,y + 7)),"#479bae",t:1)
  }
  rect(P(141,30),P(179,40),fill:rgb("#ae5c71"),stroke:(paint:rgb("#724556"),thickness:.55pt))
  content(P(160,35),text(size:s*5.5pt,fill:white,[50:50 BS]))
  // Four detector cones, separate upper and lower PBS channels.
  for y in (8,27,44,63) {
    line(P(11,y - 4),P(2,y - 2),P(2,y + 2),P(11,y + 4),close:true,fill:rgb("#c9cdd2"),stroke:none)
    line(P(11,y - 4),P(14,y - 3),P(14,y + 3),P(11,y + 4),close:true,fill:rgb("#eeeeee"),stroke:none)
  }
  label(102,66,[Polarization],size:5.2)
  label(102,72,[controller],size:5.2)
  label(20,75,[SNSPDs],size:5.1)
  label(186,71,[From Alice],size:5.1)
})
