# author: Ethosa
import badgemaker

var badge = newBadge(label="Hello", value="world", style="flat",
                     label_color="#282A36", value_color="#f1fa8c",
                     label_text_color="#e0e0e0")

badge.write "test3.svg"
