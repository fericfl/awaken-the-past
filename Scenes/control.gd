extends Control

func _ready():
	$Timer.start()  # Pornește cronometrul

func _on_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://Scenes/platformer.tscn")
