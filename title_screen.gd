extends Control

func _ready():
	$HighScore.text = "High Score: " + str(Global.high_score)


func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://main.tscn")
