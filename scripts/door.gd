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

signal door_interaction_requested(door_node)

var current_minigame
var open: bool = false

@export_group("Tenant Info")
@export var address: String = ""
@export var tenant_name: String = ""

@export_group("Minigame")
@export var max_middle_names: int = 3
@export var minigame = preload("res://scenes/typing_minigame.tscn")

@onready var door_panel: MeshInstance3D = $Panel
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var goto_position: Node3D = $GotoPosition
@onready var current_camera = get_viewport().get_camera_3d()

func _ready():
	_generate_tenant_name()
	
func clicked():
	door_interaction_requested.emit(self)
	
func _toggle_door_state():
	if open:
		_end_current_minigame()
	else:
		_start_minigame()
		
	open = !open
		
func _toggle_camera_focus():
	var camera = get_viewport().get_camera_3d()
	
func _generate_tenant_name() -> void:
	var first = first_names[randi() % first_names.size()]
	var last = " " + last_names[randi() % last_names.size()]
	
	var middle = ""
	var middle_name_count = randi() % max_middle_names
	for i in range(middle_name_count):
		middle += " " + middle_names[randi() % middle_names.size()]
	
	tenant_name = first + middle + last
	
func _start_minigame():
	_end_current_minigame()
		
	current_minigame = minigame.instantiate()
	get_tree().root.add_child(current_minigame)
	
func _end_current_minigame():
	if current_minigame != null:
		current_minigame.queue_free()
