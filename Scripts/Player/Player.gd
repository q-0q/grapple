extends CharacterBody2D

func _physics_process(delta):
	position = $FSM.desired_position
	rotation_degrees = $FSM.desired_rotation_deg
	# AnimationPlayer . play (desired_animation)
	move_and_slide()
