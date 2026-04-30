extends Node2D

var menu_bar_scene = preload("res://scenes/menu_bar.tscn")
var member_list_scene = preload("res://scenes/member_list_main.tscn")
var add_member_scene = preload("res://scenes/add_member.tscn")
var big_system_member_scene = preload("res://scenes/big_system_member/big_system_member.tscn")

func _enter_tree() -> void:
	# TODO: make sure mobile (if we ever do that,,) doesn't get wonky resolution !
	#if OS.get_name() == "Windows" || OS.get_name() == "macOS" || OS.get_name() == "Linux":
		#get_tree().root.min_size = Vector2i(720, 720) # TODO: idk if this is best practice? 
	get_tree().get_root().min_size = Vector2i(600, 600) # TODO: idk if this is best practice? 


func _ready() -> void:
	# TODO: idk if this window size is still needed
	#get_window().size_changed.connect(_on_window_size_changed)
	#_on_window_size_changed() # call initially to make sure labels are correct sizes
	
	# load menu bar and connect buttons, load member list and data
	switch_to_member_list()


func get_menu():
	var menu_bar = menu_bar_scene.instantiate()
	%MainVBox.add_child(menu_bar)
	menu_bar.connect("add_member_bttn_pressed", _on_add_member_button_pressed)
	menu_bar.connect("member_list_bttn_pressed", _on_member_list_button_pressed)


func switch_to_member_list():
	for child in $%MainVBox.get_children():
			child.queue_free()
	get_menu()
	var member_list = member_list_scene.instantiate()
	%MainVBox.add_child(member_list)
	member_list.switch_to_big_member.connect(_on_load_big_member)
	load_data() # load everything


# TODO: save whenever something is created/edited

# TY GODOTNEERS for the base <3
# OLDGE ,, TODO: delete this once a better thing is added, ,,  , ,
func save_all():
	# first create what will hold all the saved data
	var saved_data:SavedData = SavedData.new() 
	
	# then call each type of thing to be saved, and put it in the approrpiate slot within saved_data
	# start with members
	# if member is set to fronting, also save them in the fronting var
	var fronting_members:Array[SavedMemberData] = [] # TODO: custom fronts
	var saved_members:Array[SavedMemberData] = []
	get_tree().call_group("system_members", "on_save_data", saved_members, fronting_members)
	
	saved_data.current_fronters = fronting_members
	saved_data.all_members = saved_members
	
	ResourceSaver.save(saved_data, GlobalVariables.main_save_path)


# TY GODOTNEERS FOR THE BASE
func load_data():
	var saved_data:SavedData = SafeResourceLoader.load(GlobalVariables.main_save_path) as SavedData
	
	if saved_data == null:
		print("Saved data was unsafe!") # FIXME: better error handling
		return
		
	# TODO: anything that must be done before loading
	
	# TODO: check what to load rn
	# load all the members in the member list
	get_tree().call_group("loadables", "load_data", saved_data)


# TODO: necessary? fixed font thing elsewhere
func _on_window_size_changed():
	# grab new size
	var new_window_size = get_viewport().get_visible_rect().size # Vector2
	if new_window_size.x < 600:
		get_tree().call_group("labels", "_on_label_resize", Enums.ViewportSizes.EXTRASMALL) # smallest resolution
	elif new_window_size.x >= 600:
		get_tree().call_group("labels", "_on_label_resize", Enums.ViewportSizes.SMALL) # small resolution
	elif new_window_size.x >= 768:
		get_tree().call_group("labels", "_on_label_resize", Enums.ViewportSizes.MEDIUM) # small resolution
	elif new_window_size.x >= 992:
		get_tree().call_group("labels", "_on_label_resize", Enums.ViewportSizes.LARGE) # small resolution
	elif new_window_size.x >= 1200:
		get_tree().call_group("labels", "_on_label_resize", Enums.ViewportSizes.EXTRALARGE) # small resolution
	else:
		print("error with resolution detection")
	print(str(new_window_size))


func _on_member_list_button_pressed() -> void:
	switch_to_member_list()


func _on_add_member_button_pressed() -> void:
	for child in $%MainVBox.get_children():
			child.queue_free()
	var add_member = add_member_scene.instantiate()
	add_member.added_member.connect(_on_added_member)
	add_member.exited_add_member.connect(_on_exit_add_member)
	%MainVBox.add_child(add_member)


func _on_added_member() -> void:
	switch_to_member_list()


func _on_exit_add_member() -> void:
	switch_to_member_list()


func _on_load_big_member(member_id: int):
	for child in $%MainVBox.get_children():
		child.queue_free()
	var big_member = big_system_member_scene.instantiate()
	big_member.connect("big_member_exit", _on_big_member_exit)
	%MainVBox.add_child(big_member)
	big_member.load_data(member_id)


func _on_big_member_exit():
	switch_to_member_list()
