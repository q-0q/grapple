extends State

@export var speed : float = 20

func _ready():
	
	# State transitions go here, in order of priority
	transition_list = [
		$"../Rise",
		$".",
		$"../Idle",
		$"../Fall",
	]

func on_enter():
	pass
	
func on_process():
	
	if Input.is_action_pressed("Left"):
		desired_position.x -= speed * get_process_delta_time()
		set_flip_h.emit(true)
	if Input.is_action_pressed("Right"):
		desired_position.x += speed * get_process_delta_time()
		set_flip_h.emit(false)
	
func on_exit():
	pass
	
func condition():
	# Left or Right but not both
	var l : bool = Input.is_action_pressed("Left")
	var r : bool = Input.is_action_pressed("Right")
	return (l or r) and !(l and r) and character().is_on_floor()

