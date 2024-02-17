extends State

@export var skid_friction : float = 7

func _ready():
	
	# State transitions go here, in order of priority
	transition_list = [
		$"../FallingStart",
		$"../Rise",
		$".",
		$"../Run",
		$"../Idle",
	]
	
	flags = [
		"ground"
	]

func on_enter():
	character().get_node("AnimationPlayer").play("skid")
	
func on_process():
	character().velocity.x = character().compute_x_velocity(skid_friction, 0)
	
func on_exit():
	pass
	
func condition():
	if (abs(character().velocity.x) < 10): return false
	var l : bool = Input.is_action_pressed("Left")
	var r : bool = Input.is_action_pressed("Right")
	return (l and character().velocity.x > 0) or (r and character().velocity.x < 0)

