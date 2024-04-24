extends CanvasLayer

func update_fuel(value):
	$FuelBar.value = value
func update_level_ui(value):
	$Level.text = str("Level: ", value)

func update_fps(fps):
	var fps_display = snapped(randf_range((fps-1.5), fps+.5), .01)
	$FPS.text = str("FPS:", fps_display)
