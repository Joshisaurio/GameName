extends Control

@onready var ui_anim: AnimationPlayer = $UIAnim
@onready var dialogue: Label = $Fader/Dialogue
@onready var audio: AudioStreamPlayer = $Audio
@onready var gamemanager = self.get_parent()

const SFX_AHEM = preload("res://assets/audio/SFX/Intro/ahem.wav")
const SFX_PICK_UP = preload("res://assets/audio/SFX/Intro/pick_up_phone.mp3")
const SFX_SLAM_PHONE = preload("res://assets/audio/SFX/Intro/slam_phone.mp3")

const SFX_TYPING_1 = preload("res://assets/audio/Typing/SFX - Typing Var  1.wav")
const SFX_TYPING_2 = preload("res://assets/audio/Typing/SFX - Typing Var  2.wav")
const SFX_TYPING_3 = preload("res://assets/audio/Typing/SFX - Typing Var  3.wav")
const SFX_TYPING_4 = preload("res://assets/audio/Typing/SFX - Typing Var  4.wav")
const SFX_TYPING_5 = preload("res://assets/audio/Typing/SFX - Typing Var  5.wav")

var input_enabled: bool = true
var dialogue_speed: float = 0.03
var auto_speed: float = 1

var intro: Array[String] = [
	"I'll keep this phone call brief.",
	"Our profit margins are down 12% this quarter.",
	"We're hemorrhaging potential revenue in your district.",
	"To put it mildly, the board isn't happy with your performance.",
	"*ahem*",
	"Clear out your office by the end of the day.",
	"You're fired.",
]
	
var dialogue_id: int = 0
var next: bool = false

func _ready():
	audio.set_stream(SFX_PICK_UP)
	audio.play()
	await get_tree().create_timer(2).timeout
	_display_dialogue(intro[dialogue_id], dialogue_speed)

func _input(event):
	if !input_enabled:
		return
	
	if event is InputEventKey and next:
		if event.keycode == KEY_ENTER: # Skip button
			_proceed()
		
		if dialogue_id < (intro.size() - 1) - 1:
			next = false
			dialogue_id += 1
			_display_dialogue(intro[dialogue_id], dialogue_speed)
		else:
			input_enabled = false
			_display_dialogue(intro[intro.size() - 1], dialogue_speed)
			await get_tree().create_timer(2).timeout
			audio.set_stream(SFX_SLAM_PHONE)
			audio.play()
			await get_tree().create_timer(1).timeout
			_fade_label(3)
			await get_tree().create_timer(5).timeout # Long silence
			_proceed()
			
func _proceed():
	$Fader/Dialogue.visible = false
	ui_anim.play("IntroAnim")
	get_tree().get_first_node_in_group("stamping")._begin()
	
func _display_dialogue(text: String = "", speed: float = 1):
	dialogue.text = "" # Clear old dialogue just in case it gets stuck
	
	for chart in text:
		dialogue.text += chart
		var sound = [SFX_TYPING_1, SFX_TYPING_2, SFX_TYPING_3, SFX_TYPING_4, SFX_TYPING_5].pick_random()
		audio.set_stream(sound)
		audio.play()
		await get_tree().create_timer(speed).timeout
		
	if (dialogue_id == 4):
		audio.set_stream(SFX_AHEM)
		audio.play()
		await get_tree().create_timer(1).timeout
		
	next = true

func _fade_label(speed: int):
	var tween = create_tween()
	tween.tween_property(dialogue, "modulate", Color(modulate.r, modulate.g, modulate.b, 0.0), speed)

func Intro_finished(_anim_name):
	self.queue_free()
	
