extends CharacterBody2D

# Viteza mișcării
@export var speed: float = 600
@onready var sprite_2d = $Sprite2D

func _process(delta: float) -> void:
	var direction = Vector2.ZERO

	# Detectează input-ul de la jucător
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1

	if abs(velocity.x) > 1 || abs(velocity.y) > 1:
		sprite_2d.animation = "running"
	else:
		sprite_2d.animation = "idle"

	# Normalizează direcția pentru a evita viteza mai mare pe diagonală
	direction = direction.normalized()
	
	if velocity.x != 0:
		sprite_2d.flip_h = velocity.x < 0

	# Mișcă personajul
	velocity = direction * speed
	move_and_slide()
	

func _on_area_2d_collected() -> void:
	get_tree().change_scene_to_file("res://Scenes/maya.tscn")
