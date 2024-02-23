extends State

@export var grapple_distance : float = 250
@export var noise_curve : Curve
@onready var line : Line2D = $Line2D
@onready var FiringPoint : Node2D = $"../../Sprite2D/GrappleFiringPoint"
@onready var ExtensionPoint : Node2D = $holder/Sprite2D/ExtensionPoint

var attach_point : Vector2
var is_attached : bool

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
	
		NoiseManager.do_shake(100, 30, noise_curve, 0.1)
		is_attached = compute_attach_point()
		
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

		character().velocity = character().velocity.lerp(Vector2.ZERO, 15 * get_process_delta_time())
	
func on_exit():
	
	FiringPoint.get_node("RayCast2D").target_position = Vector2.ZERO
	$AnimationPlayer.play("RESET")
	line.clear_points()
	
func condition():
	return Input.is_action_just_released("Grapple")
	
func compute_holder_rotation_deg() -> float:
	return rad_to_deg(Vector2.DOWN.angle_to( FiringPoint.global_position - attach_point))

func compute_attach_point() -> bool:
	var cast : RayCast2D = FiringPoint.get_node("RayCast2D")
	cast.target_position = (FiringPoint.get_local_mouse_position()).normalized() * grapple_distance
	cast.force_raycast_update()
	if cast.is_colliding():
		attach_point = cast.get_collision_point()
		
		var rot = -cast.get_collision_normal().angle_to(Vector2.UP)
		
		if abs(rot) <= PI * 0.5:
			pass
			# print(rot)
			#character().rotation = rot
		return true
	else:
		attach_point = ((get_global_mouse_position() - character().position).normalized() * grapple_distance) + character().position
		return false
	
func _on_timeout():
	if !is_attached: return
	#NoiseManager.do_shake(120, 50, noise_curve, 0.2)
	var v = (attach_point - character().position).normalized() * 2000
	if v.y > 0: v.y += 20
	character().velocity.y += v.y * 4
	character().velocity.x += v.x / 2
