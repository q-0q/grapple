extends Node

class_name State

var transition_list : Array[State]

var desired_position: Vector2 = Vector2(0,0)
var desired_rotation_deg: float = 0
var desired_animation: String = ""

var time_in_current_state : float = 0

func meta_on_enter() -> void:
	time_in_current_state = 0
	on_enter()

func meta_on_process() -> void:
	time_in_current_state += get_process_delta_time()
	on_process()

func get_transition_state() -> State:
	if transition_list.is_empty():
		push_error("State " + name + " has an empty transition list")
		get_tree().quit(1)
		
	for state in transition_list:
		if state.condition(): return state
	return self
	
func character() -> CharacterBody2D:
	if !($"../.." is CharacterBody2D):
		push_error("State " + name + " could not find CharacterBody2D at $'../..'', found " + $"../..".name)
		get_tree().quit(1)
		
	return $"../.."
	
### Virtual functions ##############

# Called when state is entered
func on_enter() -> void:
	pass

# Called each frame the state is active
func on_process() -> void:
	pass

# Called when state is exited
func on_exit() -> void:
	pass
	
# Condition in which state may be entered
func condition() -> bool:
	return false

#####################################
