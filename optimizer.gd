extends Area3D

func _on_body_entered(body):
	$CollisionShape3D/MeshInstance3D.hide()
	
