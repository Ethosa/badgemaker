# author: Ethosa
# Command Line Interface for badgemaker.
import badgemaker
import parseopt
import strutils
import json


proc parseCommandLine*(args: seq[string]) =
  ## Parses command-line arguments and work with them.
  ##
  ## Command line arguments example:
  ##   yourfile --filename:CLI.svg --width:100
  ##
  ## ..code-block::Nim
  ##   import badgemaker/CLI
  ##   import os
  ##   parseCommandLine commandLineParams()
  let params = %*{
    "filename": %"CLI.svg",
    "width": %"120",
    "height": %"20",
    "label": %"",
    "value": %"",
    "label_color": %"#212121",
    "label_text_color": %"#e0e0e0",
    "value_color": %"#e0e0e0",
    "value_text_color": %"#212121",
    "image_path": %"",
    "image_color": %"",
    "font": %"DejaVu Sans,Verdana,Geneva,sans-serif",
    "font_size": %"12",
    "style": %"plastic"
  }
  var opts = initOptParser(args)

  # Parse arguments
  for kind, key, value in opts.getopt:
    case kind
    of cmdShortOption, cmdLongOption:
      if value != "":
        if params.hasKey(key):
          params[key] = %value
    else:
      continue

  # Create a new badge.
  var
    badge = newBadge(
      label=params["label"].getStr, value=params["value"].getStr,
      width=params["width"].getStr.parseInt, height=params["height"].getStr.parseInt,
      label_color=params["label_color"].getStr, label_text_color=params["label_text_color"].getStr,
      value_color=params["value_color"].getStr, value_text_color=params["value_text_color"].getStr,
      style=params["style"].getStr)
    name = params["filename"].getStr
  badge.setFont params["font"].getStr
  badge.setFontSize params["font_size"].getStr.parseInt
  badge.setIcon params["image_path"].getStr, params["image_color"].getStr

  if not name.endsWith(".svg"):
    name &= ".svg"
  badge.write name  # and write it in the file.
