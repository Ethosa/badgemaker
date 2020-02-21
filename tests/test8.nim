# author: Ethosa
import badgemaker

var badge = newBadge(
  label="Programming language:", value="Nim",
  label_color="#282A36", value_color="fuchsia",
  label_text_color="#e0e0e0", value_text_color="#333",
  width=256, height=32, style="plastic"
)

badge.setFontSize 14

badge.setIcon "C://Users/Admin/Desktop/nim.png"

badge.write "test8.svg"
