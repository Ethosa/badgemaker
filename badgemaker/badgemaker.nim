# author: Ethosa
import streams
import xmltree
import strutils
import strtabs
import base64


type
  BadgeRef* = ref object
    style: string  ## egg "flat", "square", "plastic" etc.
    label: string  ## left text.
    value: string  ## right text.
    label_text_color: string  ## left text color
    value_text_color: string  ## right text color
    label_color: string  ## left color.
    value_color: string  ## right color.
    font: string  ## label and value font.
    font_size: int
    width, height: int
    image_path: string  ## image path for icon.
    image_color: string  ## image fill color.
    label_shadow, value_shadow: bool
    dx, dy: int


proc newBadge*(label="", value="", style="flat", label_color="#212121",
               value_color="#e0e0e0", label_text_color="white",
               value_text_color="black", width=120, height=20): BadgeRef =
  ## Creates a new Badge object.
  BadgeRef(label: label, value: value, style: style,
           label_text_color: label_text_color, value_text_color: value_text_color,
           label_color: label_color, value_color: value_color,
           font: "DejaVu Sans,Verdana,Geneva,sans-serif",
           width: width, height: height, image_path: "", image_color: "",
           font_size: 12, label_shadow: false, value_shadow: false, dx: 0, dy: 0)

proc setFont*(badge: BadgeRef, font: string) {.inline.} =
  ## Sets badge font.
  badge.font = font

proc setFontSize*(badge: BadgeRef, size: int) {.inline.} =
  ## Sets badge font size.
  badge.font_size = size

proc setIcon*(badge: BadgeRef, image_path: string) {.inline.} =
  ## Sets icon for badge.
  badge.image_path = image_path

proc setIcon*(badge: BadgeRef, image_path, color: string) {.inline.} =
  ## Sets icon with fill color.
  badge.image_path = image_path
  badge.image_color = color

proc setShadow*(badge: BadgeRef, label=false, value=false) {.inline.} =
  ## Change text drop shadow.
  badge.label_shadow = label
  badge.value_shadow = value

proc offsetShadow*(badge: BadgeRef, dx, dy: int) {.inline.} =
  ## Change drop shadow offset.
  badge.dx = dx
  badge.dy = dy

proc `$`*(badge: BadgeRef): string =
  let
    # start variables
    image_width = if badge.image_path != "": badge.height else: 0
    labell = len(badge.label)
    valuel = len(badge.value)
    bfsize = (badge.font_size - 3).int
    bfsize1 = (badge.font_size/2).int
    labelw = labell*bfsize + labell + image_width
    valuew = valuel*bfsize + valuel + image_width
    radius = if "square" in badge.style: "0" else: "4"
    dif =
      if labelw > valuew:
        labelw - valuew + radius.parseInt
      else:
        labelw - badge.font_size + radius.parseInt
    stop_opacity = if "plastic" notin badge.style: "0" else: ".1"

  # Drop shadow effect.
  var shadow = newXMLTree("defs", [], newStringTable(modeCaseSensitive))
  shadow.add newXMLTree(
    "filter", [], {
    "id": "drop_shadow", "x": "0", "y": "0", "width": "200%", "height": "200%"
    }.toXMLAttributes)
  shadow[0].add newXMLTree(
    "feOffset", [], {
      "result": "offOut", "in": "SourceAlpha", "dx": $badge.dx, "dy": $badge.dy
    }.toXMLAttributes)
  shadow[0].add newXMLTree(
    "feGaussianBlur", [], {
      "result": "blurOut", "in": "offOut", "stdDeviation": "1"
    }.toXMLAttributes)
  shadow[0].add newXMLTree(
    "feBlend", [], {
      "in": "SourceGraphic", "in2": "blurOut", "mode": "normal"
    }.toXMLAttributes)

  var
    # trees
    tree = newXMLTree(
      "svg", [], {
      "xmlns": "http://www.w3.org/2000/svg",
      "xmlns:xlink": "http://www.w3.org/1999/xlink",
      "width": $badge.width, "height": $badge.height
    }.toXMLAttributes)
    main = newXMLTree("g", [], {"mask": "url(#gradient)"}.toXMLAttributes)
    text = newXMLTree("g", [], {
      "font-family": badge.font, "font-size": $badge.font_size, "fill": badge.label_color
      }.toXMLAttributes)
    gradient = newXMLTree(
      "linearGradient", [],
      {"id": "gradient", "x2": "0", "y2": "100%"}.toXMLAttributes)

  gradient.add newXMLTree("stop", [], {
    "offset": "0", "stop-color": "#bbb", "stop-opacity": stop_opacity
    }.toXMLAttributes)
  gradient.add newXMLTree("stop", [], {
    "offset": "1", "stop-opacity": stop_opacity
    }.toXMLAttributes)

  main.add newXMLTree(
    "rect", [], {
      "x": "0", "y": "0", "width": $(labelw),
      "height": $badge.height, "rx": radius, "ry": radius,
      "style": "fill:" & badge.label_color
    }.toXMLAttributes)
  main.add newXMLTree(
    "rect", [], {
      "x": $dif, "y": "0",
      "width": $((badge.width - bfsize1) - dif),
      "height": $badge.height,
      "rx": "0", "ry": "0", "style": "fill:" & badge.value_color
    }.toXMLAttributes)
  main.add newXMLTree(
    "rect", [], {
      "x": $(badge.width - badge.font_size), "y": "0",
      "width": $badge.font_size, "height": $badge.height,
      "rx": radius, "ry": radius,
      "style": "fill:" & badge.value_color
    }.toXMLAttributes)
  main.add newXMLTree(
    "path", [], {
      "fill": "url(#gradient)",
       "d": "M0 0h" & $badge.width & "v" & $badge.height & "H0z"
    }.toXMLAttributes)

  text.add newXMLTree(
    "text", [], {
      "x": $(image_width + 2 + parseInt(radius)),
      "y": $(badge.height/2 + (badge.font_size/2) - 1.0), "fill": badge.label_text_color,
      "filter": if badge.label_shadow: "url(#drop_shadow)" else: ""
    }.toXMLAttributes)
  text.add newXMLTree(
    "text", [], {
      "x": $(dif + 2),
      "y": $(badge.height/2 + (badge.font_size/2) - 1.0), "fill": badge.value_text_color,
      "filter": if badge.value_shadow: "url(#drop_shadow)" else: ""
    }.toXMLAttributes)

  text[0].add newText badge.label
  text[1].add newText badge.value

  tree.add gradient
  tree.add shadow
  tree.add main
  tree.add text
  if badge.image_path != "":
    var
      img = newFileStream(badge.image_path, fmRead)
      image = img.readAll
    img.close
    tree.add newXMLTree(
      "image", [], {
        "xlink:href": "data:image/png;base64," & encode image,
        "width": $badge.height, "height": $badge.height,
        "x": radius, "y": "0", "fill": badge.image_color
      }.toXMLAttributes)
  return $tree

proc write*(badge: BadgeRef, filename: string) =
  ## Writes SVG image in file.
  var strm = newFileStream(filename, fmWrite)
  strm.write $badge
  strm.close
