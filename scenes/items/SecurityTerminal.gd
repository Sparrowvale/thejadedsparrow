extends StaticBody2D

signal hacking_started
signal hacking_complete

@export var linked_guard_path: NodePath
var is_hacked = false

func _ready():
	$Interactable.interated.connect(_on_interact)

func _on_interact(_player):
	if is_hacked:
		print("Terminal already hacked.")
		return
		
	print("Starting Hack...")
	hacking_started.emit()
	
	# For prototype, we'll access the World UI directly or emit up
	# In a cleaner arch, the Game/LevelManager would handle this.
	# We'll assume the World.gd connects to this signal.

func on_hack_success():
	is_hacked = true
	$Sprite2D.modulate = Color.GREEN
	print("Hack Success! Disabling Guard...")
	if linked_guard_path:
		var guard = get_node_or_null(linked_guard_path)
		if guard:
			guard.set_process(false) 
			if guard.has_node("VisionCone"):
				guard.get_node("VisionCone").set_process(false)
			guard.get_node("Sprite2D").modulate = Color(0.2, 0.2, 0.2) # Dim the guard
	hacking_complete.emit()

func on_hack_fail():
	print("Hack Failed! Alarm?")
