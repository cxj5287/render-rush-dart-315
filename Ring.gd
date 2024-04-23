extends Area3D

var move_x = false
var move_y = false
var move_amount = 2.5
var move_speed = 2.0

signal passed_through_ring

# Called when the node enters the scene tree for the first time.
func _ready():
	var tween = create_tween().set_loops().set_trans(Tween.TRANS_SINE)
	tween.stop()
	if move_y:
		tween.tween_property($CollisionShape3D,"position:y", -move_amount, move_speed)
		tween.tween_property($CollisionShape3D,"position:y", move_amount, move_speed)
		tween.play()
	if move_x:
		tween.tween_property($CollisionShape3D,"position:x", -move_amount, move_speed)
		tween.tween_property($CollisionShape3D,"position:x", move_amount, move_speed)
		tween.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$CollisionShape3D/MeshInstance3D.rotate_y(deg_to_rad(50) * delta)


func _on_body_entered(body):
	$CollisionShape3D/MeshInstance3D.hide()
	var d = global_position.distance_to(body.global_position)

	
