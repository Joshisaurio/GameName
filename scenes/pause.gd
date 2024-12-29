extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	visible = get_tree().paused
	if Input.is_action_just_released("pause"):
		get_tree().paused = not get_tree().paused
