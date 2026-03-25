extends VBoxContainer

var member_id: int
var member_name: String

signal big_member_exit

func _ready() -> void:
	pass


func load_data(new_id: int):
	member_id = new_id
	var saved_data:SavedData = SafeResourceLoader.load(GlobalVariables.main_save_path) as SavedData
	
	if saved_data == null:
		print("Saved data was unsafe!") # FIXME: better error handling
		return
	
	var all_members = saved_data.all_members
	var my_data = all_members[member_id]
	member_name = my_data.member_name
	
	set_up()


func set_up():
	%NameLabel.text = member_name


func _on_exit_bttn_pressed() -> void:
	big_member_exit.emit()
