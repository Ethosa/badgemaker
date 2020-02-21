# author: Ethosa
import badgemaker

var badge = newBadge(label="Hello", value="biggest world", style="plastic",
                     label_color="#282A36", value_color="#f1fa8c",
                     label_text_color="#e0e0e0", width=130)

badge.write "test2.svg"
