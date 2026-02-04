extends Node

# Global State
var current_day: int = 1
var is_game_paused: bool = false

# Player State
var player_health: int = 100
var child_status: String = "calm" # calm, crying, asleep

signal dialogue_started(json_path)

func _ready():
	print("GameManager Initialized")

func start_dialogue(json_path: String):
	print("Starting Dialogue: ", json_path)
	dialogue_started.emit(json_path)

func toggle_pause():
	is_game_paused = !is_game_paused
	get_tree().paused = is_game_paused
