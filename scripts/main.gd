extends Node2D

var member_scene = preload("res://scenes/system_member.tscn")

func _enter_tree() -> void:
	# TODO: make sure mobile (if we ever do that,,) doesn't get wonky resolution !
	#if OS.get_name() == "Windows" || OS.get_name() == "macOS" || OS.get_name() == "Linux":
		#get_tree().root.min_size = Vector2i(720, 720) # TODO: idk if this is best practice? 
	get_tree().get_root().min_size = Vector2i(720, 720) # TODO: idk if this is best practice? 
	
	
func _ready() -> void:
	# TODO: idk if this window size is still needed
	#get_window().size_changed.connect(_on_window_size_changed)
	#_on_window_size_changed() # call initially to make sure labels are correct sizes
	
	load_data() # load first so user can't accidentally save 0 data
	#make_test_members() # make some test members

# TY GODOTNEERS for the base <3
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


func load_data():
	var saved_data:SavedData = SafeResourceLoader.load(GlobalVariables.main_save_path) as SavedData
	
	if saved_data == null:
		print("Saved data was unsafe!") # FIXME: better error handling
		return
		
	# TODO: anything that must be done before loading
	
	# TODO: maybe separate this somehow so that scene changes can be smoother,, purrhaps a dictionary?
	# load members
	for member in saved_data.all_members:
		var member_node = member_scene.instantiate() 
		%MembersVBox.add_child(member_node) # FIXME: members need to be added to right node
		if member_node.has_method("on_load_data"):
			print("loading member")
			member_node.on_load_data(member)


func make_test_members():
	var sys1 = member_scene.instantiate()
	sys1.member_name = "Quentin"
	sys1.pronouns = "he/they"
	sys1.member_color = Color.DARK_RED
	sys1.member_short_desc = "gamer boy with social anxiety"
	sys1.fronting = true
	%MembersVBox.add_child(sys1)
	
	var sys2 = member_scene.instantiate()
	sys2.member_name = "Aezi"
	sys2.pronouns = "they/he"
	sys2.member_color = Color.MEDIUM_PURPLE
	sys2.member_short_desc = "gamer nyanby with social anxiety"
	sys2.fronting = false
	%MembersVBox.add_child(sys2)
	
	var sys3 = member_scene.instantiate()
	sys3.member_name = "Katarina"
	sys3.pronouns = "she/her"
	sys3.member_color = Color.RED
	sys3.member_short_desc = "katatouille"
	sys3.fronting = false
	%MembersVBox.add_child(sys3)
	

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


# TODO: make MemberListUIVBox its own scene
func _on_member_list_button_pressed() -> void:
	$%MemberListUIVBox.visible = true
	
