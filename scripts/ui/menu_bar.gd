extends HBoxContainer

signal add_member_bttn_pressed
signal member_list_bttn_pressed

# TODO: remove SaveDataBttn; instead save after certain user actions
func _ready() -> void:
	# loop through all buttons to set up hovers
	for bttn in get_children():
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


func _on_add_member_button_pressed() -> void:
	add_member_bttn_pressed.emit()


func _on_member_list_button_pressed() -> void:
	member_list_bttn_pressed.emit()
