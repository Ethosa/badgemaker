# author: Ethosa
import badgemaker

var badge = newBadge(label="helo blin", value="._.", style="plastic",
                     label_color="#212121", value_color="fuchsia",
                     label_text_color="#e0e0e0")

badge.write "test1.svg"
