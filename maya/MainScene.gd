# MainScene.gd
extends Node2D  # or the base class of your main scene

func _ready():
	# Connect the signal from RotationManager to the local function that updates the Label
	RotationManager.connect("text_output_updated", Callable(self, "_on_text_output_updated"))
	$BackgroundMusic.play()

# Function that will be called when the signal is emitted
func _on_text_output_updated(text):
	$Label.text = text  # Replace "$Label" with the actual path to your Label node
