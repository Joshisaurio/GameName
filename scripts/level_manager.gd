extends Node

@export var intro = preload("res://Manage/intro_video.tscn")
@export var title_scene = preload("res://scenes/title.tscn")
@export var stamping = preload("res://scenes/stamping.tscn")
@export var apartment = preload("res://scenes/new_apartment.tscn")
var current_scene

@export var player_name := ""
@export var default_name := "Landlord"

func _ready():
	load_level(intro)

func load_level(level: PackedScene): #Takes preloaded scenes and swaps them with the current one.
	if current_scene != null:
		current_scene.queue_free()
	current_scene = level.instantiate()
	self.add_child(current_scene) #Gamemanager remains central to easily store the data across games, just needs a save data thing.
