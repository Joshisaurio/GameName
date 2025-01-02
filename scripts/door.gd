class_name Door; extends StaticBody3D

signal door_interaction_begin(door_node)
signal door_interaction_end(door_node)

var current_minigame
var delivery_active: bool = false # Is a delivery active on this door?
var open: bool = false

@export_group("Tenant Info")
@export var address: String = "" # A district character (e.g 'A') followed by three digits (e.g '327')
@export var tenant_name: String = ""

@export_group("Minigame")
@export var max_middle_names: int = 3
@export var minigame = preload("res://scenes/typing_minigame.tscn")

@onready var room_position = $RoomPoint
@onready var room_a = preload("res://Manage/room_a.tscn")
@onready var room_b = preload("res://Manage/room_b.tscn")

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio_open_door: AudioStreamPlayer = $Sounds/Door

var room
const DOOR_SLAM = preload("res://assets/audio/SFX/Door/Door Close.wav")
const DOOR_OPEN = preload("res://assets/audio/SFX/Door/Door Open.wav")

func _ready():
	pass

func interacted():
	if !delivery_active or tenant_name == "":
		print("There is no tenant in this room!")
		return
	audio_open_door.set_stream(DOOR_OPEN)
	audio_open_door.play()
	door_interaction_begin.emit(self)
	
func _toggle_door_state():
	if open:
		_end_current_minigame()
	else:
		animation_player.play("open_door")
		room = [room_a, room_b].pick_random()
		var room_instance = room.instantiate()
		room_position.add_child(room_instance)
		await get_tree().create_timer(2)
		_start_minigame()
		
	open = !open
	
func _start_minigame():
	_end_current_minigame()
		
	current_minigame = minigame.instantiate()
	current_minigame.prompt = tenant_name
	get_tree().root.add_child(current_minigame)
	current_minigame.minigame_completed.connect(_minigame_completed, CONNECT_ONE_SHOT)
	
func _end_current_minigame():
	if current_minigame != null:
		audio_open_door.set_stream(DOOR_SLAM)
		audio_open_door.play()
		delivery_active = false
		tenant_name = ""
		current_minigame.queue_free()

func _minigame_completed():
	_end_current_minigame()
	door_interaction_end.emit(self)
	animation_player.play("close_door")


func remove_room(anim_name):
	if anim_name == "close_door":
		room_position.get_child(0).queue_free()
