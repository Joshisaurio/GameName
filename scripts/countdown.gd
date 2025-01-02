extends Control

signal countdown

var _current_time: String = ""

@export_category("Settings")
@export var starting_time: int = 0
@onready var label: Label = $Placeholder
@onready var timer: Timer = $Timer

func _ready():
	countdown.connect(_start)
	hide()
	
func _process(_delta: float) -> void:
	if timer.is_stopped():
		return
		
	if get_tree().get_first_node_in_group("stamping").isSitting or get_tree().get_first_node_in_group("stamping").Canim.is_playing():
		timer.paused = true
		label.modulate.a = lerp(label.modulate.a, 0.0, 0.2)
	else:
		timer.paused = false
		label.modulate.a = lerp(label.modulate.a, 1.0, 0.2)
	
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
	
func _start():
	$Timer.start(starting_time)
	show()
	print("Seconds earned:" + str(starting_time))
