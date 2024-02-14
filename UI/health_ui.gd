extends Control

@onready var max_hearts
@onready var hearts
@onready var heartUIFull = $HeartUIFull
@onready var heartUIEmpty = $HeartUIEmpty

func set_max_hearts(value):
	max_hearts = max(value, 1)
	if hearts:
		self.hearts = min(hearts, max_hearts)
	if heartUIEmpty != null:
		heartUIEmpty.size.x = max_hearts * 15
		
func set_hearts(value):
	hearts = clamp(value, 0, max_hearts)
	if heartUIFull != null:
		heartUIFull.size.x = hearts * 15
	
func _ready():
	set_max_hearts(PlayerStats.max_health)
	set_hearts(PlayerStats.health)
	PlayerStats.max_health_changed.connect(self.set_max_hearts)
	PlayerStats.health_changed.connect(self.set_hearts)
