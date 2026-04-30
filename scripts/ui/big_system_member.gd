extends VBoxContainer

enum CurrentPage {
	MAIN,
	EDIT_MAIN
}

var main_page_scene = preload("res://scenes/big_system_member/main_page.tscn")
var edit_main_page_scene = preload("res://scenes/big_system_member/edit_main_page.tscn")

var current_page:CurrentPage

var member_id: int
var member_name: String
var member_color:Color
var member_avatar:ImageTexture
var pronouns:String
var member_short_desc:String # TODO: edit somewhere
var member_long_desc:String
var fronting:bool # if member is set to switched in

# proposed changes to check if should save
var something_changed:bool
var new_member_avatar:ImageTexture
var new_member_color:Color
var new_member_long_desc:String

signal big_member_exit

func _ready() -> void:
	# get all the buttons
	var all_buttons = [TextureButton]
	all_buttons.append(%EditPage)
	all_buttons.append(%SaveBttn)
	all_buttons.append(%ExitBttn)
	all_buttons.append(%MainPageBttn)

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


func save_data():
	var saved_data:SavedData = SafeResourceLoader.load(GlobalVariables.main_save_path) as SavedData

	if saved_data == null:
		print("Saved data was unsafe!") # FIXME: better error handling
		return
	
	var all_members = saved_data.all_members
	var my_data = all_members[member_id]
	my_data.member_name = member_name
	my_data.pronouns = pronouns
	#my_data.member_avatar = member_avatar
	my_data.member_color = member_color
	my_data.member_long_desc = member_long_desc
	
	ResourceSaver.save(saved_data, GlobalVariables.main_save_path)


func load_data(new_id: int):
	member_id = new_id
	var saved_data:SavedData = SafeResourceLoader.load(GlobalVariables.main_save_path) as SavedData
	
	if saved_data == null:
		print("Saved data was unsafe!") # FIXME: better error handling
		return
	
	var all_members = saved_data.all_members
	var my_data = all_members[member_id]
	member_name = my_data.member_name
	pronouns = my_data.pronouns
	#member_avatar = my_data.member_avatar
	member_color = my_data.member_color
	member_long_desc = my_data.member_long_desc
	
	# TODO: move else where?
	%NameLabel.text = member_name
	%PronounsLabel.text = pronouns
	
	current_page = CurrentPage.MAIN
	set_up_main_page()


func clear_old_page():
	var old_page = %PageHolder.get_children()
	for child in old_page:
		child.queue_free()


func set_up_main_page():
	clear_old_page()
	var main_page = main_page_scene.instantiate()
	%PageHolder.add_child(main_page)
	main_page.set_avatar(member_avatar)
	main_page.set_color(member_color)
	main_page.set_main_desc(member_long_desc)


func set_up_edit_main_page():
	clear_old_page()
	var edit_main_page = edit_main_page_scene.instantiate()
	%PageHolder.add_child(edit_main_page)
	edit_main_page.update_color.connect(_on_update_color)
	edit_main_page.update_long_desc.connect(_on_update_long_desc)
	edit_main_page.update_avatar.connect(_on_update_avatar)
	edit_main_page.preset_color(member_color)
	edit_main_page.preset_main_desc(member_long_desc)


func _on_update_avatar(new_avatar:ImageTexture):
	something_changed = true
	new_member_avatar = new_avatar


func _on_update_color(new_color:Color):
	something_changed = true
	new_member_color = new_color


func _on_update_long_desc(new_long_desc:String):
	something_changed = true
	new_member_long_desc = new_long_desc


func _on_exit_bttn_pressed() -> void:
	big_member_exit.emit()


func _on_main_page_bttn_pressed() -> void:
	#current_page = CurrentPage.MAIN
	set_up_main_page()


func _on_edit_page_pressed() -> void:
	if current_page == CurrentPage.MAIN:
		current_page = CurrentPage.EDIT_MAIN
		set_up_edit_main_page()
	elif current_page == CurrentPage.EDIT_MAIN:
		if something_changed == true:
			%SavePromptHolder.show()
			%PageHolder.hide()
		else:
			%SavePromptHolder.hide()
			%PageHolder.show()
			current_page = CurrentPage.MAIN
			set_up_main_page()


func _on_save_prompt_pressed() -> void:
	# TODO: avatar
	if new_member_color != member_color:
		member_color = new_member_color
	if new_member_long_desc != member_long_desc:
		member_long_desc = new_member_long_desc
	#if new_member_avatar != member_avatar:
		#member_avatar = new_member_avatar
	something_changed = false
	save_data()
	_on_edit_page_pressed()
	

func _on_dont_save_prompt_pressed() -> void:
	something_changed = false
	_on_edit_page_pressed()
