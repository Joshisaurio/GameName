extends Node3D

#Game settings
var Audio := 100
var Music := 100
var WindowType = "Windowed"

@onready var play = $FolderMenu/Front/Playlbl
@onready var settings = $FolderMenu/Front/Settingslbl
@onready var quit = $FolderMenu/Front/Quitlbl
@onready var audio = $FolderMenu/Paper/Audio
@onready var music = $FolderMenu/Paper/Music
@onready var screenres = $FolderMenu/Paper/Screen
@onready var data = $FolderMenu/Paper/Data
@onready var main = $FolderMenu/Paper/Main

#Credits Page
@onready var credit_return = $FolderMenu/Paper/ReturnCred
@onready var credit = $FolderMenu/Front/Creditlbl

@onready var folderaudio = $FolderMenu/FolderSound
@onready var hoveraudio = $FolderMenu/UIHoverSound
@onready var clickaudio = $FolderMenu/UIClickSound

@onready var gamemanager = self.get_parent()

var hover_color = Color.RED
var normal_color = Color.BLACK

#Sounds
const Folder_Close = preload("res://assets/audio/UI/SFX - UI folder Close.wav")
const Folder_Open = preload("res://assets/audio/UI/SFX - UI folder Open.wav")
const UI_Hover = preload("res://assets/audio/UI/SFX - UI Hover.wav")
const UI_Click = preload("res://assets/audio/UI/SFX - UI Select (click).wav")

var current_page := 1 # 1 is title, 2 is settings, 3 is credits

func _ready():
	$Camera3D/CamAnim.play("Camera")

func _process(_delta):
	
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE #This doesn't work in _ready()??
	print(current_page)
	
	match current_page:
		1:
			#Enable
			$FolderMenu/Front/Playlbl/PlayArea/CollisionShape3D.disabled = false
			$FolderMenu/Front/Settingslbl/SettingsArea/CollisionShape3D.disabled = false
			$FolderMenu/Front/Quitlbl/QuitArea/CollisionShape3D.disabled = false
			#Disable
			$FolderMenu/Paper/Main/Area3D/CollisionShape3D.disabled = true
			$FolderMenu/Paper/ReturnCred/returncredArea/CollisionShape3D.disabled = true
		2:
			#Enable
			$FolderMenu/Paper/Main/Area3D/CollisionShape3D.disabled = false
			#Disable
			$FolderMenu/Front/Playlbl/PlayArea/CollisionShape3D.disabled = true
			$FolderMenu/Front/Settingslbl/SettingsArea/CollisionShape3D.disabled = true
			$FolderMenu/Front/Quitlbl/QuitArea/CollisionShape3D.disabled = true
			$FolderMenu/Paper/ReturnCred/returncredArea/CollisionShape3D.disabled = true
		3:
			#Enable
			$FolderMenu/Paper/ReturnCred/returncredArea/CollisionShape3D.disabled = false
			#Disable
			$FolderMenu/Front/Playlbl/PlayArea/CollisionShape3D.disabled = true
			$FolderMenu/Front/Settingslbl/SettingsArea/CollisionShape3D.disabled = true
			$FolderMenu/Front/Quitlbl/QuitArea/CollisionShape3D.disabled = true
			$FolderMenu/Paper/Main/Area3D/CollisionShape3D.disabled = true

func _on_play_area_input_event(_camera, event, _event_position, _normal, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_mask == 1:
			clickaudio.play()
			await get_tree().create_timer(0.5).timeout
			$"2DUI/UIAnim".play("Fade")
			await  get_tree().create_timer(1.3).timeout
			gamemanager.load_level(gamemanager.apartment)

func _on_settings_area_input_event(_camera, event, _event_position, _normal, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_mask == 1:
			current_page = 2
			$FolderMenu/PageAnim.play("Flip")
			clickaudio.play()
			folderaudio.set_stream(Folder_Open) ; folderaudio.play()

func _on_quit_area_input_event(_camera, event, _event_position, _normal, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_mask == 1:
			clickaudio.play()
			await get_tree().create_timer(0.5).timeout
			$"2DUI/UIAnim".play("Fade")
			await  get_tree().create_timer(1.3).timeout
			get_tree().quit()


func _on_area_3d_input_event(_camera, event, _event_position, _normal, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_mask == 1:
			current_page = 1
			$FolderMenu/PageAnim.play_backwards("Flip")
			clickaudio.play()
			folderaudio.set_stream(Folder_Close) ; folderaudio.play()

func _on_credit_area_input_event(_camera, event, _event_position, _normal, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_mask == 1:
			current_page = 3
			$FolderMenu/PageAnim.play("Flip_Creds")
			clickaudio.play()
			folderaudio.set_stream(Folder_Open) ; folderaudio.play()
			await get_tree().create_timer(0.35).timeout ; folderaudio.play()

func _on_returncred_area_input_event(_camera, event, _event_position, _normal, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_mask == 1:
			current_page = 1
			$FolderMenu/PageAnim.play_backwards("Flip_Creds")
			clickaudio.play()
			await get_tree().create_timer(0.35).timeout
			folderaudio.set_stream(Folder_Close) ; folderaudio.play()
			await get_tree().create_timer(0.35).timeout ; folderaudio.play()

#Hover stuff
func _on_play_area_mouse_entered():
	play.modulate = hover_color
	hoveraudio.play()

func _on_play_area_mouse_exited():
	play.modulate = normal_color

func _on_settings_area_mouse_entered():
	settings.modulate = hover_color
	hoveraudio.play()

func _on_settings_area_mouse_exited():
	settings.modulate = normal_color

func _on_quit_area_mouse_entered():
	quit.modulate = hover_color
	hoveraudio.play()

func _on_quit_area_mouse_exited():
	quit.modulate = normal_color

func _on_audio_area_mouse_entered():
	audio.modulate = hover_color
	hoveraudio.play()

func _on_audio_area_mouse_exited():
	audio.modulate = normal_color

func _on_music_area_mouse_entered():
	music.modulate = hover_color
	hoveraudio.play()

func _on_music_area_mouse_exited():
	music.modulate = normal_color

func _on_screen_area_mouse_entered():
	screenres.modulate = hover_color
	hoveraudio.play()

func _on_screen_area_mouse_exited():
	screenres.modulate = normal_color

func _on_data_area_mouse_entered():
	data.modulate = hover_color
	hoveraudio.play()

func _on_data_area_mouse_exited():
	data.modulate = normal_color

func _on_area_3d_mouse_entered():
	main.modulate = hover_color
	hoveraudio.play()

func _on_area_3d_mouse_exited():
	main.modulate = normal_color


func _on_music_finished():
	$FolderMenu/Music.play()


func _on_returncred_area_mouse_entered():
	credit_return.modulate = hover_color
	hoveraudio.play()


func _on_returncred_area_mouse_exited():
	credit_return.modulate = normal_color


func _on_credit_area_mouse_entered():
	credit.modulate = hover_color


func _on_credit_area_mouse_exited():
	credit.modulate = normal_color
