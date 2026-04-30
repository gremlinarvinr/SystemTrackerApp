extends VBoxContainer

var color_picker_scene = preload("res://scenes/color_picker.tscn")
signal update_color
signal update_avatar
signal update_long_desc

func _ready() -> void:
	# get all the buttons
	var all_buttons = [TextureButton]
	all_buttons.append(%EditAvatarBttn)
	
	# loop through all buttons to set up hovers
	for bttn in all_buttons:
		if bttn is TextureButton:
			bttn.material.set_shader_parameter("invert", true)
			bttn.focus_entered.connect(_on_focus_entered.bind(bttn))
			bttn.mouse_entered.connect(_on_focus_entered.bind(bttn))
			bttn.focus_exited.connect(_on_focus_exited.bind(bttn))
			bttn.mouse_exited.connect(_on_mouse_exited.bind(bttn))


func _on_focus_entered(bttn):
	bttn.material.set_shader_parameter("invert", false)

func _on_mouse_entered(bttn):
	bttn.material.set_shader_parameter("invert", false)
	
func _on_mouse_exited(bttn) -> void:
	bttn.material.set_shader_parameter("invert", true)

func _on_focus_exited(bttn) -> void:
	bttn.material.set_shader_parameter("invert", true)


func preset_color(current_color:Color):
	%ColorPicker.color = current_color
	update_color.emit(%ColorPicker.color) # HACK: otherwise the color picker saves as #000?


func preset_main_desc(current_desc:String):
	%EditDescription.text = current_desc
	update_long_desc.emit(%EditDescription.text) # HACK: otherwise it saves as blank??


func _on_color_picker_color_changed(color: Color) -> void:
	update_color.emit(color) 


func _on_edit_description_text_changed() -> void:
	var new_desc = %EditDescription.text
	update_long_desc.emit(new_desc)


func _on_edit_avatar_bttn_pressed() -> void:
	%EditAvatarBttn.hide()
	%AvatarFileDialog.show()


func _on_avatar_file_dialog_canceled() -> void:
	%EditAvatarBttn.show()
	%AvatarFileDialog.hide()


func _on_avatar_file_dialog_confirmed() -> void:
	%EditAvatarBttn.show()
	%AvatarFileDialog.hide()


func _on_avatar_file_dialog_file_selected(path: String) -> void:
	var img = Image.load_from_file(path)
	if img != null:
		var img_texture = ImageTexture.create_from_image(img)
		update_avatar.emit(img_texture)
	else:
		print("err: ", img) # TODO: better error handling
