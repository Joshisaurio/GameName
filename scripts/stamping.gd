extends Node3D

@onready var Canim = $Camera3D/CamAnim
@onready var player = preload("res://Manage/player.tscn")
@onready var camera = $Camera3D
@onready var filter = $Camera3D/StampingFilter

#Main Nodes
@onready var Apartment = get_parent().get_parent()
@onready var Gamemanager = get_tree().root.get_child(0)

var isSitting = true
var active_player

func _input(event):
	if event is InputEventKey and next:
		if event.keycode == KEY_ENTER:
			gamemanager.load_level(gamemanager.apartment)
		else:
			if dialogue < len(dialogues) - 1:
				next = false
				dialogue += 1
				display_dialogue(dialogues[dialogue], dialogue_speed)
			else:
				gamemanager.load_level(gamemanager.apartment)
	
	if Input.is_action_just_pressed("Interact"):
		if isSitting:
			Canim.play("Exit_Stamp")
		else:
			isSitting = true
			camera.make_current()
			filter.visible = true
			Canim.play("Enter_Stamp")
			active_player.queue_free()

func CamAnim_Finished(anim_name):
	match anim_name:
		"Exit_Stamp":
			active_player = player.instantiate()
			Apartment.add_child(active_player)
			filter.visible = false
			isSitting = false
			active_player.global_position.x = camera.global_position.x
			active_player.global_position.z = camera.global_position.z
			active_player.global_position.y = 1.5
