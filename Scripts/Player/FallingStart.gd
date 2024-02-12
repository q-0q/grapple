extends State

@export var min_height : float
@export var time_to_min_height : float
@export var curve : Curve

var init_y : float

func _ready():
	assert(min_height < 0)
	
	# State transitions go here, in order of priority
	transition_list = [
		$"../Idle"
	]

func on_enter():
	init_y = character().position.y
	
func on_process():

	var weight = curve.sample_baked(time_in_current_state / time_to_min_height)
	var jump_y = lerpf(min_height, 0, weight)
	desired_position.y = init_y - jump_y
	
	if time_in_current_state >= time_to_min_height:
		transition_list.append($"../Fall")
	
func on_exit():
	transition_list.erase($"../Fall")
	
func condition():
	return !character().is_on_floor() and character().get_position_delta().y == 0

