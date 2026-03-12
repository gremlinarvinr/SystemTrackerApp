extends PanelContainer

@export var member_name:String # TODO: validate length
@export var member_color:Color 
@export var member_avatar:Texture2D
@export var pronouns:String # TODO: validate length
@export var member_short_desc:String # TODO: validate length

@export var fronting:bool

func _ready() -> void:
	%ColorBlock.color = member_color
	%NameLabel.text = member_name 
	%PronounsLabel.text = pronouns
	%ShortDescLabel.text = member_short_desc
	
func on_save_data(saved_members:Array[SavedMemberData], fronting_members:Array[SavedMemberData]):
	var my_data = SavedMemberData.new()
	my_data.member_name = member_name
	my_data.member_color = member_color
	my_data.pronouns = pronouns
	my_data.member_short_desc = member_short_desc
	my_data.fronting = fronting
	
	saved_members.append(my_data)
	
	# TODO: storing fronting members
	if fronting == true:
		fronting_members.append(my_data) 


func on_load_data(saved_data:SavedMemberData):
	member_color = saved_data.member_color
	%ColorBlock.color = member_color
	
	member_name = saved_data.member_name
	%NameLabel.text = member_name 
	
	pronouns = saved_data.pronouns
	%PronounsLabel.text = pronouns
	
	member_short_desc = saved_data.member_short_desc
	%ShortDescLabel.text = member_short_desc
	
	fronting = saved_data.fronting
	
	
