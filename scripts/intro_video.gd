extends Node2D

@onready var gamemanager = self.get_parent()
var length = 27.9

func handle_video():
	await get_tree().create_timer(length).timeout
	$Control/VideoStreamPlayer.paused = true
	$VidAnim.play("FadeVideo")
	

func _input(_event):
	
	if Input.is_action_just_released("Spacebar"):
		_on_vid_anim_animation_finished(true)

func _on_vid_anim_animation_finished(_anim_name):
	
	gamemanager.load_level(gamemanager.title_scene)
