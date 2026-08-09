extends AudioStreamPlayer2D

func _ready():
	play()
	finished.connect(_on_finished)

func _on_finished():
	play()
