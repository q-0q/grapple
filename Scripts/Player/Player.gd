extends CharacterBody2D

func _process(delta):
	
	# Apply state from FSM
	position = $FSM.desired_position
	rotation_degrees = $FSM.desired_rotation_deg
	$Sprite2D.scale.x = -1 if $FSM.desired_flip_h else 1
	
	# Update FSM
	$FSM.update()
	
	# TODO: $AnimationPlayer.play($FSM.desired_animation)
	move_and_slide()
