extends State

func _ready():
	
	# State transitions go here, in order of priority
	transition_list = [
		$"../Run",
		$"../Rise",
		$"../FallingStart",
	]

func on_enter():
		character().get_node("AnimationPlayer").play("idle")
	
func on_process():
	character().velocity.x = character().compute_ground_x_vel(0)
	
func on_exit():
	pass
	
func condition():
	return character().is_on_floor()

