extends Label

# TODO: is this even necessary, i think i fixed it with other means,, CXVBXCVB
enum LabelSize {
	HEADER1,
	HEADER2,
	HEADER3,
	HEADER4,
	NORMAL,
	SMALL
}

@export var label_size:LabelSize

func _on_label_resize(new_resolution:Enums.ViewportSizes) -> void:
	print(str(get_theme_font_size("font_size")))
	if label_size == LabelSize.HEADER1:
		header1_resize(new_resolution)
	print(get_theme_font_size("font_size"))

func header1_resize(new_resolution:int):
	if new_resolution == Enums.ViewportSizes.EXTRASMALL:
		add_theme_font_size_override("font_size", 24)
	elif new_resolution == Enums.ViewportSizes.SMALL:
		add_theme_font_size_override("font_size", 26)
	elif new_resolution == Enums.ViewportSizes.MEDIUM:
		add_theme_font_size_override("font_size", 28)
	elif new_resolution == Enums.ViewportSizes.LARGE:
		add_theme_font_size_override("font_size", 30)
	elif new_resolution == Enums.ViewportSizes.MEDIUM:
		add_theme_font_size_override("font_size", 32)

	
