class_name Player; extends CharacterBody3D 

const eviction_list = preload("res://Manage/eviction_list.tscn")
const FootstepA = preload("res://assets/audio/General/SFX - Footstep 1.wav")
const FootstepB = preload("res://assets/audio/General/SFX - Footstep 2.wav")
const FootstepC = preload("res://assets/audio/General/SFX - Footstep 3.wav")
const FootstepD = preload("res://assets/audio/General/SFX - Footstep 4.wav")

const EVICT_1 = preload("res://assets/audio/UI/Evict1.wav")
const EVICT_2 = preload("res://assets/audio/UI/Evict2.wav")

@export_category("Mouse Capture")
@export var CAPTURE_MOUSE_ON_START := true

@export_category("Movement")
@export_subgroup("Settings")
@export var MOVEMENT_ENABLED: bool = true
@export var SPEED := 6
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
@export var INTERACTION_ENABLED := true
@export var MOUSE_ACCELERATION_ENABLED := true
@export var KEY_BIND_MOUSE_SENSITIVITY := 0.005
@export var KEY_BIND_MOUSE_ACCELERATION := 50

var speed: float = SPEED
var accel = ACCELERATION

# Used when lerping rotation to reduce stuttering when moving the mouse
var rotation_target_player: float
var rotation_target_head: float

var stored_head_x_rotation: float
var checking_list: bool = false # Is the player currently checking their list?
var loaded_list: MeshInstance3D
@onready var apartment: Node = get_node("/root/Gamemanager/New_Apartment")
@onready var gamestate_manager: Node = apartment.get_node("Core/GameManager")

# Used when bobing head
@onready var head_start_pos : Vector3 = $Head.position
@onready var head: Node3D = $Head
@onready var ray: RayCast3D = $Head/Look
@onready var audio_player = $FootSteps

var tick = 0 # Current player tick, used in head bob calculation
var moving := false

func _ready():
	apartment.find_child("OfficeDoor").begin_game.connect(_show_tab_hint, CONNECT_ONE_SHOT)
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
		
	if Input.is_action_just_pressed("check_list"):
		_check_list(delta)
		
	update_other_ui($UI/Dot.visible)
		
func update_other_ui(interact):
	if interact:
		$OtherUI/Interact.modulate.a = lerp($OtherUI/Interact.modulate.a, float(1), 0.5)
	else:
		$OtherUI/Interact.modulate.a = lerp($OtherUI/Interact.modulate.a, float(0), 0.5)

func _unhandled_input(event):
	if Engine.is_editor_hint():
		return
		
	if !INTERACTION_ENABLED:
		return
		
	if Input.is_action_just_pressed("Interact"):
		var collided = ray.get_collider()
			
		if collided:
			print("Raycast collided with " + collided.get_class())
			
			if collided is Door:
				collided.door_interaction_begin.connect(_door_interaction_begin, CONNECT_ONE_SHOT)
				collided.door_interaction_end.connect(_door_interaction_end, CONNECT_ONE_SHOT)
				collided.interacted()
				
			if collided is Stamp:
				collided.enter_desk()
				
			if collided.name == "OfficeDoor": # I think I almost just threw up writing this
				collided.interacted()
		
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
		
func _check_list(delta):	
	if is_instance_valid(loaded_list):
		loaded_list.queue_free()
	
	if !checking_list:
		_freeze()
		loaded_list = eviction_list.instantiate()
		head.get_parent().add_child(loaded_list)
		loaded_list.position = head.position + Vector3(0, -0.3, -0.1) # Position in front of the player
		
		var vbox = loaded_list.find_child("Addresses", true)
		for i in gamestate_manager.delivery_doors:
			print(i.address)
			var label = vbox.get_child(0).duplicate()
			vbox.add_child(label)
			label.text = i.address
		vbox.get_child(0).queue_free()
		loaded_list.get_node("AudioStreamPlayer").play()
		
		stored_head_x_rotation = head.rotation.x
		head.rotation.x = deg_to_rad(-60) # Instantly snap to it
	else:
		head.rotation.x = lerp_angle(head.rotation.x, stored_head_x_rotation, delta)
		_unfreeze()
		
	checking_list = !checking_list
		

func _freeze() -> void:
	MOVEMENT_ENABLED = false
	HEAD_BOB_ENABLED = false
	moving = false
	
func _unfreeze() -> void:
	MOVEMENT_ENABLED = true
	HEAD_BOB_ENABLED = true
	
func _door_interaction_begin(door: Door) -> void:
	_freeze()
	INTERACTION_ENABLED = false
	door._toggle_door_state()
	
func _door_interaction_end(door: Door) -> void:
	_unfreeze()
	INTERACTION_ENABLED = true
	door._toggle_door_state()
	gamestate_manager.remove_tenant(door.address)
	
	$UI/EvictedIcon.visible = true
	var audio = [EVICT_1, EVICT_2].pick_random()
	$UI/EvictAudio.set_stream(audio) ; $UI/EvictAudio.play()
	$UI/UIAnim.play("Evicted")

func raycast_check():
	if ray.is_colliding():
		var obj = ray.get_collider()
		if obj.is_in_group("Interactable"):
			$UI/Dot.visible = true
	else:
		$UI/Dot.visible = false
		
func _show_tab_hint():
	$OtherUI.visible = true
	await get_tree().create_timer(1).timeout
	$OtherUI/Tab.modulate.a = lerp($OtherUI/Interact.modulate.a, float(1), 0.5)
	await get_tree().create_timer(1).timeout
	$OtherUI/Tab.modulate.a = lerp($OtherUI/Interact.modulate.a, float(0), 0.5)
	$OtherUI.visible = false
