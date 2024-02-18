extends State

@export var max_tether_distance : float = 50
@onready var line : Line2D = $Line2D
@onready var FiringPoint : Node2D = $"../../Sprite2D/GrappleFiringPoint"
@onready var ExtensionPoint : Node2D = $holder/Sprite2D/ExtensionPoint

var attach_point : Vector2

func _ready():
	
	flags = [
		"air"
	]
	
	# State transitions go here, in order of priority
	transition_list = [
		$"../RisingStop",
		$"../FallingStart",
		$"../Run",
		$"../Idle",
	]

func on_enter():
		compute_attach_point()
		
		character().get_node("AnimationPlayer").play("air_grapple_fire")
		lock_state_for_duration(0.7)
		
		$AnimationPlayer.play("fire")
		$holder.position = FiringPoint.global_position
		$holder.rotation_degrees = compute_holder_rotation_deg()
		
		line.add_point(ExtensionPoint.global_position)
		line.add_point(attach_point)
		
		Util.delayed_callback(self._on_timeout, 0.7)
	
func on_process():
		line.points[0] = ExtensionPoint.global_position
		$holder.position = FiringPoint.global_position
		$holder.rotation_degrees = compute_holder_rotation_deg()
		character().velocity = character().velocity.lerp(Vector2.ZERO, 20 * get_process_delta_time())
	
func on_exit():
	$AnimationPlayer.play("RESET")
	line.clear_points()
	
func condition():
	return Input.is_action_just_released("Grapple")
	
func compute_holder_rotation_deg() -> float:
	return rad_to_deg(Vector2.DOWN.angle_to( FiringPoint.global_position - attach_point))

func compute_attach_point() -> void:
	attach_point = get_local_mouse_position()
	
func _on_timeout():
	var v = (attach_point - character().position).normalized() * 1000
	character().velocity.y += v.y * 4
	character().velocity.x += v.x / 2
