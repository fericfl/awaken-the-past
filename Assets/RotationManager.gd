# RotationManager.gd
extends Node

signal text_output_updated(text: String)

# Store the rotation states for each circle in degrees
var rotation_states = {"Circle2": 0, "Circle3": 0, "Circle4": 0}

# Define the words associated with each 90-degree rotation for each circle
var circle2_symbols = ["Sky", "Person", "Mountain", "Sun"]
var circle3_symbols = ["Jaguar", "Fire", "Bone", "Spirit"]
var circle4_symbols = ["Book", "Water", "Lord", "Serpent"]

# Target combination to check
var target_combination = ["Sun", "Jaguar", "Serpent"]

# Function to update rotation state and generate output text
func update_rotation(circle_name: String, rotation: float):
	rotation_states[circle_name] = int(rotation)  # Update the rotation state
	generate_text_output()

# Function to generate the text based on current symbol combination
func generate_text_output():
	var index2 = int(rotation_states["Circle2"] / 90) % 4
	var index3 = int(rotation_states["Circle3"] / 90) % 4
	var index4 = int(rotation_states["Circle4"] / 90) % 4

	var text_part2 = circle2_symbols[index2]
	var text_part3 = circle3_symbols[index3]
	var text_part4 = circle4_symbols[index4]

	var final_text = text_part2 + " " + text_part3 + " " + text_part4
	
	# Emit the signal with the generated text for display
	emit_signal("text_output_updated", final_text)
	
	# Check if the current combination matches the target
	if [text_part2, text_part3, text_part4] == target_combination:
		go_to_next_scene()

# Function to load the next scene
func go_to_next_scene():
	# Replace "res://path/to/next_scene.tscn" with the actual path of your next scene
	get_tree().change_scene("res://path/to/menu.tscn")
