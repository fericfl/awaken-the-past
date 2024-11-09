extends CharacterBody2D

const SPEED = 500.0
const JUMP_VELOCITY = -700.0
const MAX_JUMPS = 2  # Numărul maxim de sărituri (inclusiv double jump)

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


func _on_pineapple_body_entered(body: Node2D) -> void:
	pass




func _on_pineapple_collected() -> void:
	Global.score+=1
	print (Global.score)
	if(Global.score == 12):
		get_tree().change_scene_to_file("res://Scenes/win.tscn")

			
