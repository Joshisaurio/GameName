extends CanvasLayer

var game_over = false

@onready var cutscene = $Cutscene
@onready var gamemanager = get_tree().get_first_node_in_group("gamemanager")
# Called when the node enters the scene tree for the first time.
func _ready():
	$BG.modulate.a = 0
	$Title.modulate.a = 0
	$Quit.modulate.a = 0
	$Retry.modulate.a = 0
	
	#_begin()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if game_over:
		print("Var received")
		if cutscene.time_left < 4:
			print("startedBG")
			$BG.modulate.a = lerp($BG.modulate.a, 1.0, 0.05)
		if cutscene.time_left < 3:
			print("startedTitle")
			$Title.modulate.a = lerp($Title.modulate.a, 1.0, 0.1)
			$Title.scale = $Title.scale.lerp(Vector2(1, 1), 0.1)
		if cutscene.time_left < 2.2:
			print("startedButtons")
			$Quit.modulate.a = lerp($Quit.modulate.a, 1.0, 0.2)
			var quitval = 1.1 if $Quit.is_hovered() else 1
			$Quit.scale = $Quit.scale.lerp(Vector2(quitval, quitval), 0.2)
			$Retry.modulate.a = lerp($Retry.modulate.a, 1.0, 0.2)
			var retryval = 1.1 if $Retry.is_hovered() else 1
			$Retry.scale = $Retry.scale.lerp(Vector2(retryval, retryval), 0.2)
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		$BG.modulate.a = 0
		$Title.modulate.a = 0
		$Quit.modulate.a = 0
		$Quit.scale = Vector2(0.5, 0.5)
		$Retry.modulate.a = 0
		$Retry.scale = Vector2(0.5, 0.5)
	
func _play_sound():
	print("Sound received")
	$FinishSound.play()
	
func _begin():
	_play_sound()
	cutscene.start()
	game_over = true

func _on_quit_pressed():
	if game_over:
		gamemanager.load_level(gamemanager.title_scene)

func _on_retry_pressed():
	if game_over:
		gamemanager.load_level(gamemanager.apartment)
