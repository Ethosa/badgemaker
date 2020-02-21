# author: Ethosa
import badgemaker

var badge = newBadge(
  label="Programming language:", value="Nim",
  label_color="#282A36", value_color="fuchsia",
  label_text_color="#e0e0e0", value_text_color="#333",
  width=512, height=32, style="plastic"
)

badge.setFontSize 18

badge.setIcon "C://Users/Admin/Desktop/nim.png"

badge.write "test9.svg"
