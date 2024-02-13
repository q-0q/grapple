extends State

@export var horizontal_speed : float = 100

func _ready():
	should_update_flip_h = true
	# State transitions go here, in order of priority
	transition_list = [
		$".",
		$"../RisingStop",
		$"../FallingStart",
	]

func on_enter():
	character().get_node("AnimationPlayer").play("rise1")
	
func on_process():
	character().velocity.x = \
		character().compute_air_x_vel(horizontal_speed)
	
func on_exit():
	pass
	
func condition():
	return Input.is_action_just_pressed("Jump")

