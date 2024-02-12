extends State

@export var fall_speed : float = 150
func _ready():
	
	# State transitions go here, in order of priority
	transition_list = [
		$"../Idle",
	]

func on_enter():
	pass
	
func on_process():
	desired_position = character().position + Vector2(0, get_process_delta_time() * fall_speed)
	
func on_exit():
	pass
	
func condition():
	return true

