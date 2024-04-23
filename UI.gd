extends CanvasLayer

func update_fuel(value):
	$FuelBar.value = value
func update_level_ui(value):
	$Level.text = str("Level: ", value)
