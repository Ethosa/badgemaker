# author: Ethosa
import streams
import xmltree
import strutils


type
  BadgeRef* = ref object
    style: string  ## egg "flat", "square" or "plastic"
    label: string  ## left text.
    value: string  ## right text.
    label_text_color: string  ## left text color
    value_text_color: string  ## right text color
    label_color: string  ## left color.
    value_color: string  ## right color.
    font: string
    width, height: int


proc newBadge*(label="", value="", style="flat", label_color="#212121",
               value_color="#e0e0e0", label_text_color="white",
               value_text_color="black", width=120, height=20): BadgeRef =
  BadgeRef(label: label, value: value, style: style,
           label_text_color: label_text_color, value_text_color: value_text_color,
           label_color: label_color, value_color: value_color,
           font: "DejaVu Sans,Verdana,Geneva,sans-serif",
           width: width, height: height)

proc setFont*(badge: BadgeRef, font: string) =
  badge.font = font

proc write*(badge: BadgeRef, filename: string) =
  var tree = newXMLTree(
    "svg", [], {
    "xmlns": "http://www.w3.org/2000/svg",
    "width": $badge.width,
    "height": $badge.height
  }.toXMLAttributes)

  var gradient = newXMLTree(
      "linearGradient", [],
      {"id": "gradient",
       "x2": "0", "y2": "100%"
      }.toXMLAttributes)
  gradient.add newXMLTree("stop", [], {
    "offset": "0", "stop-color": "#bbb",
    "stop-opacity": if "plastic" notin badge.style:
      "0"
    else:
      ".1"
    }.toXMLAttributes)
  gradient.add newXMLTree("stop", [], {
    "offset": "1",
    "stop-opacity": if "plastic" notin badge.style:
      "0"
    else:
      ".1"
    }.toXMLAttributes)

  var
    main = newXMLTree("g", [], {"mask": "url(#gradient)"}.toXMLAttributes)
    labelw = len(badge.label)*9 + len(badge.label)
    valuew = len(badge.value)*9 + len(badge.value)
    dif =
      if labelw > valuew:
        labelw - valuew
      else:
        labelw - 12
    radius = if "square" in badge.style: "0" else: "4"
  echo dif, " ", labelw, " ", valuew

  main.add newXMLTree(
    "rect", [], {
      "x": "0", "y": "0", "width": $labelw, "height": $badge.height,
      "rx": radius,
      "ry": radius,
      "style": "fill:" & badge.label_color
    }.toXMLAttributes
  )
  main.add newXMLTree(
    "rect", [], {
      "x": $dif, "y": "0",
      "width": $((badge.width - 6) - (dif)),
      "height": $badge.height,
      "rx": "0", "ry": "0", "style": "fill:" & badge.value_color
    }.toXMLAttributes
  )
  main.add newXMLTree(
    "rect", [], {
      "x": $(badge.width - 12), "y": "0",
      "width": "12", "height": $badge.height,
      "rx": radius,
      "ry": radius,
      "style": "fill:" & badge.value_color
    }.toXMLAttributes
  )
  main.add newXMLTree(
    "path", [], {
      "fill": "url(#gradient)",
       "d": "M0 0h" & $badge.width & "v" & $badge.height & "H0z"
    }.toXMLAttributes
  )

  var text = newXMLTree("g", [], {
    "font-family": badge.font, "font-size": "12", "fill": badge.label_color
    }.toXMLAttributes)

  text.add newXMLTree(
    "text", [], {
      "x": "2", "y": $(badge.height/2 + 5), "fill": badge.label_text_color
    }.toXMLAttributes
  )
  text[0].add newText badge.label

  text.add newXMLTree(
    "text", [], {
      "x": $(dif + 2),
      "y": $(badge.height/2 + 5), "fill": badge.value_text_color
    }.toXMLAttributes
  )
  text[1].add newText badge.value

  tree.add gradient
  tree.add main
  tree.add text
  
  var strm = newFileStream(filename, fmWrite)
  strm.write $tree
  strm.close
