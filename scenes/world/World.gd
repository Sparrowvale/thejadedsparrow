extends Node2D

func _ready():
	# Connect existing signals
	if $UI/Button:
		$UI/Button.pressed.connect(_on_test_battle_pressed)
	
	# Connect Terminal
	var terminal = get_node_or_null("SecurityTerminal")
	if terminal:
		terminal.hacking_started.connect(_on_terminal_hack_started)
		
	# Setup Hacking UI
	if $UI/RhythmBar:
		$UI/RhythmBar.hit_result.connect(_on_hack_result)
		$UI/RhythmBar.visible = false

func _on_test_battle_pressed():
	# ... (Keep existing battle logic)
	pass

# --- Hacking Logic ---
var active_terminal = null

func _on_terminal_hack_started():
	active_terminal = $SecurityTerminal
	print("World detected hack start")
	start_hacking_minigame()

func start_hacking_minigame():
	$UI/RhythmBar.visible = true
	$UI/RhythmBar.start_check() # Reuse the rhythm bar for hacking

func _on_hack_result(success):
	$UI/RhythmBar.visible = false
	if success:
		active_terminal.on_hack_success()
	else:
		active_terminal.on_hack_fail()
