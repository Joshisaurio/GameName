extends Node3D

@onready var UIAnim = $UI/UIAnim
@onready var Dialogue = $UI/Fader/Dialogue

var dialogue_speed := 0.03

#Stamping stuff
var total_evictions

func _ready():
	
	UIAnim.play("IntroAnim")
	display_dialogue("[Insert a cutscene or something here]", dialogue_speed)

func display_dialogue(text: String, speed: float):
	
	#Clear any old dialogue incase it gets stuck somehow
	Dialogue.text = ""
	
	for char in text:
		Dialogue.text += char
		await get_tree().create_timer(speed).timeout
	
	await get_tree().create_timer(3).timeout
	Dialogue.text = ""

func generate_evictions():
	
	total_evictions = randi_range(8, 18) #How many papers the player must stamp, sign, etc
	

func show_next_eviction():
	if total_evictions > 0:
		show_eviction()
		total_evictions -= 1
	

func show_eviction():
	pass
