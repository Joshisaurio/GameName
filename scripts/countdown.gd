extends Control

@export var starting_time: int = 0

@onready var apartment: Node = get_node("/root/Gamemanager/New_Apartment")
@onready var gamestate_manager: Node = apartment.get_node("Core/GameManager")
@onready var label: Label = $Placeholder
@onready var new_label: Label = $added_time

var stored_time: float = starting_time
var display_time: String = ""

var is_display_paused: bool = false
var is_paused: bool = true
var grace_period: bool = true

var game_is_over:bool = false

signal game_over

func _ready():
	apartment.find_child("OfficeDoor").begin_game.connect(_begin, CONNECT_ONE_SHOT)
	hide()
	
func _begin():
	start()
	grace_period = false
	
func _process(delta: float) -> void:
	if is_paused:
		label.modulate.a = 0.5 + (sin(Time.get_ticks_msec() * 0.005) * 0.5)
	else:
		label.modulate.a = 1.0 
	
	if Input.is_action_just_pressed("lose"):
		stored_time = 0
	
	if !is_paused and !grace_period and !game_is_over:
		stored_time -= delta
		if stored_time <= 0:
			stored_time = 0
			stop()
			game_over.emit()
	
	_update_time()
	if !is_display_paused:
		_update_display()
		
func _get_time(time: float) -> String:
	var seconds: int = int(time)
	var centiseconds: int = (time - seconds) * 100
	return "%02d:%02d" % [seconds, centiseconds]

func _update_time() -> void:
	display_time = _get_time(stored_time)
	
func _update_display() -> void:
	label.text = display_time
	
func start() -> void:
	is_paused = false
	
func stop() -> void:
	is_paused = true
	
func add_time(added_time: float) -> void:
	is_display_paused = true
	stored_time += added_time
	new_label.text = _get_time(added_time)
	new_label.show()
		
	_update_time()
	var tween = create_tween()
	for i in range(3):
		tween.tween_property(new_label, "modulate:a", 1.0, 0.4)
		tween.tween_property(new_label, "modulate:a", 0.0, 0.4)
	await tween.finished
	new_label.hide()
	is_display_paused = false

func _on_game_over():
	print("Signal sent")
	$Game_Over._begin()
	get_tree().get_first_node_in_group("Player").set_physics_process(false)
	game_is_over = true
	
	
