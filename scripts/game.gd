extends Node3D

#Any and everything related to the game. We can break it into individual nodes later on

var tenants = []
var evictions_left = 0

func new_tenant(name: String):
	print("New tenant created! Their name is: ", name)
	tenants.append(name)
	print(tenants)

func Replay_Ambience():
	$Environment/Ambience.play()
