extends TextureButton

func _on_focus_entered() -> void:
	material.set_shader_parameter("invert", true)


func _on_mouse_entered() -> void:
	material.set_shader_parameter("invert", true)


func _on_mouse_exited() -> void:
	material.set_shader_parameter("invert", false)


func _on_focus_exited() -> void:
	material.set_shader_parameter("invert", false)
