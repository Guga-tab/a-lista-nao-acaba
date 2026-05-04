extends TextureRect

@onready var stars_label = $StarLabel
@onready var UserService = preload("res://scripts/services/user_service.gd").new()

func _ready() -> void:
	add_child(UserService)
	UserService.load_or_create_user()
	update_stars_ui()

func update_stars_ui():
	var stars = UserService.get_stars_balance()
	
	stars_label.text = str(int(stars))
	
	# Se não tiver estrelas, fica meio transparente/apagado
	if stars > 0:
		self.modulate = Color(1, 1, 1)
	else:
		self.modulate = Color(1.0, 1.0, 1.0, 1.0)
