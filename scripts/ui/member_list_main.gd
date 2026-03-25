extends MarginContainer
var member_scene = preload("res://scenes/system_member.tscn")
signal switch_to_big_member

func load_data(all_data:SavedData):
	#print("recieved load_members")
	var members_data = all_data.all_members
	var id = 0
	for member in members_data:
		var member_node = member_scene.instantiate() 
		%MembersVBox.add_child(member_node) # FIXME: members need to be added to right node
		print("loading member")
		member_node.on_load_data(member, id)
		member_node.see_big_member.connect(_on_see_big_member)
		id += 1


func _on_see_big_member(member_id: int):
	emit_signal("switch_to_big_member", member_id)
