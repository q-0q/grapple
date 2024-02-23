extends State

var init_ground_rel_pos : Vector2

func _ready():
	
	# State transitions go here, in order of priority
	transition_list = [
		$"../RisingStop",
		$"../Run",
		$"../Rise",
		$"../FallingStart",
	]
	
	flags = [
		"ground"
	]

func on_enter():

		character().get_node("AnimationPlayer").play("idle")
		character().rotation = -character().get_floor_normal().angle_to(Vector2.UP)
	
func on_process():
	character().rotation = -character().get_floor_normal().angle_to(Vector2.UP)
	character().velocity.x = character().compute_ground_x_vel(0)
	
func on_exit():
	pass
	
func condition():
	return character().is_on_floor()

