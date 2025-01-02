extends Control

@onready var countdown: Node = get_node("/root/Gamemanager/New_Apartment/Core/Countdown")
const SFX_TYPING_1 = preload("res://assets/audio/Typing/SFX - Typing Var  1.wav")
const SFX_TYPING_2 = preload("res://assets/audio/Typing/SFX - Typing Var  2.wav")
const SFX_TYPING_3 = preload("res://assets/audio/Typing/SFX - Typing Var  3.wav")
const SFX_TYPING_4 = preload("res://assets/audio/Typing/SFX - Typing Var  4.wav")
const SFX_TYPING_5 = preload("res://assets/audio/Typing/SFX - Typing Var  5.wav")
const CHARACTER_VALUE: int = 55

@export var max_middle_names: int = 3
@export var max_time: int = 6

var game_started: bool = false # Has the player began typing?
var prompt: String = ""
var player_input: String = ""
var current_letter_index: int = 0

var character_score: int = 0
var accuracy_ratio: float = 0
var time_bonus: int = 0

var total_score: int = 0
var correct: int = 0
var failures: int = 0
var time: float = 0

@onready var tenant_label: RichTextLabel = $RichTextLabel
@onready var audio: AudioStreamPlayer = $AudioStreamPlayer

signal minigame_completed(total_score)

func _ready() -> void:
	$ProgressBar.max_value = max_time
	_update_text()

func _process(delta):
	if game_started:
		time += delta
	if time > float(max_time):
		countdown.add_time(float(0))
		minigame_completed.emit(0)
	$ProgressBar.value = float(max_time) - time
	
	if correct != 0 and failures !=0:
		accuracy_ratio = float(correct)/(correct + failures)
		print(accuracy_ratio)
		$Accuracy.text = "Accuracy: " + str(round(accuracy_ratio * 100)) + "%"
	else:
		$Accuracy.text = "Accuracy: 100%"
		
	if time > 0:
		time_bonus = 50 - round(50 * time / max_time)
		$TimeBonus.text = "Time Bonus: " + str(time_bonus)
	else:
		$TimeBonus.text = "Time Bonus: 0"
		
	character_score = round(CHARACTER_VALUE * accuracy_ratio)
	total_score += character_score
	$CharacterScore.text = str(character_score)
	
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
			var sound = [SFX_TYPING_1, SFX_TYPING_2, SFX_TYPING_3, SFX_TYPING_4, SFX_TYPING_5].pick_random()
			audio.set_stream(sound)
			audio.play()
			
			current_letter_index += 1
			correct += 1
			
			if current_letter_index >= prompt.length():
				countdown.add_time(float(time_bonus))
				minigame_completed.emit(total_score)
		else:
			failures += 1
			
		_update_text()
	
func _update_text() -> void:
	if current_letter_index <= 0:
		tenant_label.text = prompt
		return
			
	var colored_substring = prompt.substr(0, current_letter_index) # From 0 to current_letter_index
	var uncolored_substring = prompt.substr(current_letter_index) # From current_letter_index to prompt.size()
	var display_text = "[color=green]" + colored_substring + "[/color]" + uncolored_substring
	
	tenant_label.text = display_text
