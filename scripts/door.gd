class_name Door; extends StaticBody3D

const FLOAT_DURATION = 2
const TENANT_THEME_NEUTRAL = preload("res://assets/audio/Music/tenant_theme_1_(neutral).wav")
const TENANT_THEME_SAD = preload("res://assets/audio/Music/tenant_theme_2_(sad).wav")
const TENANT_THEME_HIPHOP = preload("res://assets/audio/Music/tenant_theme_3_(hiphop).wav")
const TENANT_THEME_ANGRY = preload("res://assets/audio/Tenant Voices/Tenant Theme Angry.wav")

@onready var gamestate_manager: Node = get_node("/root/Gamemanager/New_Apartment/Core/GameManager")
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
@onready var scoreshow = preload("res://Manage/score.tscn")

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio_door: AudioStreamPlayer = $Sounds/Door
@onready var audio_music: AudioStreamPlayer = $Sounds/Music
@onready var TPoint = $TenantPoint

var room
var score_label
const DOOR_SLAM = preload("res://assets/audio/SFX/Door/Door Close.wav")
const DOOR_OPEN = preload("res://assets/audio/SFX/Door/Door Open.wav")
const DOORKNOB = preload("res://assets/audio/SFX/Door/doorknob.wav")

func _ready():
	$Frame/DoorHingePoint/Label3D.text = address

func interacted():
	if !delivery_active or tenant_name == "":
		audio_door.set_stream(DOORKNOB)
		audio_door.play()
		print("There is no tenant in this room!")
		return
		
	audio_door.set_stream(DOOR_OPEN)
	audio_door.play()
	door_interaction_begin.emit(self)
	
func _toggle_door_state():
	if open:
		_end_current_minigame()
	else:
		var music = [TENANT_THEME_NEUTRAL, TENANT_THEME_SAD, TENANT_THEME_HIPHOP, TENANT_THEME_ANGRY].pick_random()
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
		delivery_active = false
		tenant_name = ""
		current_minigame.queue_free()

func _minigame_completed(new_score):
	gamestate_manager.add_score(new_score)
	_end_current_minigame()
	door_interaction_end.emit(self)
	animation_player.play("close_door")
	_display_score(new_score)
	audio_music.stop()
	await animation_player.animation_finished
	TPoint.get_child(0).queue_free()
	
func _display_score(score):
	
	score_label = scoreshow.instantiate() ;$Frame.add_child(score_label)
	score_label.text = "+" + str(score) #Keeps recieving error after around second or third round of stamping papers.
	var start_pos = score_label.position
	var end_pos = start_pos + Vector3(0, 2, 0)
	var tween = create_tween()
	tween.set_parallel(true)
	
	tween.tween_property(score_label, "modulate:a", 1.0, 0.6)
	tween.chain().tween_property(score_label, "modulate:a", 0.0, 1)
	tween.tween_property(score_label, "position", end_pos, FLOAT_DURATION).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	await tween.finished
	
	score_label.queue_free()

func remove_room(anim_name):
	if anim_name == "close_door":
		room_position.get_child(0).queue_free()
