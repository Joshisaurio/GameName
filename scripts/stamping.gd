extends Node3D

@onready var UIAnim = $UI/UIAnim
@onready var Dialogue = $UI/Fader/Dialogue
@onready var PaperPoint = $PaperOrigin
@onready var gamemanager = self.get_parent()

var dialogue_speed := 0.03
func _ready():
	
	UIAnim.play("IntroAnim")
	display_dialogue("[Insert a cutscene or something here]", dialogue_speed)

func display_dialogue(text: String, speed: float):
	
	#Clear any old dialogue incase it gets stuck somehow
	Dialogue.text = ""
	
	for char in text:
		Dialogue.text += char
		await get_tree().create_timer(speed).timeout
	
	await get_tree().create_timer(5).timeout
	Dialogue.text = ""
