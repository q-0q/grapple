extends State

@export var max_velocity : float
@export var time_to_max_velocity : float
@export var curve : Curve
@export var input_release_tightness : float
@export var horizontal_speed : float = 100


var input_released : bool = false
var input_release_time_offset : float = 100

func _ready():
	
	should_update_flip_h = true
	assert(max_velocity > 0)
	
	# State transitions go here, in order of priority
	transition_list = [
		$"../FallingStart",
	]

func on_enter():
	input_released = false
	input_release_time_offset = 0
	character().get_node("AnimationPlayer").play("rise1")
		
func on_process():
	
	if Input.is_action_just_released("Jump") and !input_released:
		input_released = true
		input_release_time_offset = input_release_tightness
	
	character().velocity.y = \
		-get_y_velocity_from_time(time_in_current_state + input_release_time_offset)
		
	character().velocity.x = \
		character().compute_air_x_vel(horizontal_speed)
	
	
	
func on_exit():
	pass
	
func condition():
	return Input.is_action_pressed("Jump")

func get_y_velocity_from_time(time) -> float:
	var weight = curve.sample_baked(time / time_to_max_velocity)
	var v = lerpf(0, max_velocity, weight)
	if weight < 0.3:
		character().get_node("AnimationPlayer").play("rise2")
	return v
