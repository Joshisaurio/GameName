extends Control

@onready var UIAnim = $UIAnim
@onready var Dialogue = $Fader/Dialogue
@onready var DialogueAudio = $Audio

@onready var gamemanager = self.get_parent()

#Audio
const SFX___TYPING_VAR__1 = preload("res://assets/audio/Typing/SFX - Typing Var  1.wav")
const SFX___TYPING_VAR__2 = preload("res://assets/audio/Typing/SFX - Typing Var  2.wav")
const SFX___TYPING_VAR__3 = preload("res://assets/audio/Typing/SFX - Typing Var  3.wav")
const SFX___TYPING_VAR__4 = preload("res://assets/audio/Typing/SFX - Typing Var  4.wav")
const SFX___TYPING_VAR__5 = preload("res://assets/audio/Typing/SFX - Typing Var  5.wav")

var dialogue_speed := 0.03

var dialogues = [
	"Dialogue\n[Press space to continue]",
	"More dialog",
	"Final dialogue"]
	
var dialogue = 0

var next = false

func _ready():
	
	display_dialogue(dialogues[dialogue], dialogue_speed)

func choose(sounds):
	sounds.shuffle()
	return sounds.front()

func _input(event):
	if event is InputEventKey and next:
		if dialogue < len(dialogues) - 1:
			next = false
			dialogue += 1
			display_dialogue(dialogues[dialogue], dialogue_speed)
		else:
			UIAnim.play("IntroAnim")
	

func display_dialogue(text: String, speed: float):
	
	#Clear any old dialogue incase it gets stuck somehow
	Dialogue.text = ""
	
	for char in text:
		Dialogue.text += char
		var sound = choose([SFX___TYPING_VAR__1, SFX___TYPING_VAR__2, SFX___TYPING_VAR__3, SFX___TYPING_VAR__4, SFX___TYPING_VAR__5])
		DialogueAudio.set_stream(sound) ; DialogueAudio.play()
		await get_tree().create_timer(speed).timeout

	next = true
	


func Intro_finished(_anim_name):
	self.queue_free()
