extends Area2D
class_name Interactable

signal interated(body)

@export var dialogue_file: String = ""
@export var interact_label: String = "Talk"

func interact(player):
	print("Interacted with: ", name)
	# Emit signal so the game knows interaction happened
	interated.emit(player)
	
	if dialogue_file != "":
		# Tell Game/Dialogue Manager to start this dialogue
		# We will implement this connection shortly
		GameManager.start_dialogue(dialogue_file)
