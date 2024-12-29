extends Control

var _current_time: String = ""
@export_category("Settings")
@export var starting_time: int = 50
@onready var label: Label = $Placeholder
@onready var timer: Timer = $Timer

func _ready():
	timer.start(starting_time)
	
func _process(delta: float) -> void:
	if timer.is_stopped():
		return
	_update_time()
	_update_display()
	
func _update_time() -> void:
	var seconds: int = int(timer.time_left)
	var centiseconds: int = (timer.time_left - seconds) * 100
	_current_time = "%02d:%02d" % [seconds, centiseconds]
	
func _update_display() -> void:
	label.text = _current_time
	
func _on_timer_timeout() -> void:
	timer.stop()
	print("Ran out of time. Game over!")
