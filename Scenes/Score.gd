extends Label


func _process(float) -> void:
	self.text = "Tablets: " + str(Global.score) + "/6"
