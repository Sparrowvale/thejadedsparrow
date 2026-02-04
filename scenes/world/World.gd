extends Node2D

func _ready():
	$UI/TestBattleButton.pressed.connect(_on_test_battle_pressed)

func _on_test_battle_pressed():
	get_tree().change_scene_to_file("res://scenes/battle/Battle.tscn")
