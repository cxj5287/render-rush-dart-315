extends CanvasLayer

func update_fuel(value):
	$FuelBar.value = value
func update_level(value):
	$Level.text = str(value)
