extends CharacterBody2D

@export var ground_friction : float = 20
@export var air_friction : float = 20


func _ready():
	NoiseManager.cam = $Camera2D
	
func _process(delta):
	
	# Apply state from FSM
	$Sprite2D.scale.x = -1 if $FSM.desired_flip_h else 1
	
	# Update FSM
	$FSM.update()
	
	move_and_slide()
	
	
	if Input.is_key_pressed(KEY_L):
		Engine.time_scale = 0.05
	else:
		Engine.time_scale = 1


func compute_x_velocity(friction : float, goal: float) -> float:
	return lerpf(velocity.x, goal, friction * get_process_delta_time())

func compute_air_x_vel(speed) -> float:
	var v : float = 0
	
	if Input.is_action_pressed("Left"):
		v = compute_x_velocity(air_friction, -speed)
	elif Input.is_action_pressed("Right"):
		v = compute_x_velocity(air_friction, speed)
	else:
		v = compute_x_velocity(air_friction, 0)
	
	return v
	
func compute_ground_x_vel(goal) -> float:
	if goal == 0:
		return compute_x_velocity(ground_friction / 5, goal)
		
	return compute_x_velocity(ground_friction, goal)
	
