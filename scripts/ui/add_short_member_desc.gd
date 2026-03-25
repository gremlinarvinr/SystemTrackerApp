extends TextEdit

var max_chars = 120
var old_text = ""

func _on_text_changed():
	if text.length() > max_chars:
		text = old_text
		set_caret_line(get_line_count())
		set_caret_column(0)
	else:
		old_text = text
