extends Node3D

@onready var dither = self.find_child("Dither")

func _ready():
	$Camera3D/Dither.visible = true

func _input(event):
	if event.is_action_pressed("Toggle_Shader"):
		dither.visible = not dither.visible
