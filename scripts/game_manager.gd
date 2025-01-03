extends Node

const DELIVERY_MAX: int = 8

var score: int = 0
var delivery_doors: Array[Door] = [] 
@onready var door_nodes: Array[Node] = get_tree().get_nodes_in_group("Occupied Door")

func _ready() -> void:
	pass
	
func add_tenant(tenant: String, address: int) -> void:
	if delivery_doors.size() >= DELIVERY_MAX:
		print("List is full!")
		return
		
	print("NEW TENANT: ", tenant , ", ADDRESS: ", address)
	for i in door_nodes.size():
		var door = door_nodes[i]
		if door.address.contains(str(address)):
			print("Door found: ", door.name)
			delivery_doors.append(door)
			door.delivery_active = true
			door.tenant_name = tenant
	delivery_doors.sort_custom(sort_by_district)
			
func remove_tenant(this_door: Door) -> void:
	if delivery_doors.size() == 0:
		return
		
	for i in delivery_doors.size() - 1:
		var checked_door = delivery_doors[i]
		if checked_door.address.contains(str(this_door.address)):
			delivery_doors.erase(checked_door)
		delivery_doors.sort_custom(sort_by_district)
		
	return
	
func sort_by_district(a: Door, b: Door):
	return a.address[0] < b.address[0]
	
func add_score(new_score) -> void:
	score += int(new_score)
	print("Total Score: " + str(score))
			
