extends State

@export var min_velocity : float
@export var time_to_min_velocity : float
@export var curve : Curve

var init_y : float
@export var horizontal_speed : float = 200

func _ready():
	assert(min_velocity < 0)
	should_update_flip_h = true
	# State transitions go here, in order of priority
	transition_list = [
		$"../Idle"
	]

func on_enter():
	init_y = character().position.y
	character().get_node("AnimationPlayer").play("fall1")
	
	
func on_process():

	var weight = curve.sample_baked(time_in_current_state / time_to_min_velocity)
	var fall_velocity = -lerpf(0, min_velocity, weight)
	
	print(weight)
	if weight > 0.7:
		character().get_node("AnimationPlayer").play("fall2")
		
	character().velocity.y = fall_velocity
	character().velocity.x = \
		character().compute_air_x_vel(horizontal_speed)
	
	if time_in_current_state >= time_to_min_velocity:
		transition_list.append($"../Fall")
	
func on_exit():
	transition_list.erase($"../Fall")
	
func condition():
	return !character().is_on_floor() and \
	(character().get_position_delta().y == 0 or character().is_on_ceiling())

