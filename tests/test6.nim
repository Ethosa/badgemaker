# author: Ethosa
import badgemaker

var badge = newBadge(label="Hello", value="world", style="flat square",
                     label_color="#282A36", value_color="fuchsia",
                     label_text_color="#e0e0e0")

badge.setIcon "C://Users/Admin/Desktop/nim.png"

badge.write "test6.svg"
