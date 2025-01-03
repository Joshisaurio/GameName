extends StaticBody3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio_door: AudioStreamPlayer = $Sounds/Door

var open: bool = false
const DOOR_OPEN = preload("res://assets/audio/SFX/Door/Door Open.wav")

signal begin_game

func _ready():
	pass

func interacted():
	if !open:
		open = true
		audio_door.set_stream(DOOR_OPEN)
		audio_door.play()
		animation_player.play("open_door")
		self.remove_from_group("Interactable")
		$CollisionShape3D.queue_free()
		begin_game.emit()
		$InteractTut.queue_free()
