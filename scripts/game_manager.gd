extends Node

const STARTING_DELIVERY_COUNT: int = 50 # Temporary, used for debug purposes

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

const DELIVERY_CAP: int = 50 # Maximum amount of doors to deliver to
							# This is normally 8 but has been increased for debug purposes

var score: int = 0
var cycle: int = 1
var middle_name_cap: int = 3 # Increases by 1 every cycle
var assigned_address: String = ""
var completed_doors: int = 0
var delivery_doors: Array[Door] = [] 
@onready var door_nodes: Array[Node] = get_tree().get_nodes_in_group("Occupied Door")

func _ready() -> void:
	print("Game manager has been loaded.")
	_start_cycle()
	_debug()

func _start_cycle() -> void:
	var num_deliveries: int = STARTING_DELIVERY_COUNT + (2 * cycle)
	var tenant_names: Array[String] = _generate_names(num_deliveries)
	door_nodes.shuffle()

	var cap = min(DELIVERY_CAP, door_nodes.size())
	if num_deliveries > cap:
		num_deliveries = cap
		
	for i in num_deliveries:
		door_nodes[i].delivery_active = true
		door_nodes[i].tenant_name = tenant_names[i]
		delivery_doors.append(door_nodes[i])
		
	assigned_address = delivery_doors[completed_doors].address
	print("Assigned Address: " + assigned_address)
		
func _end_cycle() -> void:
	for i in delivery_doors.size():
		if is_instance_valid(delivery_doors[i]):
			delivery_doors[i].active = false
			delivery_doors[i].tenant_name = ""
	
	delivery_doors.clear()
	completed_doors = 0

func _debug() -> void:
	for i in delivery_doors.size():
		if is_instance_valid(delivery_doors[i]):
			print(delivery_doors[i].tenant_name)
	
func _generate_names(count: int) -> Array[String]:
	var names: Array[String] = []
	for i in count:
		names.append(_generate_tenant_name())
		
	return names

func _generate_tenant_name() -> String:
	var first = first_names[randi() % first_names.size()]
	var last = " " + last_names[randi() % last_names.size()]
	
	var middle = ""
	var middle_name_count = randi() % ((middle_name_cap + cycle) - 1)
	for i in range(middle_name_count):
		middle += " " + middle_names[randi() % middle_names.size()]
	
	return first + middle + last
