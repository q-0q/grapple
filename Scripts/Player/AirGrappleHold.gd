extends State

var enter_vel : Vector2

func _ready():
	
	flags = [
		"air"
	]
	
	# State transitions go here, in order of priority
	transition_list = [
		$"../AirGrappleFire",
		$".",
		$"../RisingStop",
		$"../FallingStart",
		$"../Run",
		$"../Idle"
	]

func on_enter():
	enter_vel = character().velocity
	character().get_node("AnimationPlayer").play("air_grapple_hold")
	
	
func on_process():
	if (get_global_mouse_position() - character().position).x > 0:
		set_flip_h.emit(false)
	else:
		set_flip_h.emit(true)


	character().velocity = character().velocity.lerp(Vector2.ZERO, 10 * get_process_delta_time())
	
func on_exit():
	pass
	#character().velocity = enter_vel
	
func condition():
	return Input.is_action_pressed("Grapple")

