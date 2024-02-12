extends State

func _ready():
	
	# State transitions go here, in order of priority
	transition_list = [
		$"../Run",
		$"../Rise",
	]

func on_enter():
	pass
	
func on_process():
	pass
	
func on_exit():
	pass
	
func condition():
	return character().is_on_floor()

