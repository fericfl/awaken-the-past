extends CharacterBody2D

const SPEED = 600.0
const JUMP_VELOCITY = -800.0
const MAX_JUMPS = 2  # Numărul maxim de sărituri (inclusiv double jump)


# Track whether each dialogue timeline has already been triggered
var mesopotamia_first_part_started = false
var mesopotamia_half_started = false
var mesopotamia_all_tablets_started = false


@onready var sprite_2d = $Sprite2D
var jumps_left = MAX_JUMPS  # Săriturile rămase

func _on_Ananas_collected():
		print("Ananas colectat!")

func _physics_process(delta: float) -> void:
	# Add gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		# Resetăm săriturile la atingerea solului
		jumps_left = MAX_JUMPS

	# Handle jump
	if Input.is_action_just_pressed("jump") and jumps_left > 0:
		velocity.y = JUMP_VELOCITY
		jumps_left -= 1  # Consumăm o săritură
		
	if Input.is_action_just_pressed("quit"):
		get_tree().change_scene_to_file("res://Scenes/menu.tscn")
		

	# Get the input direction and handle movement/deceleration
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, 24)

	move_and_slide()
	
	

	# Update sprite flipping based on movement direction
	if abs(velocity.x) > 1:
		sprite_2d.animation = "running"
	else:
		sprite_2d.animation = "idle"
	
	# Check for jumping animation
	if not is_on_floor():
		sprite_2d.animation = "jumping"

	# Flip sprite based on direction
	if velocity.x != 0:
		sprite_2d.flip_h = velocity.x < 0
	if Global.score == 1 and not mesopotamia_first_part_started:
		mesopotamia_first_part_started = true
		Dialogic.Inputs.auto_advance.enabled_forced = true
		Dialogic.timeline_ended.connect(_on_timeline_end)
		Dialogic.start("mesopotamia_first_part")
	elif Global.score == 3 and not mesopotamia_half_started:
		mesopotamia_half_started = true
		Dialogic.timeline_ended.connect(_on_timeline_end)
		Dialogic.start("mesopotamia_half")
	elif Global.score == 6 and not mesopotamia_all_tablets_started:
		mesopotamia_all_tablets_started = true
		Dialogic.timeline_ended.connect(_on_timeline_end)
		Dialogic.Inputs.auto_advance.enabled_forced = false
		Dialogic.start("mesopotamia_all_tablets")
		_on_game_win()

func _on_timeline_end():
	Dialogic.timeline_ended.disconnect(_on_timeline_end)

func _on_pineapple_collected() -> void:
	Global.score+=1
	print (Global.score)

func _on_game_win():
	Dialogic.timeline_ended.disconnect(_on_timeline_end)
	get_tree().change_scene_to_file("res://Scenes/win.tscn")


func _on_pergament3_collected() -> void:
	Global.score+=1



func _on_pergament_2_collected() -> void:
	Global.score+=1
