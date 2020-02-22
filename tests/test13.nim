# author: Ethosa
import badgemaker

var badge = newBadge(
  label="Open source", value="❤",
  label_color="#77dd77", value_color="#212121",
  label_text_color="#e0e0e0", value_text_color="#dd7777",
  style="plastic", width=100
)

badge.setShadow(label=true, value=false)
badge.offsetShadow 1, 1

badge.write "test13.svg"
