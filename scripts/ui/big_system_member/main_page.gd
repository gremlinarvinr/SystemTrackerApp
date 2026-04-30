extends VBoxContainer

func _ready() -> void:
	pass
	# get all the buttons
	#var all_buttons = [TextureButton]
	#all_buttons.append(%EditColor)
	#all_buttons.append(%EditAvatarBttn)
	#
	## loop through all buttons to set up hovers
	#for bttn in all_buttons:
		#if bttn is TextureButton:
			#bttn.material.set_shader_parameter("invert", true)
			#bttn.focus_entered.connect(_on_focus_entered.bind(bttn))
			#bttn.mouse_entered.connect(_on_focus_entered.bind(bttn))
			#bttn.focus_exited.connect(_on_focus_exited.bind(bttn))
			#bttn.mouse_exited.connect(_on_mouse_exited.bind(bttn))


func _on_focus_entered(bttn):
	bttn.material.set_shader_parameter("invert", false)

func _on_mouse_entered(bttn):
	bttn.material.set_shader_parameter("invert", false)
	
func _on_mouse_exited(bttn) -> void:
	bttn.material.set_shader_parameter("invert", true)

func _on_focus_exited(bttn) -> void:
	bttn.material.set_shader_parameter("invert", true)


func set_color(new_color:Color):
	%ColorBlockB.color = new_color
	%ColorBlockL.color = new_color
	%ColorBlockR.color = new_color
	%ColorBlockT.color = new_color


func set_avatar(new_avatar:ImageTexture):
	if new_avatar != null:
		%Avatar.texture = new_avatar


func set_main_desc(new_desc:String):
	%Description.text = new_desc
