extends MarginContainer

# TODO: better handling of this
signal added_member
signal exited_add_member

# default values
var member_name:String = "Member name"
var member_color:Color = Color.WHITE
var pronouns:String = "They/them"
var member_short_desc:String = "" 

func _ready() -> void:
	# get all the buttons
	var all_buttons = [TextureButton]
	all_buttons.append(%SaveNewMember)
	all_buttons.append(%AddNewMemberAvatar)
	all_buttons.append(%NewMemberColor)
	all_buttons.append(%ExitNewMember)
	
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


func _on_name_text_changed(new_text: String) -> void:
	member_name = new_text


func _on_pronouns_text_changed(new_text: String) -> void:
	pronouns = new_text


func _on_short_desc_text_changed(new_text: String) -> void:
	member_short_desc = new_text


func _on_save_new_member_pressed() -> void:
	# first grab current data
	var saved_data:SavedData = SafeResourceLoader.load(GlobalVariables.main_save_path) as SavedData
	# FIXME: handle if the saved data was unsafe
	if saved_data == null:
		print("Saved data was unsafe!") 
		return
	# create new data for this member
	var new_member = SavedMemberData.new()
	new_member.member_name = member_name
	new_member.pronouns = pronouns
	new_member.member_color = member_color
	new_member.member_short_desc = member_short_desc
	# add to member list
	saved_data.all_members.append(new_member)
	# save
	ResourceSaver.save(saved_data, GlobalVariables.main_save_path)
	# TODO: handle visibility better
	added_member.emit()
	


func _on_exit_new_member_pressed() -> void:
	exited_add_member.emit()
