extends Node3D
var buildings = [
	preload("res://buildings/building_1.tscn"),
	preload("res://buildings/building_2.tscn"),
	preload("res://buildings/building_3.tscn"),
	preload("res://buildings/building_4.tscn"),
	preload("res://buildings/building_5.tscn"),
]
var all_buildings = []
var ring = preload("res://ring.tscn")
var optimizer = preload("res://optimizer.tscn")
var level = 0
@onready var player = $"../Plane"

# Called when the node enters the scene tree for the first time.
func _ready():
	add_buildings()
	add_rings()
	add_optimizer()
	player.connect("growth_change", Callable(self, "_on_growth_change"))
	
	# Set new chunk visibility for buildings
	var percentage_complete = ((player.growth_level-1) / (player.max_growth_level - 1))
	var num_buildings_to_unhide = int(percentage_complete * all_buildings.size())
	if player.level == 1:
		if player.growth_level <= player.max_growth_level:
			for i in range(num_buildings_to_unhide):
				all_buildings[i].get_child(1).show()
	elif player.level == 2:
		for i in range(all_buildings.size()):
			all_buildings[i].get_child(1).show()
		for i in range(num_buildings_to_unhide):
			all_buildings[i].get_child(0).show()
			all_buildings[i].get_child(1).hide()
	elif player.level >= 3:
		for i in all_buildings.size():
			all_buildings[i].get_child(0).show()
		
	
	

func add_buildings():
	for side in [-1, 1]:
		var zpos = 10
		for i in 20:
			if randf() > 1:
				zpos -= randi_range(5, 10)
				continue
			var nb = buildings[randi_range(0,buildings.size()-1)].instantiate()
			add_child(nb)
			all_buildings.append(nb)
			nb.transform.origin.z = zpos
			nb.transform.origin.x = 25 * side
			var offset = nb.get_node("MeshInstance3D").mesh.get_aabb().size.z 
			zpos -= 10
			print(zpos)
			nb.get_child(0).hide()
			nb.get_child(1).hide()
			
			

func add_center_buildings():
	if level > 0:
		for z in range(0, -200, -20):
			if randf() > 0.8:
				var nb = buildings[0].instantiate()
				add_child(nb)
				nb.position.z = z
				nb.position.x += 8
				nb.rotation.y = PI / 2

func add_rings():
	for z in range(-20, -200, -10):
		if randf() > 0.85:
			var nr = ring.instantiate()
			nr.position.z = z
			nr.position.y = 3
			nr.position.x = randi_range(-10,10)
			add_child(nr)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func add_optimizer():
	var i = optimizer.instantiate()
	i.position.z = randi_range(-175, -200)
	i.position.y = 3
	i.position.x = randi_range(-10,10)
	add_child(i)

func _on_visible_on_screen_notifier_3d_screen_exited():
	queue_free()

func _on_growth_change():
	var percentage_complete = (player.growth_level-1) / (player.max_growth_level - 1)
	var num_buildings_to_unhide = int(percentage_complete * all_buildings.size())
	print(percentage_complete)
	if player.level == 1:
		for i in range(num_buildings_to_unhide):
			all_buildings[i].get_child(1).show()
	elif player.level == 2:
		for i in range(num_buildings_to_unhide):
			all_buildings[i].get_child(1).hide()
			all_buildings[i].get_child(0).show()
	

	
