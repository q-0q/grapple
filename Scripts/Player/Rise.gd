extends State

func _ready():
	
	# State transitions go here, in order of priority
	transition_list = [
		$".",
		$"../RisingStop",
		$"../Fall",
	]

func on_enter():
	pass
	
func on_process():
	pass
	
func on_exit():
	pass
	
func condition():
	return Input.is_action_just_pressed("Jump")

