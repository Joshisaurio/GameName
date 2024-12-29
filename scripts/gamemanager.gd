extends Node

#Gamemanager can load levels and keep track of data without needing to throw the data everywhere

@export var title_scene = preload("res://scenes/title.tscn")
@export var stamping = preload("res://scenes/stamping.tscn")
@export var apartment = preload("res://scenes/apartment.tscn")
var current_scene

@export var player_name := ""

func _ready():
	
	load_level(title_scene)

func load_level(level: PackedScene): #Takes preloaded scenes and swaps them with the current one.
	if current_scene != null:
		current_scene.queue_free()
	current_scene = level.instantiate()
	self.add_child(current_scene) #Gamemanager remains central to easily store the data across games, just needs a save data thing.
