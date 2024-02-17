extends Node2D

class_name State

var transition_list : Array[State]
var flags : Array[String]

var time_in_current_state : float = 0
var is_locked : bool = false
var should_update_flip_h : bool = false

var frames_in_state : int = 0

func _process(delta):
	time_in_current_state += delta

### Monitor State metadata around user on_enter() and on_process()

func meta_on_enter() -> void:
	frames_in_state = 1
	on_enter()

func meta_on_process() -> void:
	
	frames_in_state += 1
	
	if should_update_flip_h:
		if Input.is_action_pressed("Left"):
			set_flip_h.emit(true)
		elif Input.is_action_pressed("Right"):
			set_flip_h.emit(false)
		
	on_process()
	
func meta_on_exit() -> void:
	on_exit()

func reset_time_in_current_state() -> void:
	time_in_current_state = 0
	

###
		
func get_transition_state() -> State:
	if transition_list.is_empty():
		push_error("State " + name + " has an empty transition list")
		get_tree().quit(1)
	
	if is_locked:
		return self
	
	for state in transition_list:
		if state.condition(): return state
	return self

###

func character() -> CharacterBody2D:
	if !($"../.." is CharacterBody2D):
		push_error("State " + name + " could not find CharacterBody2D at $'../..'', found " + $"../..".name)
		get_tree().quit(1)
		
	return $"../.."
	
signal set_flip_h(val : bool)

###
	
func lock_state_for_duration(duration) -> void:
	
	is_locked = true
	Util.delayed_callback(self._on_lock_state_timeout, duration)

func _on_lock_state_timeout() -> void:
	is_locked = false
	
func has_flag(flag):
	return flag in flags
		
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
