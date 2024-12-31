class_name Player; extends CharacterBody3D 

@export_category("Mouse Capture")
@export var CAPTURE_MOUSE_ON_START := true

@export_category("Movement")
@export_subgroup("Settings")
@export var MOVEMENT_ENABLED: bool = true
@export var SPEED := 5
@export var ACCELERATION := 50.0

@export_subgroup("Head Bob")
@export var HEAD_BOB_ENABLED := true
@export var HEAD_BOB_FREQUENCY := 0.3
@export var HEAD_BOB_INTENSITY := 0.01

@export_subgroup("Clamp Head Rotation")
@export var CLAMP_HEAD_ROTATION_ENABLED := true
@export var CLAMP_HEAD_ROTATION_MIN := -90.0
@export var CLAMP_HEAD_ROTATION_MAX := 90.0

@export_category("Key Binds")
@export_subgroup("Mouse")
@export var MOUSE_ACCELERATION_ENABLED := true
@export var KEY_BIND_MOUSE_SENSITIVITY := 0.005
@export var KEY_BIND_MOUSE_ACCELERATION := 50

var speed: float = SPEED
var accel = ACCELERATION

# Used when lerping rotation to reduce stuttering when moving the mouse
var rotation_target_player : float
var rotation_target_head : float

# Used when bobing head
@onready var head_start_pos : Vector3 = $Head.position
@onready var head: Node3D = $Head
@onready var ray: RayCast3D = $Head/Look
@onready var audio_player = $FootSteps

#Footsteps to pick from
const FootstepA = preload("res://assets/audio/General/SFX - Footstep 1.wav")
const FootstepB = preload("res://assets/audio/General/SFX - Footstep 2.wav")
const FootstepC = preload("res://assets/audio/General/SFX - Footstep 3.wav")
const FootstepD = preload("res://assets/audio/General/SFX - Footstep 4.wav")

# Current player tick, used in head bob calculation
var tick = 0
var moving := false

func _ready():
	$Head.find_child("Camera3D").make_current()
	if Engine.is_editor_hint():
		return

	if CAPTURE_MOUSE_ON_START:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta):
	if Engine.is_editor_hint():
		return
		
	tick += 1 # Increment player tick, used in head bob motion
	
	if MOVEMENT_ENABLED:
		move_player(delta)
		rotate_player(delta)
	
	if HEAD_BOB_ENABLED:
		if velocity: # If the player is moving, bob their head
			head_bob_motion()
		reset_head_bob(delta)
		
	update_other_ui($UI/Dot.visible)
		
func update_other_ui(interact):
	if interact:
		$OtherUI/Interact.modulate.a = lerp($OtherUI/Interact.modulate.a, float(1), 0.5)
	else:
		$OtherUI/Interact.modulate.a = lerp($OtherUI/Interact.modulate.a, float(0), 0.5)

func _unhandled_input(event):
	if Engine.is_editor_hint():
		return
		
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			var collided = ray.get_collider()
			
			if collided:
				print("Raycast collided with " + collided.get_class())
				if collided is Door:
					collided.door_interaction_begin.connect(_door_interaction_begin, CONNECT_ONE_SHOT)
					collided.door_interaction_end.connect(_door_interaction_end, CONNECT_ONE_SHOT)
					collided.clicked()
					
			
	if event is InputEventMouseMotion && Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		set_rotation_target(event.relative)

func set_rotation_target(mouse_motion : Vector2):
	rotation_target_player += -mouse_motion.x * KEY_BIND_MOUSE_SENSITIVITY # Add player target to the mouse -x input
	rotation_target_head += -mouse_motion.y * KEY_BIND_MOUSE_SENSITIVITY # Add head target to the mouse -y input
	
	if CLAMP_HEAD_ROTATION_ENABLED:
		rotation_target_head = clamp(rotation_target_head, deg_to_rad(CLAMP_HEAD_ROTATION_MIN), deg_to_rad(CLAMP_HEAD_ROTATION_MAX))
	
func rotate_player(delta):
	if MOUSE_ACCELERATION_ENABLED:
		# Shperical lerp between player rotation and target
		quaternion = quaternion.slerp(Quaternion(Vector3.UP, rotation_target_player), KEY_BIND_MOUSE_ACCELERATION * delta)
		# Same again for head
		head.quaternion = head.quaternion.slerp(Quaternion(Vector3.RIGHT, rotation_target_head), KEY_BIND_MOUSE_ACCELERATION * delta)
	else:
		# If mouse accel is turned off, simply set to target
		quaternion = Quaternion(Vector3.UP, rotation_target_player)
		head.quaternion = Quaternion(Vector3.RIGHT, rotation_target_head)
	
func move_player(delta):
	speed = SPEED
	accel = ACCELERATION

	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("left", "right", "forward", "back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if input_dir != Vector2.ZERO: moving = true #Im sorry for your eyes in advance
	else: moving = false

	velocity.x = move_toward(velocity.x, direction.x * speed, accel * delta)
	velocity.z = move_toward(velocity.z, direction.z * speed, accel * delta)

	move_and_slide()

func head_bob_motion():
	var pos = Vector3.ZERO
	pos.y += sin(tick * HEAD_BOB_FREQUENCY) * HEAD_BOB_INTENSITY
	pos.x += cos(tick * HEAD_BOB_FREQUENCY / 2) * HEAD_BOB_INTENSITY * 2
	head.position += pos

func reset_head_bob(delta):
	# Lerp back to the staring position
	if head.position == head_start_pos:
		pass
	head.position = lerp(head.position, head_start_pos, 2 * (1/HEAD_BOB_FREQUENCY) * delta)

func movement_check():
	if moving:
		var footstep_sound = [FootstepA, FootstepB, FootstepC, FootstepD].pick_random()
		
		audio_player.set_stream(footstep_sound)
		audio_player.pitch_scale = randf_range(0.7, 1.3) 
		audio_player.play()

func _freeze() -> void:
	MOVEMENT_ENABLED = false
	HEAD_BOB_ENABLED = false
	moving = false
	
func _unfreeze() -> void:
	MOVEMENT_ENABLED = true
	HEAD_BOB_ENABLED = true
	
func _door_interaction_begin(door: Door) -> void:
	_freeze()
	door._toggle_door_state()
	
func _door_interaction_end(door: Door) -> void:
	_unfreeze()
	door._toggle_door_state()

func raycast_check():
	if ray.is_colliding():
		var obj = ray.get_collider()
		if obj.is_in_group("Interactable"):
			print("You can interact with this object")
			$UI/Dot.visible = true
	else:
		$UI/Dot.visible = false
