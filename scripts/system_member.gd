extends Node
@export var member_name:String
@export var fronting:bool

func _ready() -> void:
	pass
	
	
func on_save_data(saved_members:Array[SavedMemberData], fronting_members:Array[SavedMemberData]):
	var my_data = SavedMemberData.new()
	my_data.member_name = member_name
	my_data.fronting = fronting
	
	saved_members.append(my_data)
	
	if fronting == true:
		fronting_members.append(my_data)


func on_load_data(saved_data:SavedMemberData):
	member_name = saved_data.member_name
	fronting = saved_data.fronting
