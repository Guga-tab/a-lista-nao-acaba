extends TextureRect

@onready var label_count = $OffensiveLabel

func _ready() -> void:
	UserService.load_or_create_user()
	UserService.check_streak_expiry()
	update_ui()

func update_ui():
	var data = UserService.get_streak_data()
	var count = int(data["count"])
	
	label_count.text = str(count)
	
	if count > 0:
		self.modulate = Color(1, 1, 1, 1) # Normal
	else:
		self.modulate = Color(1, 1, 1, 0.4) # Apagado
