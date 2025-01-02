class_name Door; extends StaticBody3D

const TENANT_THEME_NEUTRAL = preload("res://assets/audio/Music/tenant_theme_1_(neutral).wav")
const TENANT_THEME_SAD = preload("res://assets/audio/Music/tenant_theme_2_(sad).wav")
const TENANT_THEME_HIPHOP = preload("res://assets/audio/Music/tenant_theme_3_(hiphop).wav")

const TENANT = preload("res://Manage/tenant.tscn")

signal door_interaction_begin(door_node)
signal door_interaction_end(door_node)

var current_minigame
var time_bonus = 15 # How much extra time each door gives on completion
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
@onready var room_c = preload("res://Manage/room_c.tscn")
@onready var room_d = preload("res://Manage/room_d.tscn")

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio_door: AudioStreamPlayer = $Sounds/Door
@onready var audio_music: AudioStreamPlayer = $Sounds/Music
@onready var TPoint = $TenantPoint

var room
const DOOR_SLAM = preload("res://assets/audio/SFX/Door/Door Close.wav")
const DOOR_OPEN = preload("res://assets/audio/SFX/Door/Door Open.wav")

func _ready():
	$Frame/DoorHingePoint/Label3D.text = address
	pass

func interacted():
	if !delivery_active or tenant_name == "":
		print("There is no tenant in this room!")
		return
	audio_door.set_stream(DOOR_OPEN)
	audio_door.play()
	door_interaction_begin.emit(self)
	
func _toggle_door_state():
	if open:
		_end_current_minigame()
	else:
		var music = [TENANT_THEME_NEUTRAL, TENANT_THEME_SAD, TENANT_THEME_HIPHOP].pick_random()
		var tenant = TENANT.instantiate()
		TPoint.add_child(tenant)
		animation_player.play("open_door")
		audio_music.set_stream(music)
		audio_music.play()
		room = [room_a, room_b, room_c, room_d].pick_random()
		var room_instance = room.instantiate()
		room_position.add_child(room_instance)
		get_tree().create_timer(2)
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
		audio_door.set_stream(DOOR_SLAM)
		audio_door.play()
		TPoint.get_child(0).queue_free()
		delivery_active = false
		tenant_name = ""
		current_minigame.queue_free()

func _minigame_completed():
	_end_current_minigame()
	door_interaction_end.emit(self)
	animation_player.play("close_door")
	audio_music.stop()


func remove_room(anim_name):
	if anim_name == "close_door":
		room_position.get_child(0).queue_free()
