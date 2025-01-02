class_name Door; extends StaticBody3D

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

signal door_interaction_begin(door_node)
signal door_interaction_end(door_node)

var current_minigame
var delivery_active: bool = false # Is a delivery active on this door?
var open: bool = false

@export_group("Tenant Info")
@export var address: String = ""
@export var tenant_name: String = ""

@export_group("Minigame")
@export var max_middle_names: int = 3
@export var minigame = preload("res://scenes/typing_minigame.tscn")

@onready var room_a = preload("res://Manage/room_a.tscn")
@onready var room_b = preload("res://Manage/room_b.tscn")
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var goto_position: Vector3 = $GotoPosition.position
@onready var current_camera: Camera3D = get_viewport().get_camera_3d()
@onready var audio_open_door: AudioStreamPlayer = $Sounds/Door
@onready var room_position = $RoomPoint

var room
const DOOR_SLAM = preload("res://assets/audio/General/Door_Slam.mp3")
const DOOR_OPEN = preload("res://assets/audio/General/Door_open.mp3")

func _ready():
	pass

func choose(list):
	list.shuffle()
	return list.front()

func clicked():
	if !delivery_active or tenant_name == "":
		print("There is no tenant in this room!")
		return
	audio_open_door.set_stream(DOOR_OPEN) ; audio_open_door.play()
	door_interaction_begin.emit(self)
	
func _toggle_door_state():
	if open:
		_end_current_minigame()
	else:
		animation_player.play("open_door")
		room = choose([room_a, room_b]).instantiate()
		room_position.add_child(room)
		await get_tree().create_timer(2)
		_start_minigame()
		
		
	open = !open
		
func _toggle_camera_focus():
	var camera = get_viewport().get_camera_3d()
	
func _start_minigame():
	_end_current_minigame()
		
	current_minigame = minigame.instantiate()
	current_minigame.prompt = tenant_name
	get_tree().root.add_child(current_minigame)
	current_minigame.minigame_completed.connect(_minigame_completed, CONNECT_ONE_SHOT)
	
func _end_current_minigame():
	if current_minigame != null:
		audio_open_door.set_stream(DOOR_SLAM) ; audio_open_door.play()
		current_minigame.queue_free()

func _minigame_completed():
	_end_current_minigame()
	door_interaction_end.emit(self)
	animation_player.play("close_door")


func remove_room(anim_name):
	if anim_name == "close_door":
		room_position.get_child(0).queue_free()