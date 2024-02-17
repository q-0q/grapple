extends Node

@export var debug : bool = false

# bookkeeping
var current_state : State
var previous_state : State
@onready var default_state : State = $Idle

var desired_position : Vector2
var desired_rotation_deg : float
var desired_animation : String
var desired_flip_h : bool = false

func _ready():
	current_state = default_state
	previous_state = null
	current_state.set_flip_h.connect(self.set_flip_h)
	desired_position = current_state.character().position
	desired_rotation_deg = current_state.character().rotation_degrees

# called by the parent CharacterBody2D to update FSM's
# desired state this frame
func update():
	var new_state = current_state.get_transition_state()
	if new_state != current_state:
		previous_state = current_state
		current_state.meta_on_exit()
		current_state = new_state
		current_state.meta_on_enter()
		current_state.set_flip_h.connect(self.set_flip_h)
		
		for state : State in get_children():
			state.reset_time_in_current_state()

		if debug:
			print("Was in " + previous_state.name + " for " + str(previous_state.frames_in_state) + " frames")
			print("Enter " + current_state.name)

	else:
		current_state.meta_on_process()
	
	if debug:
		$"../Label".text = current_state.name

func set_flip_h(val):
	desired_flip_h = val
