extends State

@export var min_velocity : float
@export var time_to_min_velocity : float
@export var curve : Curve

@export var coyote_time : float = 0.15

var init_y : float
@export var horizontal_speed : float = 200

func _ready():
	assert(min_velocity < 0)
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
	init_y = character().position.y
	character().get_node("AnimationPlayer").play("fall1")
	if $"..".previous_state.has_flag("ground"):
		transition_list.append($"../RisingStop")
	
	
func on_process():

	var weight = curve.sample_baked(time_in_current_state / time_to_min_velocity)
	var fall_velocity = -lerpf(0, min_velocity, weight)
	
	if weight > 0.6:
		character().get_node("AnimationPlayer").play("fall2")
		
	character().velocity.y = fall_velocity
	character().velocity.x = \
		character().compute_air_x_vel(horizontal_speed)
		
	if time_in_current_state >= coyote_time:
		transition_list.erase($"../RisingStop")
	
	if time_in_current_state >= time_to_min_velocity:
		transition_list.append($"../Fall")
	
func on_exit():
	transition_list.erase($"../Fall")
	transition_list.erase($"../RisingStop")
	
func condition():
	return !character().is_on_floor() and \
	(character().velocity.y >= 0 or character().is_on_ceiling())

