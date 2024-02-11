extends AnimatedSprite2D

func _ready():
	self.animation_finished.connect(self._on_animation_finished)
	play("Animate")

func _on_animation_finished():
	queue_free()