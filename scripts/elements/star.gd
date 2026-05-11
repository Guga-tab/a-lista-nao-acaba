extends TextureRect

@onready var stars_label = $StarLabel

func _ready() -> void:
	UserService.load_or_create_user()
	update_stars_ui()

func update_stars_ui():
	var stars = UserService.get_stars_balance()
	
	stars_label.text = str(int(stars))
	if stars > 0:
		self.modulate = Color(1, 1, 1, 1)
	else:
		self.modulate = Color(0.8, 0.8, 0.8, 0.8)
