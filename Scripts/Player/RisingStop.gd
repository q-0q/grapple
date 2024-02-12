extends State

@export var max_height : float
@export var time_to_max_height : float
@export var curve : Curve
@export var input_release_tightness : float

var init_y : float

var input_released : bool = false
var input_released_y_offset : float
var input_release_time_offset : float

func _ready():
	
	assert(max_height > 0)
	
	# State transitions go here, in order of priority
	transition_list = [
		$"../FallingStart",
	]

func on_enter():
	init_y = character().position.y
	input_released = false
	input_release_time_offset = 0
	input_released_y_offset = 0
	
func on_process():
	
	print(input_released)
	if Input.is_action_just_released("Jump") and !input_released:
		input_released = true
		input_release_time_offset = input_release_tightness
		input_released_y_offset = \
			get_y_from_time(time_in_current_state) - \
			get_y_from_time(time_in_current_state + input_release_time_offset)
	
	desired_position.y = \
		get_y_from_time(time_in_current_state + input_release_time_offset) + \
		input_released_y_offset
	
func on_exit():
	pass
	
func condition():
	return Input.is_action_pressed("Jump")


func get_y_from_time(time) -> float:
	var weight = curve.sample_baked(time / time_to_max_height)
	var jump_y = lerpf(0, max_height, weight)
	return init_y - jump_y
