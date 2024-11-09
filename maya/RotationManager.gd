# RotationManager.gd
extends Node

# Signal to emit updated text output
signal text_output_updated(text: String)

# Store the rotation states for each circle in degrees
var rotation_states = {"Circle2": 0, "Circle3": 0, "Circle4": 0}

# Define the words associated with each 90-degree rotation for each circle
var circle2_symbols = ["Sky", "Person", "Mountain", "Sun"]
var circle3_symbols = ["Jaguar", "Fire", "Bone", "Spirit"]
var circle4_symbols = ["Book", "Water", "Lord", "Cloud"]

# Function to update rotation state and generate output text
func update_rotation(circle_name: String, rotation: float):
	# Update the rotation state
	rotation_states[circle_name] = int(rotation)  # Store rotation in degrees
	# Check the current combination
	generate_text_output()

# Function to generate the text based on the current symbol combination
func generate_text_output():
	# Calculate the index for each circle based on rotation
	var index2 = int(rotation_states["Circle2"] / 90) % 4
	var index3 = int(rotation_states["Circle3"] / 90) % 4
	var index4 = int(rotation_states["Circle4"] / 90) % 4
	
	# Retrieve the symbol for each circle based on the current index
	var text_part2 = circle2_symbols[index2]
	var text_part3 = circle3_symbols[index3]
	var text_part4 = circle4_symbols[index4]
	
	# Combine the symbols into a single output text
	var final_text = text_part2 + " " + text_part3 + " " + text_part4
	
	# Emit the signal with the generated text
	emit_signal("text_output_updated", final_text)
