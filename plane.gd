extends CharacterBody3D
signal dead
signal level_changed
signal fuel_changed
signal fps_changed

signal growth_change

@export var pitch_speed = 1.1
@export var roll_speed = 1.5
@export var level_speed = 4.0
@export var fuel_burn = .2
var max_fuel = 12
var fuel = 0: 
	set = set_fuel
var roll_input = 0
var pitch_input = 0
@export var forward_speed = 25
var max_altitude = 20
var max_growth_level = float(6);
var growth_level = float(1);
var max_fps = 60;

var level = 1;



func _ready():
	# Hide all parts of the character initially
	for child in $Elf.get_children():
		if child is MeshInstance3D:
			child.hide()
	
	$Elf.get_child(4).show()
	

func get_input(delta):
	#pitch_input = Input.get_axis("pitch_down", "pitch_up")
	#roll_input = Input.get_axis("roll_left", "roll_right")
	if position.y >= max_altitude and pitch_input > 0:
		position.y = max_altitude
		pitch_input = 0

func _physics_process(delta):
	get_input(delta)
	#rotation.x = lerpf(rotation.x, pitch_input, pitch_speed * delta)
	#rotation.x = clamp(rotation.x, deg_to_rad(-45), deg_to_rad(45))
	#$proto_char.rotation.z = lerpf($proto_char.rotation.z, roll_input, roll_speed * delta)
	velocity = -transform.basis.z * forward_speed
	#velocity += transform.basis.x * $proto_char.rotation.z / deg_to_rad(45) * forward_speed / 2.0
	if Input.is_action_pressed("move_right"):
		position.x+=.25
	if Input.is_action_pressed("move_left"):
		position.x-=.25
	
	
	move_and_slide()
	if get_slide_collision_count() > 0:
		die()
	#fuel -= fuel_burn * delta

func die():
	set_physics_process(false)
	$Elf.hide()
	$Explosion.show()
	$Explosion.play("default")
	await $Explosion.animation_finished
	$Explosion.hide()
	dead.emit()
	

func set_fuel(value):
	fuel = min(value, max_fuel)
	fuel_changed.emit(fuel)
	if fuel >= 12:
		emit_signal("fps_changed")
		max_fps -= 10
		if max_fps == 0:
			max_fps = 5
		Engine.set_max_fps(max_fps)
		print(Engine.get_max_fps())



func _on_area_3d_area_entered(area):
	if area.is_in_group("rings"):
		fuel += 2
		$Pickup.play()
		
	# Increment the growth level based on level
		if level == 1:
			growth_level += 1
			$Elf.get_node(str("P_0", growth_level)).show()
			
			if growth_level == 6:
				level+=1;
				update_level(level)
		elif level == 2:
			$Elf.get_node(str("P_0", growth_level)).hide()
			$Elf.get_child(0).get_child(0).get_node(str("0", growth_level)).show()
			growth_level+=1
			if growth_level == 7:
				level+=1;
				update_level(level)
		elif level == 3:
			var node = $Elf.get_child(0).get_child(0).get_node(str("0", growth_level))
			node.get_mesh().get("surface_0/material").albedo_texture_msdf = false
			growth_level+=1
			if growth_level == 7:
				level+=1
				update_level(level)
		elif level == 4:
			growth_level+=1
			if growth_level == 4:
				$Elf.get_child(0).get_child(0).show_rest_only = false
				$Elf.get_child(7).play("Running")
				$Elf.get_child(0).transform.origin.y = 0
			
	
		emit_signal("growth_change")
		
		
	if area.is_in_group("optimizer"):
		if fuel < 10:
			fuel+=2
			$Pickup.play()
		else:
			fuel = 0;
			max_fps = 60;
			Engine.set_max_fps(60)
			emit_signal("fps_changed")
			$PowerUp.play()

func update_level(level):
	forward_speed += 10
	growth_level = 1
	emit_signal("level_changed")
	$LevelUp.play()
	
	
	
	
