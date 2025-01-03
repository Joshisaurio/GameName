extends Node2D

@onready var gamemanager = self.get_parent()
var length = 26

func _ready():
	handle_video()

func handle_video():
	await get_tree().create_timer(length).timeout
	print("Finished")
	#$Control/VideoStreamPlayer.paused = true
	
	$VidAnim.play("FadeVideo")

func _input(event):
	if event is InputEventKey:
		if event.keycode == KEY_ENTER: # Skip button
			_on_vid_anim_animation_finished(true)

func _on_vid_anim_animation_finished(_anim_name):
	$VidAnim.play("FadeVideo")
	gamemanager.load_level(gamemanager.title_scene)
