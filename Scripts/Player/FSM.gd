extends Node

# bookkeeping
var current_state : State
@onready var default_state : State = $Fall

var desired_position : Vector2
var desired_rotation_deg : float
var desired_animation : String

# Called when the node enters the scene tree for the first time.
func _ready():
	current_state = default_state

func _physics_process(delta):
	
	var new_state = current_state.get_transition_state()
	if new_state != current_state:
		current_state.on_exit()
		current_state = new_state
		current_state.meta_on_enter()
		
	current_state.meta_on_process()
	
	desired_position = current_state.desired_position
	desired_rotation_deg = current_state.desired_rotation_deg
	desired_animation = current_state.desired_animation
