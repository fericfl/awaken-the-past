extends Area2D

signal collected

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):  # Asigură-te că Player este în grupul "Player"
		emit_signal("collected")  # Emite semnalul când player-ul intră în coliziune
		queue_free()  # Distruge (elimină) ananasul
