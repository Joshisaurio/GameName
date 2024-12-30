extends Control

var first_names = [
	"James", "Mary", "John", "Patricia", "Robert", "Jennifer", "Michael", "Linda",
	"William", "Elizabeth", "David", "Barbara", "Richard", "Susan", "Joseph", "Jessica",
	"Thomas", "Sarah", "Charles", "Karen", "Emma", "Liam", "Olivia", "Noah",
	"Ava", "Isabella", "Sophia", "Mia", "Charlotte", "Amelia", "Harper", "Evelyn"
]

var middle_names = [
	"Mae", "Rose", "Grace", "Ann", "Marie", "Lynn", "Lee", "Jean",
	"Ray", "James", "John", "William", "Alan", "Peter", "Scott", "Dean",
	"Jane", "May", "Beth", "Anne", "Dawn", "Elle", "Faith", "Hope",
	"Jay", "Cole", "Blake", "Reid", "Kent", "Chase", "Luke", "Ross",
	"Joy", "Kate", "Ruth", "Sage", "Skye", "Paige", "Claire", "Jade",
	"Kyle", "Tate", "Finn", "Jack", "Grant", "Pierce", "Troy", "Quinn"
]

var last_names = [
	"Smith", "Johnson", "Williams", "Brown", "Jones", "Garcia", "Miller", "Davis",
	"Rodriguez", "Martinez", "Hernandez", "Lopez", "Gonzalez", "Wilson", "Anderson", "Thomas",
	"Taylor", "Moore", "Jackson", "Martin", "Lee", "Thompson", "White", "Harris",
	"Clark", "Lewis", "Robinson", "Walker", "Hall", "Young", "King", "Wright"
]

@export var input_enabled: bool = false
@export var max_middle_names: int = 3
@export var maxtime: int = 7

var prompt: String = ""
var player_input: String = ""
var current_letter_index: int = 0

var score: int = 0
var correct: int = 0
var failures: int = 0
var time: float = 0

@onready var tenant_label: RichTextLabel = $RichTextLabel

func _ready() -> void:
	$ProgressBar.max_value = maxtime

func _process(delta):
	if input_enabled:
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
	if input_enabled and event is InputEventKey and not event.is_pressed():
		if event.keycode < KEY_A or event.keycode > KEY_Z:
			return
		
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
				current_letter_index = 0
				print(correct)
				print(failures)
				_update_score()
				prompt = _generate_name()
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

func _generate_name() -> String:
	var first = first_names[randi() % first_names.size()]
	var last = " " + last_names[randi() % last_names.size()]
	
	var middle = ""
	var middle_name_count = randi() % max_middle_names
	for i in range(middle_name_count):
		middle += " " + middle_names[randi() % middle_names.size()]
	
	return first + middle + last
	
func _update_text() -> void:
	if current_letter_index <= 0:
		tenant_label.text = prompt
		return
			
	var colored_substring = prompt.substr(0, current_letter_index) # From 0 to current_letter_index
	var uncolored_substring = prompt.substr(current_letter_index) # From current_letter_index to prompt.size()
	var display_text = "[color=green]" + colored_substring + "[/color]" + uncolored_substring
	
	tenant_label.text = display_text

func _on_button_pressed():
	$Button.hide()
	prompt = _generate_name()
	tenant_label.bbcode_enabled = true
	_update_text()
	input_enabled = true
