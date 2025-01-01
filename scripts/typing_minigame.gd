extends Control

@export var max_middle_names: int = 3
@export var maxtime: int = 7

var game_started: bool = false # Has the player began typing?
var prompt: String = ""
var player_input: String = ""
var current_letter_index: int = 0

var score: int = 0
var correct: int = 0
var failures: int = 0
var time: float = 0

@onready var tenant_label: RichTextLabel = $RichTextLabel

signal minigame_completed

func _ready() -> void:
	$ProgressBar.max_value = maxtime
	_update_text()

func _process(delta):
	if game_started:
		time += delta
	$ProgressBar.value = float(maxtime)-time
	
	if correct != 0 and failures !=0:
		$Accuracy.text = "Accuracy: " + str(round(float(correct)/(correct + failures)*100)) + "%"
	else:
		$Accuracy.text = "Accuracy: 100%"
		
	if time > 0:
		$TimeBonus.text = "Time bonus: " + str(50-round(50 * time/maxtime))
	else:
		$TimeBonus.text = "Time bonus: 0"
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and not event.is_pressed():
		if event.keycode < KEY_A or event.keycode > KEY_Z:
			return
		
		game_started = true
		var key_typed = OS.get_keycode_string(event.keycode).to_lower()	
		var next_key = prompt.substr(current_letter_index, 1).to_lower()
	
		if next_key == " ":
			current_letter_index += 1
			next_key = prompt.substr(current_letter_index, 1).to_lower()
	
		if key_typed == next_key:
			current_letter_index += 1
			correct += 1
			print("success " + str(correct))
			
			if current_letter_index >= prompt.length():
				print(correct)
				print(failures)
				_update_score()
				minigame_completed.emit()
		else:
			failures += 1
			print("failure " + str(failures))
			
		_update_text()

func _update_score():
	if time < 20.0:
		var attempts:int = correct + failures
		var rawscore:int = int(float(correct)/attempts*100)
		var timebonus = 50-round(50 * time/maxtime)
		score += rawscore + timebonus
	
	$Score.text = "Score: " + str(score)
	
	correct = 0
	failures = 0
	time = 0
	
func _update_text() -> void:
	if current_letter_index <= 0:
		tenant_label.text = prompt
		return
			
	var colored_substring = prompt.substr(0, current_letter_index) # From 0 to current_letter_index
	var uncolored_substring = prompt.substr(current_letter_index) # From current_letter_index to prompt.size()
	var display_text = "[color=green]" + colored_substring + "[/color]" + uncolored_substring
	
	tenant_label.text = display_text
