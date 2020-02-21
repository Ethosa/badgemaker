# author: Ethosa
import badgemaker

var badge = newBadge(label="Hello", value="world", style="plastic square",
                     label_color="#282A36", value_color="fuchsia",
                     label_text_color="#e0e0e0")

badge.write "test4.svg"
