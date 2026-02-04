extends Node2D

@onready var rhythm_bar = $CanvasLayer/RhythmBar
@onready var log_label = $CanvasLayer/LogLabel
@onready var enemy_sprite = $EnemyPosition/Sprite2D

var player_hp = 100
var enemy_hp = 50
var turn = "PLAYER" # PLAYER, ENEMY

func _ready():
	rhythm_bar.visible = false
	rhythm_bar.hit_result.connect(_on_rhythm_result)
	combat_log("Battle Start! Encountered: Rogue Drone.")
	await get_tree().create_timer(1.0).timeout
	start_player_turn()

func combat_log(msg):
	log_label.text = msg

func start_player_turn():
	turn = "PLAYER"
	combat_log("Your Turn! Press 'Attack'...")
	$CanvasLayer/AttackButton.disabled = false
	$CanvasLayer/AttackButton.visible = true

func _on_attack_button_pressed():
	$CanvasLayer/AttackButton.disabled = true
	$CanvasLayer/AttackButton.visible = false
	combat_log("Focus... Press SPACE at the sweet spot!")
	rhythm_bar.start_check()

func _on_rhythm_result(success):
	if success:
		combat_log("CRITICAL HIT! Heavy damage!")
		enemy_sprite.modulate = Color(1, 0, 0) # Flash red
		await get_tree().create_timer(0.2).timeout
		enemy_sprite.modulate = Color(1, 1, 1)
		enemy_hp -= 20
	else:
		combat_log("MISS! You stumbled.")
		enemy_hp -= 0
		
	if enemy_hp <= 0:
		combat_log("Victory!")
		await get_tree().create_timer(2.0).timeout
		# Go back to world
		get_tree().change_scene_to_file("res://scenes/world/World.tscn")
	else:
		end_player_turn()

func end_player_turn():
	turn = "ENEMY"
	combat_log("Enemy is attacking...")
	await get_tree().create_timer(1.5).timeout
	player_hp -= 5
	combat_log("You took 5 damage.")
	start_player_turn()
