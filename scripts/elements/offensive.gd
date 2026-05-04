extends TextureRect

@onready var label_count = $OffensiveLabel
@onready var UserService = preload("res://scripts/services/user_service.gd").new()

func _ready() -> void:
	add_child(UserService)
	UserService.load_or_create_user()
	# Verifica se a ofensiva expirou ao abrir a tela
	UserService.check_streak_expiry()
	update_ui()

func update_ui():
	var data = UserService.get_streak_data()
	label_count.text = str(int(data["count"]))
	
	# Se a ofensiva for 0, podemos deixar o ícone cinza
	if data["count"] > 0:
		self.modulate = Color(1, 1, 1) # Normal
	else:
		self.modulate = Color(0.557, 0.557, 0.557, 0.62) # Apagado
