extends Marker3D

const A = preload("res://assets/audio/Voices/SFX - tenant arguing.wav")
const B = preload("res://assets/audio/Voices/SFX - tennant chatter.wav")
const C = preload("res://assets/audio/Radio/Radio show 1.wav")
const D = preload("res://assets/audio/Radio/Radio show 2.wav")
const E = preload("res://assets/audio/Radio/SFX - radio static loopable.wav")

var sounds = [A,B,C,D,E, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null]
var active_sound

func change_audio():
	active_sound = sounds.pick_random()
	
	$RanAud.set_stream(active_sound)
	$RanAud.play()
	$ChangeSound.start(randf_range(34,80))
