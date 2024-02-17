extends State


var init_y_vel : float
@export var horizontal_speed : float = 100

func _ready():
	should_update_flip_h = true
	# State transitions go here, in order of priority
	transition_list = [
		$"../Run",
		$"../Idle",
		$"../AirGrappleHold"
	]
	
	flags = [
		"air"
	]

func on_enter():
	init_y_vel = character().velocity.y
	
func on_process():
	character().velocity.y = init_y_vel
	
	character().velocity.x = \
		character().compute_air_x_vel(horizontal_speed)
	
func on_exit():
	pass
	
func condition():
	return true

