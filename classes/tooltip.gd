class_name Tooltip
extends Node

# TY https://github.com/IndieQuest/Modular-tooltip/blob/master/Tooltip.gd FOR HELP
var padding = Vector2i(15, 15)
var offset = Vector2i(5, 5)
# FIXME: maybe offset diff vs left/right? ? ?  

var extents
var final_x:int
var final_y:int

# TODO: tooltip grab from settings font color/size
# TODO: tooltip wrap
var tooltip_wrap := 250

func _ready() -> void:
	get_node("Label").hide()
	
	
func _process(delta: float) -> void:
	# TODO: FIX POSITIONING
	if %Label.visible:
		if %Label.size.x > tooltip_wrap:
			await get_tree().process_frame
			%Label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
			%Label.size.x = tooltip_wrap
			
		extents = %Label.size
		var viewport_border = get_viewport().size - Vector2i(padding)
		var base_pos = %Label.get_global_mouse_position()
		
		#print("extents: " + str(extents) + "; mouse: " + str(base_pos))
		
		# FIXME: doesn't always flip? maybe cuz it doesnt'wrap idk 
		# test if needs to display to the left
		#print(viewport_border)
		#print("math: "+ str(base_pos.x + offset.x + extents.x))
		#print((base_pos.x + offset.x + extents.x) > viewport_border.x)
		if (base_pos.x + offset.x + extents.x) > viewport_border.x:
			final_x = base_pos.x - offset.x - extents.x
		else:
			final_x = base_pos.x - offset.x
		# test if needs to display above
		#final_y = base_pos.y - extents.y - offset.y
		#if final_y > viewport_border.y:
			#final_y = base_pos.y - offset.y
		#print("math y: "+ str(base_pos.y + offset.y + extents.y))
		#print((base_pos.y + offset.y + extents.y) > viewport_border.y)
		if (base_pos.y + offset.y + extents.y) > viewport_border.y:
			final_y = base_pos.y - offset.y - extents.y
		else:
			final_y = base_pos.y - offset.y
		%Label.position = Vector2i(final_x, final_y)


func set_tooltip(description):
	%Label.text = description


func _on_mouse_entered() -> void:
	%Timer.paused = false
	%Timer.start()


func _on_mouse_exited() -> void:
	%Label.hide()
	%Timer.paused = true


func _on_timer_timeout() -> void:
	%Label.show()
