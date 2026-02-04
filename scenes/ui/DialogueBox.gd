extends CanvasLayer

@onready var panel = $Panel
@onready var speaker_label = $Panel/SpeakerLabel
@onready var text_label = $Panel/TextLabel
@onready var choices_container = $Panel/ChoicesContainer

var current_dialogue_data = {}
var current_node_id = "start"

func _ready():
	panel.visible = false
	GameManager.dialogue_started.connect(_on_dialogue_started)

func _on_dialogue_started(path: String):
	# Load JSON
	var file = FileAccess.open(path, FileAccess.READ)
	if file:
		var json_text = file.get_as_text()
		var json = JSON.new()
		var parse_result = json.parse(json_text)
		if parse_result == OK:
			current_dialogue_data = json.data
			current_node_id = "start"
			show_node(current_node_id)
			panel.visible = true
		else:
			print("JSON Parse Error: ", json.get_error_message())

func show_node(id: String):
	if id == "end":
		panel.visible = false
		return

	if not current_dialogue_data.has(id):
		print("Node not found: ", id)
		return

	var node = current_dialogue_data[id]
	speaker_label.text = node.get("speaker", "Unknown")
	text_label.text = node.get("text", "...")
	
	# Clear old choices
	for child in choices_container.get_children():
		child.queue_free()
	
	# Create new choices
	for choice in node.get("choices", []):
		var btn = Button.new()
		btn.text = choice.get("text", "Continue")
		btn.pressed.connect(_on_choice_pressed.bind(choice.get("next", "end")))
		choices_container.add_child(btn)

func _on_choice_pressed(next_id):
	show_node(next_id)
