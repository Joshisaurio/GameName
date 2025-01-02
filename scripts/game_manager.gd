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
			
func remove_tenant(address) -> void:
	if delivery_doors.size() == 0:
		return
		
	for i in delivery_doors.size():
		var door = delivery_doors[i]
		if door.address.contains(str(address)):
			delivery_doors.remove_at(i)
			return
			
	print("No address ", address, " found.")
	return
			
