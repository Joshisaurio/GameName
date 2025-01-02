extends Control

@export var starting_time: int = 30

@onready var apartment: Node = get_node("/root/Gamemanager/New_Apartment")
@onready var gamestate_manager: Node = apartment.get_node("Core/GameManager")
@onready var label: Label = $Placeholder
@onready var new_label: Label = $added_time

var stored_time: float = starting_time
var display_time: String = ""
var display_paused: bool = false
var is_running: bool = false
var is_paused: bool = false

signal game_over

func _ready():
	apartment.find_child("OfficeDoor").begin_game.connect(_start, CONNECT_ONE_SHOT)
	hide()
	
func _process(delta: float) -> void:
	if !is_running:
		label.modulate.a = 0.5 + (sin(Time.get_ticks_msec() * 0.005) * 0.5)
	else:
		label.modulate.a = 1.0 
		
	if get_tree().get_first_node_in_group("stamping").isSitting or get_tree().get_first_node_in_group("stamping").Canim.is_playing():
		is_paused = true
		label.modulate.a = lerp(label.modulate.a, 0.0, 0.2)
	else:
		is_paused = false
		label.modulate.a = lerp(label.modulate.a, 1.0, 0.2)
	
	if is_running and !is_paused:
		stored_time -= delta
		if stored_time <= 0:
			stored_time = 0
			is_running = false
			game_over.emit()
	
	_update_time()
	if !display_paused:
		_update_display()

func _get_time(time: float) -> String:
	var seconds: int = int(time)
	var centiseconds: int = (time - seconds) * 100
	return "%02d:%02d" % [seconds, centiseconds]

func _update_time() -> void:
	display_time = _get_time(stored_time)
	
func _update_display() -> void:
	label.text = display_time
	
func _start() -> void:
	is_running = true
	
func add_time(added_time: float) -> void:
	display_paused = true
	stored_time += added_time
	new_label.text = _get_time(added_time)
	new_label.show()
	
	if !is_running:
		is_running = true
		
	_update_time()
	var tween = create_tween()
	for i in range(3):
		tween.tween_property(new_label, "modulate:a", 1.0, 0.4)
		tween.tween_property(new_label, "modulate:a", 0.0, 0.4)
	await tween.finished
	new_label.hide()
	display_paused = false
		
	
