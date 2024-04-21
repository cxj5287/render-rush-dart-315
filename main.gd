extends Node3D
var chunk = preload("res://chunk.tscn")
var num_chunks = 1
var chunk_size = 200
var max_position = -100
var title_screen = "res://title_screen.tscn"
var env


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	env = $WorldEnvironment.environment
	env.background_mode = 1
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $Plane.position.z  < max_position:
		num_chunks += 1
		var new_chunk = chunk.instantiate()
		new_chunk.position.z = max_position - chunk_size / 2
		new_chunk.level = num_chunks / 4
		add_child(new_chunk)
		max_position -= chunk_size
		env.background_mode = 2


func _on_plane_dead():
	get_tree().change_scene_to_file(title_screen)
