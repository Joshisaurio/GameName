extends Node3D

@onready var UIAnim = $UI/UIAnim
@onready var Dialogue = $UI/Fader/Dialogue
@onready var PaperPoint = $PaperOrigin

const PAPER = preload("res://Manage/paper.tscn")

var dialogue_speed := 0.03

#Stamping stuff
var total_evictions
var eviction_page

func _ready():
	
	UIAnim.play("IntroAnim")
	display_dialogue("[Insert a cutscene or something here]", dialogue_speed)
	await get_tree().create_timer(6).timeout
	generate_eviction()

func display_dialogue(text: String, speed: float):
	
	#Clear any old dialogue incase it gets stuck somehow
	Dialogue.text = ""
	
	for char in text:
		Dialogue.text += char
		await get_tree().create_timer(speed).timeout
	
	await get_tree().create_timer(3).timeout
	Dialogue.text = ""

func generate_eviction():
	
	total_evictions = randi_range(8, 18) #How many papers the player must stamp, sign, etc
	eviction_page = PAPER.instantiate()
	PaperPoint.add_child(eviction_page)
	
