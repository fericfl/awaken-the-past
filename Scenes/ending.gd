extends Node2D

func _ready() -> void:
	# Start the Dialogic timeline
	start_dialog()

func start_dialog():
	# Connect to the timeline_ended signal
	Dialogic.timeline_ended.connect(_on_timeline_ended)
	Dialogic.start("ending")

func _on_timeline_ended():
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	get_tree().quit()
