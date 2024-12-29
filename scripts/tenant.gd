extends Node3D

enum Emote {
	
	Happy = 0,
	Sad = 1,
	Neutral = 2,
	Angry = 3,
	Shocked = 4,
}

@export var active_emote: int

#Icons
const MAD_TEMP_ICON = preload("res://assets/images/MadTempIcon.png")
const SAD_TEMP_ICON = preload("res://assets/images/SadTempIcon.png")
const SHOCKED_TEMP_ICON = preload("res://assets/images/ShockedTempIcon.png")
const HAPPY_TEMP_ICON = preload("res://assets/images/HappyTempIcon.png")

func _ready():
	active_emote = Emote.Neutral
	clampi(active_emote, 0, 4)

func _process(_delta):
	
	if active_emote > 4: active_emote = 0
	elif active_emote < 0: active_emote = 4
	
	match Emote.find_key(active_emote):
		"Happy":
			$Emotion.material.albedo_texture = HAPPY_TEMP_ICON
		"Sad":
			$Emotion.material.albedo_texture = SAD_TEMP_ICON
		"Angry":
			$Emotion.material.albedo_texture = MAD_TEMP_ICON
		"Shocked":
			$Emotion.material.albedo_texture = SHOCKED_TEMP_ICON
