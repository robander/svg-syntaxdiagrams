// text

syntaxdiagram_Dispatch["text"] = new Array;
syntaxdiagram_Dispatch["text"]["init"] = syntaxdiagram_text_init;
syntaxdiagram_Dispatch["text"]["place"] = syntaxdiagram_text_place;
syntaxdiagram_Dispatch["text"]["getHeightAbove"] = syntaxdiagram_text_getHeightAbove;
syntaxdiagram_Dispatch["text"]["getHeightBelow"] = syntaxdiagram_text_getHeightBelow;
syntaxdiagram_Dispatch["text"]["getWidth"] = syntaxdiagram_text_getWidth;

function syntaxdiagram_text_init(g)
{
  // To do: handle more than just first child.
  var t = syntaxdiagram_getDispatchableChildren(g, "text", null)[0];
  
  g.setAttribute("transform", "translate(0," + syntaxdiagram_Constants.text_baseline_shift + ")");
  //t.setAttribute("font-family", syntaxdiagram_Constants.font_face);
  //t.setAttribute("font-size", syntaxdiagram_Constants.font_size);
  
  if (t.hasChildNodes() && t.getBBox() != null)
  {
    //Original purpose for @textLength: tell this text how long it was, in case it is being rendered later with a different renderer.
    //Caused problems for some strings; resulted in squashed text for short strings with leading spaces or punctuation.
    //Does not appear necessary for recent HTML or PDF support.
    //syntaxdiagram2svg:width is still needed to set box width and calculate space to leave between lines.
    if (t.getAttributeNS("http://www.moldflow.com/namespace/2008/syntaxdiagram2svg", "extendwidth") != '') {
        //Lead space and a few other leading characters cause slightly squashed text, allow a bit extra width.
        //t.setAttribute("textLength", (4 + t.getBBox().width));
        g.setAttributeNS("http://www.moldflow.com/namespace/2008/syntaxdiagram2svg", "syntaxdiagram2svg:width", (Number(t.getAttributeNS("http://www.moldflow.com/namespace/2008/syntaxdiagram2svg", "extendwidth")) + (t.getBBox().width * syntaxdiagram_Constants.text_expansion_multiplier)));
    } else {
        //t.setAttribute("textLength", t.getBBox().width);
        g.setAttributeNS("http://www.moldflow.com/namespace/2008/syntaxdiagram2svg", "syntaxdiagram2svg:width", (t.getBBox().width * syntaxdiagram_Constants.text_expansion_multiplier));
    }
    g.setAttributeNS("http://www.moldflow.com/namespace/2008/syntaxdiagram2svg", "syntaxdiagram2svg:heightAbove", 0 - (t.getBBox().y) - syntaxdiagram_Constants.text_baseline_shift);
    g.setAttributeNS("http://www.moldflow.com/namespace/2008/syntaxdiagram2svg", "syntaxdiagram2svg:heightBelow", (t.getBBox().height + (t.getBBox().y - 0) + syntaxdiagram_Constants.text_baseline_shift));
  }
  else
  {
    g.setAttributeNS("http://www.moldflow.com/namespace/2008/syntaxdiagram2svg", "syntaxdiagram2svg:width", 4.9);
    g.setAttributeNS("http://www.moldflow.com/namespace/2008/syntaxdiagram2svg", "syntaxdiagram2svg:heightAbove", 2.5);
    g.setAttributeNS("http://www.moldflow.com/namespace/2008/syntaxdiagram2svg", "syntaxdiagram2svg:heightBelow", 3);
  }
}

function syntaxdiagram_text_place(g, x, y)
{
  g.setAttribute("transform",
                 "translate(" + x + "," + (y + (syntaxdiagram_Constants.text_baseline_shift - 0))+ ")");
}

function syntaxdiagram_text_getHeightAbove(g)
{
  return g.getAttributeNS("http://www.moldflow.com/namespace/2008/syntaxdiagram2svg", "heightAbove") - 0;
}

function syntaxdiagram_text_getHeightBelow(g)
{
  return g.getAttributeNS("http://www.moldflow.com/namespace/2008/syntaxdiagram2svg", "heightBelow") - 0;
}

function syntaxdiagram_text_getWidth(g)
{
  return g.getAttributeNS("http://www.moldflow.com/namespace/2008/syntaxdiagram2svg", "width") - 0;
}
