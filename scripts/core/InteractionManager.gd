extends Node

# This manager handles detecting clicks on interactables

func _unhandled_input(event):
	if event.is_action_pressed("click_to_move"):
		# In a real point & click, we'd check if we clicked an object override
		# For now, we'll let the PlayerController handle movement, 
		# but if we click an Interactable, we want to stop and interact.
		pass

# We will let the PlayerController call this
func try_interact_at(pos: Vector2):
	var space_state = get_tree().root.get_world_2d().direct_space_state
	var query = PhysicsPointQueryParameters2D.new()
	query.position = pos
	query.collide_with_areas = true
	query.collision_mask = 4 # Interactable layer
	
	var result = space_state.intersect_point(query)
	if result:
		for hit in result:
			if hit.collider is Interactable:
				hit.collider.interact(null)
				return true
	return false
