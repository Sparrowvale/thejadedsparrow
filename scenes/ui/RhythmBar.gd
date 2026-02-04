extends Control

signal hit_result(success: bool)

@export var speed: float = 300.0
@onready var cursor = $Cursor
@onready var target = $Target
@onready var background = $Background

var moving = false
var direction = 1

func _ready():
	# Start centered-ish
	cursor.position.x = 0

func start_check():
	moving = true
	cursor.position.x = 0
	visible = true

func _process(delta):
	if moving:
		cursor.position.x += speed * delta * direction
		
		# Bounce back? Or just loop? Let's bounce for now to keep it contained
		if cursor.position.x > background.size.x:
			direction = -1
		elif cursor.position.x < 0:
			direction = 1

			
func _input(event):
	if moving and event.is_action_pressed("ui_accept"): # Spacebar
		check_hit()

func check_hit():
	moving = false
	var dist = abs(cursor.position.x - target.position.x)
	# Target width is say 50, so half width is 25 tolerance
	var tolerance = target.size.x / 2.0
	
	if dist < tolerance:
		print("PERFECT HIT!")
		hit_result.emit(true)
	else:
		print("MISS!")
		hit_result.emit(false)
	
	await get_tree().create_timer(0.5).timeout
	visible = false
