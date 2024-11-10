extends TileMap
 
var board_size = 4
enum Layers { hidden, revealed }
var SOURCE_NUM = 5
const hidden_tile_coords = Vector2(0, 4)
const hidden_tile_alt = 1
var revealed_spots = []
var tile_pos_to_atlas_pos = {}
var score = 0
var turns_taken = 0
 
# Map tile coordinates to sound effects (assuming 8 unique sounds for pairs)
var sounds = {
	Vector2(0, 0): preload("res://sounds/sound1.mp3"),
	Vector2(0, 1): preload("res://sounds/sound3.mp3"),
	Vector2(1, 0): preload("res://sounds/sound7.mp3"),
	Vector2(1, 1): preload("res://sounds/sound4.mp3"),
	Vector2(1, 2): preload("res://sounds/sound0.mp3"),
	Vector2(0, 2): preload("res://sounds/sound6.mp3"),
	Vector2(0, 3): preload("res://sounds/sound2.mp3"),
	Vector2(1, 3): preload("res://sounds/sound5.mp3")
}
 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup_board()
	update_text()
	pass # Replace with function body.
 
func get_tiles_to_use():
	var chosen_tile_coords = []
	for i in range(2):
		chosen_tile_coords.append(Vector2(0, 0))
		chosen_tile_coords.append(Vector2(0, 1))
		chosen_tile_coords.append(Vector2(1, 0))
		chosen_tile_coords.append(Vector2(1, 1))
		chosen_tile_coords.append(Vector2(1, 2))
		chosen_tile_coords.append(Vector2(0, 2))
		chosen_tile_coords.append(Vector2(0, 3))
		chosen_tile_coords.append(Vector2(1, 3))
	chosen_tile_coords.shuffle()
	return chosen_tile_coords
 
func setup_board():
	var cards_to_use = get_tiles_to_use()
	for y in range(board_size):
		for x in range(board_size):
			var current_spot = Vector2(x, y)
			place_single_face_down_card(current_spot)
			var card_atlas_coords = cards_to_use.pop_back()
			tile_pos_to_atlas_pos[current_spot] = card_atlas_coords
			print("Tile at position ", current_spot, " has atlas coords ", card_atlas_coords)
			self.set_cell(Layers.revealed, current_spot, SOURCE_NUM, card_atlas_coords)

 
func place_single_face_down_card(coords: Vector2):
	self.set_cell(Layers.hidden, coords, SOURCE_NUM, hidden_tile_coords, hidden_tile_alt)
 
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			var global_clicked = event.position
			var pos_clicked = Vector2(local_to_map(to_local(global_clicked)))
			print(pos_clicked)
			var current_tile_alt = get_cell_alternative_tile(Layers.hidden, pos_clicked)
			if current_tile_alt == 1 and revealed_spots.size() < 2:
				self.set_cell(Layers.hidden, pos_clicked, -1)
				revealed_spots.append(pos_clicked)
 
				# Play the sound associated with the revealed tile
				play_sound_for_tile(pos_clicked)
 
				if revealed_spots.size() == 2:
					when_two_cards_revealed()
 
func play_sound_for_tile(tile_pos: Vector2):
	# Retrieve the tile atlas position to match with sound
	var tile_atlas_pos = tile_pos_to_atlas_pos.get(tile_pos, null)
	if tile_atlas_pos and sounds.has(tile_atlas_pos):
		var sound = sounds[tile_atlas_pos]
		var audio_player = AudioStreamPlayer.new()
		audio_player.stream = sound
		add_child(audio_player)
		audio_player.play()
		print("playsound: ")
		print(tile_atlas_pos)
		# Connect the finished signal to a function that frees the player
		audio_player.finished.connect(Callable(self, "_on_audio_finished").bind(audio_player))

func _on_audio_finished(audio_player):
	audio_player.queue_free()
 
func when_two_cards_revealed():
	# the cards match
	if tile_pos_to_atlas_pos[revealed_spots[0]] == tile_pos_to_atlas_pos[revealed_spots[1]]:
		score += 1
		revealed_spots.clear()
	else:
		# the cards did not match
		put_back_cards_with_delay()
	turns_taken += 1
	update_text()
 
func update_text():
	$"../CanvasLayer/score_label".text = "Score: %d" % score
	await self.get_tree().create_timer(1.0).timeout
	if score >= 8:
		get_tree().change_scene_to_file("res://Scenes/greece.tscn")
	# get_tree().change_scene(targetScene)
 
func put_back_cards_with_delay():
	await self.get_tree().create_timer(1.5).timeout
	for spot in revealed_spots:
		place_single_face_down_card(spot)
	revealed_spots.clear()
 
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
