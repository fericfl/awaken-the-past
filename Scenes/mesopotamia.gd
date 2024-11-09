extends Node2D

func _ready() -> void:
    # Start the Dialogic timeline
    start_dialog()

func start_dialog():
    # Connect to the timeline_ended signal
    Dialogic.timeline_ended.connect(_on_timeline_ended)
    Dialogic.start("mesopotamia")

func _on_timeline_ended():
    # Disconnect the signal to prevent it from firing multiple times
    Dialogic.timeline_ended.disconnect(_on_timeline_ended)
    
    # Change to the new scene
    get_tree().change_scene_to_file("res://Scenes/control_page.tscn")
