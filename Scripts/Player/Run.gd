extends State

@export var base_speed : float = 20
@export var time_until_super : float = 0.5
@export var super_speed_multiplier : float = 2

var speed : float

func _ready():
	
	should_update_flip_h = true
	
	# State transitions go here, in order of priority
	transition_list = [
		$"../RisingStop",
		$"../Rise",
		$"../Skid",
		$".",
		$"../Idle",
		$"../FallingStart",
	]
	
	flags = [
		"ground"
	]

func on_enter():
	speed = base_speed
	
	if $"..".previous_state.has_flag("air"):
		character().get_node("AnimationPlayer").play("grind1_fromair")
	else:
		character().get_node("AnimationPlayer").play("grind1_fromground")
	
	
func on_process():
	
	if Input.is_action_pressed("Left"):
		character().velocity.x = character().compute_ground_x_vel(-speed)
	elif Input.is_action_pressed("Right"):
		character().velocity.x = character().compute_ground_x_vel(speed)
		
	#if time_in_current_state > time_until_super:
		#for particles in character().get_node("Sprite2D").get_children():
			#particles.emitting = true
	
	if speed == base_speed and time_in_current_state > time_until_super:
		speed = base_speed * super_speed_multiplier
		character().get_node("AnimationPlayer").play("grind2")
		
	
		
func on_exit():
	return
	for particles in character().get_node("Sprite2D").get_children():
		particles.emitting = false
	
func condition():
	# Left or Right but not both
	var l : bool = Input.is_action_pressed("Left")
	var r : bool = Input.is_action_pressed("Right")
	return (l or r) and !(l and r) and character().is_on_floor()

