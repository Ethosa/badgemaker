# author: Ethosa
import badgemaker

var badge = newBadge(
  label="Open source", value="❤",
  label_color="#77dd77", value_color="#212121",
  label_text_color="#212121", value_text_color="#dd7777",
  style="plastic", width=100
)

badge.write "test11.svg"
