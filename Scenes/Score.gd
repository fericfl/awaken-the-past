extends Label


func _process(float) -> void:
	self.text = "SCORE: " + str(Global.score)
