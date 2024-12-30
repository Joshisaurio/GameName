extends Node3D

@onready var UIAnim = $UI/UIAnim
@onready var Dialogue = $UI/Fader/Dialogue
@onready var PaperPoint = $PaperOrigin
@onready var gamemanager = self.get_parent()

var dialogue_speed := 0.03

var dialogues = [
	"Dialogue\n[Press space to continue]",
	"More dialog",
	"Final dialogue"]
	
var dialogue = 0

var next = false

func _ready():
	
	UIAnim.play("IntroAnim")
	display_dialogue(dialogues[dialogue], dialogue_speed)

func _input(event):
	if event is InputEventKey and next:
		if dialogue < len(dialogues) - 1:
			next = false
			dialogue += 1
			display_dialogue(dialogues[dialogue], dialogue_speed)
		else:
			gamemanager.load_level(gamemanager.apartment)
	

func display_dialogue(text: String, speed: float):
	
	#Clear any old dialogue incase it gets stuck somehow
	Dialogue.text = ""
	
	for char in text:
		Dialogue.text += char
		await get_tree().create_timer(speed).timeout

	next = true
	
