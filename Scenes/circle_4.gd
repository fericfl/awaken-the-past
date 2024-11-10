extends Sprite2D

# Rotation target and speed
var target_rotation : float = 0.0
var is_rotating : bool = false
var rotation_speed : float = 180.0  # Degrees per second

# Input function to detect clicks
func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT and not is_rotating:
		var mouse_pos = get_viewport().get_mouse_position()
		var local_pos = to_local(mouse_pos)
		
		var texture_size = texture.get_size() / 2
		if abs(local_pos.x) <= texture_size.x and abs(local_pos.y) <= texture_size.y:
			target_rotation = float(rotation_degrees + 90.0)
			target_rotation = fmod(target_rotation, 360.0)
			is_rotating = true

			# Play the rotation sound
			$AudioStreamPlayer2D.play()

# Smooth rotation in the _process function
func _process(delta):
	if is_rotating:
		var rotation_difference = target_rotation - rotation_degrees
		if rotation_difference > 180.0:
			rotation_difference -= 360.0
		elif rotation_difference < -180.0:
			rotation_difference += 360.0
		
		var rotation_step = rotation_speed * delta
		if abs(rotation_difference) <= rotation_step:
			rotation_degrees = target_rotation
			is_rotating = false
			
			# Update the rotation state in the Singleton
			RotationManager.update_rotation(name, rotation_degrees)
		else:
			rotation_degrees += sign(rotation_difference) * rotation_step
