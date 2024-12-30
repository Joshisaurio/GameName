extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = false
	$UIAnim.play("Paused")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	if Input.is_action_just_released("pause"):
		get_tree().paused = not get_tree().paused
		
	visible = get_tree().paused
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE if get_tree().paused else Input.MOUSE_MODE_CAPTURED)
	
	for i in $Buttons.get_children():
		if i.is_hovered():
			i.scale = i.scale.lerp(Vector2(1.1, 1.1), 0.5)
		else:
			i.scale = i.scale.lerp(Vector2(1.0, 1.0), 0.5)
		
func _on_resume_pressed():
	get_tree().paused = false
	$Click.play()

func _on_back_to_menu_pressed():
	$Click.play()
	get_tree().paused = false
	get_tree().get_first_node_in_group("gamemanager").load_level(preload("res://scenes/title.tscn"))

func _on_button_mouse_entered():
	$Hover.play()

func _on_settings_pressed():
	$Click.play()
