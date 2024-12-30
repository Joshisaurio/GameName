class_name Door; extends StaticBody3D

var open: bool = false
var is_changing_state = false

@export var address: String = ""
@export var tenant_name: String = ""
@export var lerp_speed: float = 2.0

@onready var door_panel: MeshInstance3D = $Panel
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var goto_position: Node3D = $GotoPosition
@onready var current_camera = get_viewport().get_camera_3d()

func _ready():
	pass
	
func _toggle_door():
	if is_changing_state:
		return
	
	is_changing_state = true
	
	if open:
		animation_player.play("door_close")
		_toggle_camera_focus()
	else:
		animation_player.play("door_open")
		_toggle_camera_focus()
		
	open = !open
		
func _toggle_camera_focus():
	pass
	
func _on_animation_player_animation_finished(anim_name):
	if anim_name == "door_close" or anim_name == "door_open":
		is_changing_state = false
