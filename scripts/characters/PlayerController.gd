extends CharacterBody2D

@export var speed: float = 300.0
@export var friction: float = 0.1

var target_position: Vector2

func _ready():
	target_position = global_position

func _input(event):
	if event.is_action_pressed("click_to_move"):
		# Try to interact first
		if InteractionManager.try_interact_at(get_global_mouse_position()):
			# If we interacted, don't move
			target_position = global_position
		else:
			target_position = get_global_mouse_position()

func _physics_process(delta):
	# Simple movement towards target
	if global_position.distance_to(target_position) > 10.0:
		var direction = (target_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()
	else:
		velocity = Vector2.ZERO
