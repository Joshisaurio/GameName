extends Control

@onready var UIAnim = $UIAnim
@onready var Dialogue = $Fader/Dialogue
@onready var DialogueAudio = $Audio

@onready var gamemanager = self.get_parent()

const SFX___TYPING_VAR__1 = preload("res://assets/audio/Typing/SFX - Typing Var  1.wav")
const SFX___TYPING_VAR__2 = preload("res://assets/audio/Typing/SFX - Typing Var  2.wav")
const SFX___TYPING_VAR__3 = preload("res://assets/audio/Typing/SFX - Typing Var  3.wav")
const SFX___TYPING_VAR__4 = preload("res://assets/audio/Typing/SFX - Typing Var  4.wav")
const SFX___TYPING_VAR__5 = preload("res://assets/audio/Typing/SFX - Typing Var  5.wav")

var dialogue_speed := 0.03

var dialogues = [
	"Hello? This is [PLAYERNAME]?",
	#"I'll keep it short.",
	#"Profits are down 12% this quarter.",
	#"We're hemorrhaging potential revenue in your district.",
	#"Your eviction record is an embarrassing PR liability.",
	#"Do I even need to say more?",
	#"The board isn't happy with your performance.",
	#"*ahem*",
	#"Clear out your office by the end of the day.",
	#"You're out."
]
	
var dialogue = 0

var next = false

func _ready():
	
	display_dialogue(dialogues[dialogue], dialogue_speed)

func choose(sounds):
	sounds.shuffle()
	return sounds.front()

func _input(event):
	if event is InputEventKey and next:
		if event.keycode == KEY_ENTER:
			UIAnim.play("IntroAnim")
			get_tree().get_first_node_in_group("stamping")._begin()
			$Fader/Dialogue.visible = false
		if dialogue < len(dialogues) - 1:
			next = false
			dialogue += 1
			display_dialogue(dialogues[dialogue], dialogue_speed)
		else:
			UIAnim.play("IntroAnim")
			get_tree().get_first_node_in_group("stamping")._begin()
	

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
	
