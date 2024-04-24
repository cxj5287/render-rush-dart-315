extends CanvasLayer

func update_fuel(value):
	$FuelBar.value = value
func update_level_ui(value):
	$Level.text = str("Level: ", value)
	$Deadline.show()
	$Deadline.get_child(0).play("color_change")

func update_fps(fps):
	var fps_display = snapped(randf_range((fps-1.5), fps+.5), .01)
	$FPS.text = str("FPS:", fps_display)


func _on_animation_player_animation_finished(anim_name):
	$Deadline.hide()
