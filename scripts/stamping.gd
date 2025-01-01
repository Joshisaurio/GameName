extends Node3D
class_name Stamp

@onready var Canim = $Camera3D/CamAnim
@onready var player = preload("res://Manage/player.tscn")
@onready var paper = preload("res://Manage/paper.tscn")
@onready var camera = $Camera3D
@onready var filter = $Camera3D/StampingFilter
@onready var origin = $PaperOrigin

#Main Nodes
@onready var Apartment = get_parent().get_parent()
@onready var Gamemanager = get_tree().root.get_child(0)

@export var max_middle_names: int = 3
@export var max_time:int = 30
var isSitting = true
var canStamp = false
var pageExists = false
var canRemove = false
var active_player
var tenant_name
var tenant_eviction
var tenant_first_name

var available_time = 0

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

var stage = 0

var stages = [
	"( Press [D] to grab a paper )",
	"( [Click] to stamp )",
	"( Press [A] to remove the paper)",
	"( Press [E] to exit )"
]

var time_left = 30

var begun = false

func _ready():
	$UI/time_earned.visible = false
	$UI/time_left.visible = false

func _begin():
	filter.visible = true
	$Guide.visible = true
	$UI/time_earned.visible = true
	$UI/time_left.visible = true
	$UI/time_left.max_value = max_time
	begun = true

func _process(delta):
	if begun and isSitting:
		$UI.visible = true
		time_left -= delta
		$UI/time_left.value = time_left
	else:
		$UI.visible = false

func _input(event):
	if begun:
		if time_left > 0:
			if Input.is_action_just_pressed("right"):
				if isSitting and not pageExists:
					create_eviction()
					pageExists = true
					canStamp = true
					tenant_eviction = paper.instantiate()
					tenant_eviction.tenant_name = tenant_first_name
					tenant_eviction.tenant_room = randi_range(301, 382)
					origin.add_child(tenant_eviction)
					$GeneralAnim.play("Page_In")
					stage += 1
					available_time += 3
					$UI/time_earned.text = "Time earned:" + str(available_time) + "s"
			
			if Input.is_action_just_pressed("Click"):
				if canStamp:
					if tenant_eviction != null:
						tenant_eviction.isStamped = true
						canStamp = false
						canRemove = true
						stage += 1
			
			if Input.is_action_just_pressed("left"):
				if canRemove:
					$GeneralAnim.play("Page_Out")
					stage += 1
					await get_tree().create_timer(0.3).timeout
					Apartment.new_tenant(tenant_name)
					pageExists = false
					canRemove = false
					$PaperOrigin.get_child(0).queue_free()
			
		if Input.is_action_just_pressed("Interact"):
			if isSitting:
				Canim.play("Exit_Stamp")
				get_tree().get_first_node_in_group("countdown").starting_time += available_time
				available_time = 0
				get_tree().get_first_node_in_group("countdown").countdown.emit()
				
		if stage < len(stages) - 1:
			$Guide/Guide.text = stages[stage]
		else:
			$Guide/Guide.hide()

func enter_desk():
	isSitting = true
	Canim.play("Enter_Stamp")
	camera.make_current()
	filter.visible = true
	Canim.play("Enter_Stamp")
	active_player.queue_free()

func create_eviction():
	_generate_name()

func _generate_name() -> String:
	var first = first_names[randi() % first_names.size()]
	var last = " " + last_names[randi() % last_names.size()]
	
	var middle = ""
	var middle_name_count = randi() % max_middle_names
	for i in range(middle_name_count):
		middle += " " + middle_names[randi() % middle_names.size()]
	
	tenant_name = first + middle + last
	tenant_first_name = first
	return first + middle + last

func CamAnim_Finished(anim_name):
	match anim_name:
		"Exit_Stamp":
			active_player = player.instantiate()
			Apartment.add_child(active_player)
			filter.visible = false
			isSitting = false
			active_player.global_position.x = camera.global_position.x
			active_player.global_position.z = camera.global_position.z
			active_player.global_position.y = 1.5
			
