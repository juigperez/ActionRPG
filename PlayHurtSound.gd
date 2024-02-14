extends AudioStreamPlayer

func _ready():
	self.finished.connect(self.queue_free)
