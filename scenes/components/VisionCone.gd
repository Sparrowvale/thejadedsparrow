extends Node2D

signal player_spotted
signal player_lost

@export var view_distance: float = 300.0
@export var fov_angle: float = 60.0 # Degrees
@export var ray_count: int = 30

@onready var polygon = $Polygon2D

var rays = []

func _ready():
	# Generate rays
	var angle_step = fov_angle / (ray_count - 1)
	var start_angle = -fov_angle / 2.0
	
	for i in range(ray_count):
		var ray = RayCast2D.new()
		ray.target_position = Vector2.RIGHT.rotated(deg_to_rad(start_angle + (i * angle_step))) * view_distance
		ray.collision_mask = 1 | 2 # Player(1) + Walls(2) - Adjust masks as needed
		ray.collide_with_areas = true
		ray.collide_with_bodies = true
		add_child(ray)
		rays.append(ray)

func _physics_process(delta):
	var points = [Vector2.ZERO]
	var seeing_player = false
	
	for ray in rays:
		ray.force_raycast_update()
		if ray.is_colliding():
			points.append(ray.get_collision_point() - global_position)
			var collider = ray.get_collider()
			if collider and collider.name == "Player":
				seeing_player = true
		else:
			points.append(ray.target_position)
	
	# Draw the cone (optional visual)
	polygon.polygon = points
	
	if seeing_player:
		polygon.color = Color(1, 0, 0, 0.4) # Red if seen
		player_spotted.emit()
	else:
		polygon.color = Color(1, 1, 0, 0.2) # Yellow/Clear if safe
		player_lost.emit()
