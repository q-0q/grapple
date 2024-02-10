extends State

func _ready():
	
	# State transitions go here, in order of priority
	transition_list = [
		$"../Idle",
	]

func on_enter():
	pass
	
func on_process():
	print("Falling process")
	desired_position = character().position + Vector2(0, get_process_delta_time() * 100)
	
func on_exit():
	pass
	
func condition():
	return false

